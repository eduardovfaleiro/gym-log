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
  CollectionReference<Map<String, dynamic>> get _exercisesCollection {
    return fs.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).collection('exercises');
  }

  Future<void> add(Exercise exercise) async {
    _exercisesCollection.doc().set({'name': exercise.name, 'category': translator[exercise.category]!.toLowerCase()});
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
    var exercises = await fs
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('exercises')
        .where('category', isEqualTo: translator[category])
        .get();

    return exercises.docs.map((exercise) => exercise.data()['name'] as String).toList();
  }

  // TODO(talvez temporário)
  Future<List<Exercise>> getAllWithArgs({required String name}) async {
    var exercises = await _exercisesCollection
        .where('name', isGreaterThanOrEqualTo: name)
        .where('name', isLessThanOrEqualTo: '$name\uf8ff')
        .get();

    return exercises.docs
        .map(
          (exercise) => Exercise(
            name: exercise.data()['name'],
            category: exercise.data()['category'],
          ),
        )
        .toList();
  }
}
