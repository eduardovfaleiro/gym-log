import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gym_log/main.dart';
import 'package:gym_log/utils/current_user_doc_mixin.dart';
import 'package:gym_log/utils/generate_id.dart';
import 'package:gym_log/utils/get_new_order.dart';
import 'package:gym_log/utils/run_fs.dart';

import '../entities/exercise.dart';

class ExerciseRepositoryX with CurrentUserDoc {

  // TODO(continuar, tava avaliando se vale a pena botar todos os exercicios num unico documento e se isso reduz o num de leituras, em comparação com deixar tudo no doc user)
  // Future<void> add(Exercise exercise) async {
  //   final collection = getExercisesCollection();

  //   collection.
  // }
  Future<void> add(Exercise exercise) async {
    final userDoc = await getUserDoc();
    var exercises = await userDoc.get('exercises');
    int newOrder = getNewOrder(exercises);

    await runFs(
      () => userDoc.reference.update(
        {
          'exercises': FieldValue.arrayUnion([
            {...exercise.toMap(), 'id': generateId(), 'order': newOrder}
          ])
        },
      ),
    );
  }

    Future<void> delete(Exercise exercise) async {
      final userDoc = await getUserDoc();

      List<Map<String, dynamic>> logs = await userDoc.get('logs');
      logs.removeWhere((log) => log['exerciseId'] == exercise.id);

      await runFs(
      () => userDoc.reference.update(
        {
          'exercises': FieldValue.arrayRemove([exercise.toMap()]),
          'logs': logs,
        },
      ),
    );
  }

  // TODO(certeza que vai dar errado)
    Future<List<Exercise>> getAllFromCategory(String categoryId) async {
      final userDoc = await getUserDoc();
      final exercises = await userDoc.get('exercises');
    
      return exercises.where((exercise) => exercise['categoryId'] == categoryId).map((exercise) {
        return Exercise.fromFireStoreMap(exercise);
      });


    // var exercises = await _exercisesCollection.where('category', isEqualTo: category).orderBy('order').get();
    // log('ExerciseRepository.getAllFromCategory($category)');

    // return exercises.docs.map((exercise) => exercise.data()['name'] as String).toList();
  }

  /// {'exerciseId', order}
   Future<void> updateOrder({required String categoryId, required Map<String, int> orderedExercises,}) async {
    if (orderedExercises.length > 500) throw Exception();

    final userDoc = await getUserDoc();
     List<Map<String, dynamic>> exercises = await userDoc.get('exercises');
    List<Map<String, dynamic>> updatedExercises = [];

    for (var exercise in exercises) {
      if (exercise['categoryId'] != categoryId) {
        updatedExercises.add(exercise);
      } else {
        exercise['order'] = orderedExercises[exercise['id']];
        updatedExercises.add(exercise);
      }
    }

    await runFs(() => userDoc.reference.update({'exercises': updatedExercises}));
  }
}

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

    WriteBatch batch = fs.batch();

    for (var log in logs.docs) {
      batch.delete(log.reference);
    }

    batch.delete(docRef);
    await runFs(() => batch.commit());
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
