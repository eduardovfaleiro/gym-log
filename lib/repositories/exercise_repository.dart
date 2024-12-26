import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gym_log/utils/init.dart';

import '../entities/exercise.dart';

// TODO(temporário)
final translator = {
  'Pernas': 'legs',
  'Costas': 'back',
  'Peito': 'chest',
  'Ombro': 'shoulders',
  'Abdômen': 'abs',
  'Antebraço': 'forearm',
  'Bíceps': 'biceps',
  'Tríceps': 'triceps',
};

class ExerciseRepository {
  static CollectionReference<Map<String, dynamic>> get _exercisesCollection {
    return fs.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).collection('exercises');
  }

  Future<void> add(Exercise exercise) async {
    var query = await _exercisesCollection.where('category', isEqualTo: translator[exercise.category]).count().get();
    int count = query.count ?? 0;

    await _exercisesCollection.doc().set({
      'name': exercise.name,
      'category': translator[exercise.category]!.toLowerCase(),
      'dateTime': DateTime.now(),
      'order': count + 1,
    });
  }

  Future<void> updateOrder({
    required Exercise exercise1,
    required int newOrderExercise1,
    required Exercise exercise2,
    required int newOrderExercise2,
  }) async {
    var exercises = await _exercisesCollection
        .where('category', isEqualTo: translator[exercise1.category])
        .where('name', whereIn: [exercise1.name, exercise2.name])
        .limit(2)
        .get();

    int index = exercises.docs.indexWhere((exercise) => exercise.data()['name'] == exercise1.name);
    DocumentReference<Map<String, dynamic>> exercise1Ref;
    DocumentReference<Map<String, dynamic>> exercise2Ref;

    if (index == 0) {
      exercise1Ref = exercises.docs[0].reference;
      exercise2Ref = exercises.docs[1].reference;
    } else if (index == 1) {
      exercise1Ref = exercises.docs[1].reference;
      exercise2Ref = exercises.docs[0].reference;
    } else {
      throw Exception();
    }

    WriteBatch batch = fs.batch();
    batch.update(exercise1Ref, {'order': newOrderExercise1});
    batch.update(exercise2Ref, {'order': newOrderExercise2});
    await batch.commit();
  }

  Future<void> delete(Exercise exercise) async {
    var exerciseQuery = await _exercisesCollection
        .where('name', isEqualTo: exercise.name)
        .where('category', isEqualTo: translator[exercise.category])
        .get();

    if (exerciseQuery.docs.length > 1) throw Exception();

    var docRef = exerciseQuery.docs.first.reference;
    var logs = await docRef.collection('logs').get();

    for (var log in logs.docs) {
      await log.reference.delete();
    }

    await docRef.delete();
  }

  //  Future<List<String>> getAll() async {
  //   var exercises = await _exercisesCollection.get();

  //   return exercises.docs.map((exercise) => exercise.id).toList();
  // }

  Future<List<String>> getAllFromCategory(String category) async {
    var exercises =
        await _exercisesCollection.where('category', isEqualTo: translator[category]).orderBy('order').get();

    return exercises.docs.map((exercise) => exercise.data()['name'] as String).toList();
  }

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

    return exercises.where((exercise) => exercise.name.toLowerCase().contains(name.toLowerCase())).toList();
  }
}
