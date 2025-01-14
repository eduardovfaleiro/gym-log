import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gym_log/main.dart';
import 'package:gym_log/utils/run_fs.dart';

import '../entities/exercise.dart';

class ExerciseRepository {
  static CollectionReference<Map<String, dynamic>> get _exercisesCollection {
    return fs.collection('users').doc(fa.currentUser!.uid).collection('exercises');
  }

  Future<void> add(Exercise exercise) async {
    var exercisesQuery = await _exercisesCollection
        .where('category', isEqualTo: exercise.category)
        .orderBy('order', descending: true)
        .limit(1)
        .get();

    int currentMaxOrder = exercisesQuery.docs.firstOrNull?.data()['order'] ?? 0;

    await runFs(() {
      _exercisesCollection.doc().set({
        'name': exercise.name,
        'category': exercise.category,
        'dateTime': DateTime.now(),
        'order': currentMaxOrder + 1,
      });
    });
  }

  Future<void> updateOrder({required String category, required List<OrderedExercise> orderedExercises}) async {
    if (orderedExercises.length > 500) throw Exception();

    List<List<String>> batches = [];
    int endIndex;

    Map<String, int> orderedExercisesMap = {for (var exercise in orderedExercises) exercise.name: exercise.order};

    for (int i = 0; i < orderedExercisesMap.length; i += 10) {
      endIndex = i + 10 > orderedExercisesMap.length ? orderedExercisesMap.length : i + 10;

      batches.add(orderedExercisesMap.keys.toList().sublist(i, endIndex));
    }

    List<QuerySnapshot> exercisesSnapshot = await Future.wait(
      batches.map((exercisesNames) {
        return _exercisesCollection.where('category', isEqualTo: category).where('name', whereIn: exercisesNames).get();
      }),
    );

    WriteBatch writeBatch = fs.batch();

    for (var exerciseSnapshot in exercisesSnapshot) {
      for (var exerciseDoc in exerciseSnapshot.docs) {
        String exerciseName = (exerciseDoc.data() as Map<String, dynamic>)['name'];
        writeBatch.update(exerciseDoc.reference, {'order': orderedExercisesMap[exerciseName]});
      }
    }

    await runFs(() => writeBatch.commit());
  }

  Future<void> delete(Exercise exercise) async {
    var exerciseQuery = await _exercisesCollection
        .where('name', isEqualTo: exercise.name)
        .where('category', isEqualTo: exercise.category)
        .get();

    if (exerciseQuery.docs.length > 1) throw Exception();

    var docRef = exerciseQuery.docs.first.reference;
    var logs = await docRef.collection('logs').get();

    for (var log in logs.docs) {
      await log.reference.delete();
    }

    await runFs(() => docRef.delete());
  }

  Future<List<String>> getAllFromCategory(String category) async {
    var exercises = await _exercisesCollection.where('category', isEqualTo: category).orderBy('order').get();
    log('ExerciseRepository.getAllFromCategory($category)');

    return exercises.docs.map((exercise) => exercise.data()['name'] as String).toList();
  }

  // TODO(testar bem)
  Future<List<Exercise>> getAllWithArgs({required String name}) async {
    var exercisesSnapshot = await _exercisesCollection.get(const GetOptions(source: Source.cache));

    var exercises = exercisesSnapshot.docs
        .map(
          (exercise) => Exercise(
            name: exercise.data()['name'],
            category: exercise.data()['category'],
          ),
        )
        .toList();

    log('ExerciseRepository.getAllWithArgs($name)');

    return exercises.where((exercise) => exercise.name.toLowerCase().contains(name.toLowerCase())).toList();
  }
}
