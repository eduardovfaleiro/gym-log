import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gym_log/main.dart';
import 'package:gym_log/utils/run_fs.dart';

import '../entities/exercise.dart';

class ExerciseSelectionRepository {
  final _collection = fs.collection('users').doc(fa.currentUser!.uid).collection('exercisesSelection');

  Future<void> add(Exercise exercise) async {
    await runFs(() => _collection.add({...exercise.toMap(), 'dateTime': DateTime.now()}));
  }

  Future<void> addAll(List<Exercise> exercises) async {
    WriteBatch batch = fs.batch();

    for (var exercise in exercises) {
      batch.set(_collection.doc(), {...exercise.toMap(), 'dateTime': DateTime.now()});
    }

    await runFs(() => batch.commit());
  }

  Future<Exercise?> get(Exercise exercise) async {
    var exercises = await _collection
        .where('category', isEqualTo: exercise.category)
        .where('name', isEqualTo: exercise.name)
        .limit(1)
        .get();

    if (exercises.docs.isEmpty) return null;

    var exerciseObj = Exercise.fromFireStoreMap(exercises.docs.first.data());

    log('ExerciseSelectionRepository.get($exercise)');

    return exerciseObj;
  }

  Future<List<String>> getAllFromCategory(String category) async {
    var snapshot = await _collection.where('category', isEqualTo: category).orderBy('dateTime').get();
    var docs = snapshot.docs;

    log('ExerciseSelectionRepository.getAllFromCategory($category)');

    return docs.map((doc) => doc.data()['name'] as String).toList();
  }

  Future<void> delete(Exercise exercise) async {
    var exercises = await _collection
        .where('category', isEqualTo: exercise.category)
        .where('name', isEqualTo: exercise.name)
        .limit(1)
        .get();

    var exerciseRef = exercises.docs.first.reference;
    await runFs(() => exerciseRef.delete());
  }
}
