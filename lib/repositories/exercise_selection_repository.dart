import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gym_log/main.dart';
import 'package:gym_log/utils/extensions.dart';
import 'package:gym_log/utils/run_fs.dart';

import '../entities/exercise.dart';

class ExerciseSelectionRepositoryX {
  final String categoryId;

  ExerciseSelectionRepositoryX(this.categoryId);

  final _collection = fs
      .collection('users')
      .doc(fa.currentUser!.uid)
      .collection('exercisesSelection');

  Future<void> add(String exercise) async {
    await runFs(
      () => _collection.add({
        'name': exercise,
        'categoryId': categoryId,
        'createdAt': DateTime.now()
      }),
    );
  }

  // TODO(provavelmente vai dar B.O)
  Future<void> addAll(List<ExerciseX> exercises) async {
    WriteBatch batch = fs.batch();

    for (var exercise in exercises) {
      batch.set(_collection.doc(),
          {...exercise.toMap(), 'createdAt': DateTime.now()});
    }

    await runFs(() => batch.commit());
  }

  // Future<Exercise?> get(ExerciseX exercise) async {
  //   var exercises = await _collection
  //       .where('categoryId', isEqualTo: exercise.categoryId).
  //       .where('name', isEqualTo: exercise.name)
  //       .limit(1)
  //       .getX();

  //   if (exercises.docs.isEmpty) return null;

  //   var exerciseObj = Exercise.fromFireStoreMap(exercises.docs.first.data());

  //   log('ExerciseSelectionRepository.get($exercise)');

  //   return exerciseObj;
  // }

  Future<List<ExerciseX>> getAll() async {
    var snapshot = await _collection
        .where('categoryId', isEqualTo: categoryId)
        .orderBy('createdAt')
        .getX();

    log('ExerciseSelectionRepository.getAllFromCategory($categoryId)');

    return snapshot.docs
        .map((doc) => ExerciseX.fromFireStoreSnapshot(doc))
        .toList();
  }

  Future<void> delete(String exerciseId) async {
    await runFs(() => _collection.doc(exerciseId).delete());
  }
}

class ExerciseSelectionRepository {
  final _collection = fs
      .collection('users')
      .doc(fa.currentUser!.uid)
      .collection('exercisesSelection');

  Future<void> add(Exercise exercise) async {
    await runFs(() =>
        _collection.add({...exercise.toMap(), 'dateTime': DateTime.now()}));
  }

  Future<void> addAll(List<Exercise> exercises) async {
    WriteBatch batch = fs.batch();

    for (var exercise in exercises) {
      batch.set(
          _collection.doc(), {...exercise.toMap(), 'dateTime': DateTime.now()});
    }

    await runFs(() => batch.commit());
  }

  Future<Exercise?> get(Exercise exercise) async {
    var exercises = await _collection
        .where('category', isEqualTo: exercise.category)
        .where('name', isEqualTo: exercise.name)
        .limit(1)
        .getX();

    if (exercises.docs.isEmpty) return null;

    var exerciseObj = Exercise.fromFireStoreMap(exercises.docs.first.data());

    log('ExerciseSelectionRepository.get($exercise)');

    return exerciseObj;
  }

  Future<List<String>> getAllFromCategory(String category) async {
    var snapshot = await _collection
        .where('category', isEqualTo: category)
        .orderBy('dateTime')
        .getX();
    var docs = snapshot.docs;

    log('ExerciseSelectionRepository.getAllFromCategory($category)');

    return docs.map((doc) => doc.data()['name'] as String).toList();
  }

  Future<void> delete(Exercise exercise) async {
    var exercises = await _collection
        .where('category', isEqualTo: exercise.category)
        .where('name', isEqualTo: exercise.name)
        .limit(1)
        .getX();

    var exerciseRef = exercises.docs.first.reference;
    await runFs(() => exerciseRef.delete());
  }
}
