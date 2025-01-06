// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gym_log/entities/exercise.dart';

import 'package:gym_log/entities/log.dart';
import 'package:gym_log/utils/init.dart';
import 'package:gym_log/utils/run_fs.dart';

import 'exercise_repository.dart';

class LogRepository {
  final Exercise exercise;

  LogRepository(this.exercise);

  CollectionReference<Map<String, dynamic>>? _logsCollectionObj;

  Future<CollectionReference<Map<String, dynamic>>> _logsCollection() async {
    if (_logsCollectionObj != null) return _logsCollectionObj!;

    var exerciseQuery = await fs
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('exercises')
        .where('category', isEqualTo: exercise.category)
        .where('name', isEqualTo: exercise.name)
        .limit(1)
        .get();

    var exerciseDoc = exerciseQuery.docs.first;

    _logsCollectionObj = fs
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('exercises')
        .doc(exerciseDoc.id)
        .collection('logs');

    return _logsCollectionObj!;
  }

  Future<List<Log>> getAll() async {
    var logsCollection = await _logsCollection();
    var logs = await logsCollection.get();

    log('LogRepository.getAll()');

    return logs.docs.map((log) => Log.fromFireStoreMap(log.data())).toList();
  }

  Future<void> add(Log log) async {
    var logsCollection = await _logsCollection();
    await runFs(() => logsCollection.add(log.toMap()));
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

        await batch.commit();
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
    var logsCollection = await _logsCollection();
    var logs = await logsCollection.orderBy('date').limit(1).get();

    if (logs.docs.isEmpty) return null;

    var logData = logs.docs.first;
    Log logObj = Log.fromFireStoreMap(logData.data());

    log('LogRepository.getLast()');

    return logObj;
  }

  Future<void> delete(Log log) async {
    var logsCollection = await _logsCollection();
    // TODO(otimizar usando um índice talvez)
    var logsQuery = await logsCollection
        .where('weight', isEqualTo: log.weight)
        .where('reps', isEqualTo: log.reps)
        .where('date', isEqualTo: log.date)
        // .limit(1)
        .get();

    print('');
    // await logsQuery.docs.first.reference.delete();
  }
}
