// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import 'package:gym_log/entities/exercise.dart';
import 'package:gym_log/entities/log.dart';
import 'package:gym_log/services/log_service.dart';
import 'package:gym_log/utils/extensions.dart';
import 'package:gym_log/utils/run_fs.dart';

import '../main.dart';

class LogRepository {
  final Exercise exercise;

  LogRepository(this.exercise);

  CollectionReference<Map<String, dynamic>>? _logsCollectionObj;

  Future<CollectionReference<Map<String, dynamic>>> _logsCollection() async {
    if (_logsCollectionObj != null) return _logsCollectionObj!;

    var exerciseQuery = await fs
        .collection('users')
        .doc(fa.currentUser!.uid)
        .collection('exercises')
        .where('category', isEqualTo: exercise.category)
        .where('name', isEqualTo: exercise.name)
        .limit(1)
        .get();

    var exerciseDoc = exerciseQuery.docs.first;

    _logsCollectionObj =
        fs.collection('users').doc(fa.currentUser!.uid).collection('exercises').doc(exerciseDoc.id).collection('logs');

    return _logsCollectionObj!;
  }

  QueryDocumentSnapshot<Map<String, dynamic>>? _exerciseDocObj;

  Future<QueryDocumentSnapshot<Map<String, dynamic>>> _exerciseDoc() async {
    if (_exerciseDocObj != null) return _exerciseDocObj!;

    var exerciseQuery = await fs
        .collection('users')
        .doc(fa.currentUser!.uid)
        .collection('exercises')
        .where('category', isEqualTo: exercise.category)
        .where('name', isEqualTo: exercise.name)
        .limit(1)
        .get();

    return exerciseQuery.docs.first;
  }

  // Future<List<Log>> getAll() async {
  //   var logsCollection = await _logsCollection();
  //   var logs = await logsCollection.get();

  //   log('LogRepository.getAll()');

  //   return logs.docs.map((log) => Log.fromFireStoreMap(log.data())).toList();
  // }

  // TODO(estava reformulando a estrutura do firestore)
  Future<List<Log>> getAll() async {
    log('LogRepository.getAll()');
    var exerciseDoc = await _exerciseDoc();

    var logs = await exerciseDoc.get('logs');
    return List.from(logs.map((log) => Log.fromFireStoreMap(log)));
  }

  // Future<void> add(Log log) async {
  //   var logsCollection = await _logsCollection();
  //   await runFs(() => logsCollection.add(log.toMap()));
  // }

  Future<void> add(Log log) async {
    var exerciseDoc = await _exerciseDoc();

    await exerciseDoc.reference.update({
      'logs': FieldValue.arrayUnion([log.toMap()])
    });
  }

  Future<bool> isPR(Log log) async {
    var logs = await getAll();
    var logsRepMax = LogService().convertLogsToRepMax(logs);

    String today = DateTime.now().formatReadableShort();
    Log? logRepMax = logsRepMax.firstWhereOrNull((log) => log.date.formatReadableShort() == today);

    if (logRepMax == null) return true;
    if (logRepMax == log) return true;
    return false;
  }

  Future<void> replaceAll(List<Log> logs) async {
    var logsCollection = await _logsCollection();

    bool collectionEmpty = false;
    int batchSize = 500;

    WriteBatch batch;
    QuerySnapshot querySnapshot;
    int deletedCount;

    while (!collectionEmpty) {
      querySnapshot = await logsCollection.limit(batchSize).get();
      deletedCount = querySnapshot.docs.length;

      if (deletedCount > 0) {
        batch = fs.batch();

        for (var doc in querySnapshot.docs) {
          batch.delete(doc.reference);
        }

        await runFs(() => batch.commit());
      }

      if (deletedCount < batchSize) {
        collectionEmpty = true;
      }
    }

    batch = fs.batch();
    for (var log in logs) {
      batch.set(logsCollection.doc(), log.toMap());
    }
    await runFs(() => batch.commit());
  }

  Future<Log?> getLast() async {
    try {
      var logsCollection = await _logsCollection();
      var logs = await logsCollection.orderBy('dateTime', descending: true).limit(1).get();

      if (logs.docs.isEmpty) return null;

      var logData = logs.docs.first;
      Log logObj = Log.fromFireStoreMap(logData.data());

      return logObj;
    } finally {
      log('LogRepository.getLast()');
    }
  }

  Future<void> delete(Log log) async {
    var logsCollection = await _logsCollection();
    var logsQuery = await logsCollection.where('id', isEqualTo: log.id).limit(1).get();

    await runFs(() => logsQuery.docs.first.reference.delete());
  }

  Future<void> update({required Log oldLog, required Log newLog}) async {
    var logsCollection = await _logsCollection();

    var logsQuery = await logsCollection.where('id', isEqualTo: oldLog.id).limit(1).get();

    await runFs(() => logsQuery.docs.first.reference.update(newLog.copyWith(id: oldLog.id).toMap()));
  }
}
