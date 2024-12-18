// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:gym_log/entities/log.dart';
import 'package:gym_log/utils/init.dart';

class LogRepository {
  final String exercise;

  LogRepository(this.exercise);

  CollectionReference<Map<String, dynamic>> get _logsCollection {
    return fs
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('exercises')
        .doc(exercise)
        .collection('logs');
  }

  Future<List<Log>> getAll() async {
    var logs = await _logsCollection.get();
    return logs.docs.map((log) => Log.fromFireStoreMap(log.data())).toList();
  }

  Future<void> add(Log log) async {
    await _logsCollection.add(log.toMap());
  }

  Future<void> replaceAll(List<Log> logs) async {
    bool collectionEmpty = false;
    int batchSize = 500;

    WriteBatch batch;
    QuerySnapshot querySnapshot;
    int deletedCount;

    while (!collectionEmpty) {
      querySnapshot = await _logsCollection.limit(batchSize).get();
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
      batch.set(_logsCollection.doc(), log.toMap());
    }
    await batch.commit();
  }
}
