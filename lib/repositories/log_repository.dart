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

class LogRepositoryX {
  final ExerciseX exercise;

  LogRepositoryX(this.exercise);

  DocumentReference<Map<String, dynamic>> get _exerciseDocRef {
    return fs
        .collection('users')
        .doc(fa.currentUser!.uid)
        .collection('exercises')
        .doc(exercise.id);
  }

  Future<void> add(Log log) async {
    await runFs(
      () => _exerciseDocRef.update({
        'logs': FieldValue.arrayUnion([log.toMap()])
      }),
    );
  }

  Future<List<Log>> getAll() async {
    // Acho que não vai funcionar no modo offline.
    final exerciseDoc = await _exerciseDocRef.get();

    final logs = List<Map<String, dynamic>>.from(await exerciseDoc.get('logs'));

    return logs.map((log) => Log.fromFireStoreMap(log)).toList();
  }

  Future<void> update({
    required Log newLog,
    required List<Log> currentLogList,
  }) async {
    int index = currentLogList.indexWhere((log) => log.id == newLog.id);
    currentLogList[index] = newLog;

    // Testar bem
    await runFs(
      () => _exerciseDocRef
          .update({'logs': currentLogList.map((log) => log.toMap())}),
    );
  }

  Future<void> delete(Log log) async {
    await runFs(
      () => _exerciseDocRef.update({
        'logs': FieldValue.arrayRemove([log.toMap()])
      }),
    );
  }

  // TODO(talvez mover para um service.)
  Future<Log?> getLast() async {
    log('LogRepository.getLast()');

    List<Log> logs = await getAll();
    if (logs.isEmpty) return null;

    return logs.reduce((log1, log2) {
      return log1.date.isAfter(log2.date) ? log1 : log2;
    });
  }

  Future<void> replaceAll(List<Log> logs) async {
    await runFs(
      () => _exerciseDocRef.update({
        'logs': logs.map((log) {
          // Não sei o porquê de copyWithNewId existir, mas tenho medo.
          return log.copyWithNewId().toMap();
        })
      }),
    );
  }
}

class LogRepository {
  final Exercise exercise;

  LogRepository(this.exercise);

  Future<QueryDocumentSnapshot<Map<String, dynamic>>> _exerciseDoc() async {
    var exerciseQuery = await fs
        .collection('users')
        .doc(fa.currentUser!.uid)
        .collection('exercises')
        .where('category', isEqualTo: exercise.category)
        .where('name', isEqualTo: exercise.name)
        .limit(1)
        .getX();

    return exerciseQuery.docs.first;
  }

  Future<List<Log>> getAll() async {
    log('LogRepository.getAll()');
    var exerciseDoc = await _exerciseDoc();

    var logs = await exerciseDoc.get('logs');
    return List.from(logs.map((log) => Log.fromFireStoreMap(log)));
  }

  Future<void> add(Log log) async {
    var exerciseDoc = await _exerciseDoc();

    await runFs(
      () => exerciseDoc.reference.update({
        'logs': FieldValue.arrayUnion([log.toMap()])
      }),
    );
  }

  Future<bool> isPR(Log log) async {
    var logs = await getAll();
    var logsRepMax = LogService().convertLogsToRepMax(logs);

    String today = DateTime.now().formatReadableShort();
    Log? logRepMax = logsRepMax
        .firstWhereOrNull((log) => log.date.formatReadableShort() == today);

    if (logRepMax == null || logRepMax == log) return true;
    return false;
  }

  Future<void> replaceAll(List<Log> logs) async {
    var exerciseDoc = await _exerciseDoc();

    await runFs(
      () => exerciseDoc.reference.update({
        'logs': logs.map((log) {
          return log.copyWithNewId().toMap();
        })
      }),
    );
  }

  Future<Log?> getLast() async {
    log('LogRepository.getLast()');

    var exercises = await getAll();
    if (exercises.isEmpty) return null;

    return exercises.reduce((log1, log2) {
      return log1.date.isAfter(log2.date) ? log1 : log2;
    });
  }

  Future<void> delete(Log log) async {
    var exerciseDoc = await _exerciseDoc();
    // var logs1 = await exerciseDoc.get('logs');

    await runFs(
      () => exerciseDoc.reference.update({
        'logs': FieldValue.arrayRemove([log.toMap()])
      }),
    );

    // var exerciseDoc2 = await _exerciseDoc();
    // var logs2 = await exerciseDoc.get('logs');
  }

  Future<void> update({
    required Log newLog,
    required List<Log> currentLogList,
  }) async {
    int index = currentLogList.indexWhere((log) => log.id == newLog.id);
    currentLogList[index] = newLog;

    var exerciseDoc = await _exerciseDoc();

    await runFs(
      () => exerciseDoc.reference
          .update({'logs': currentLogList.map((log) => log.toMap())}),
    );
  }
}
