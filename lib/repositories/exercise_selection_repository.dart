import 'package:firebase_auth/firebase_auth.dart';

import '../entities/exercise.dart';
import '../utils/init.dart';
import 'exercise_repository.dart';

class ExerciseSelectionRepository {
  final _collection =
      fs.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).collection('exercisesSelection');

  Future<void> add(Exercise exercise) async {
    await _collection.add({...exercise.toMap(), 'dateTime': DateTime.now()});
  }

  Future<Exercise?> get(Exercise exercise) async {
    var exercises = await _collection
        .where('category', isEqualTo: translator[exercise.category])
        .where('name', isEqualTo: exercise.name)
        .limit(1)
        .get();

    if (exercises.docs.isEmpty) return null;

    var exerciseObj = Exercise.fromFireStoreMap(exercises.docs.first.data());
    return exerciseObj;
  }

  Future<List<String>> getAllFromCategory(String category) async {
    var snapshot = await _collection.where('category', isEqualTo: translator[category]).orderBy('dateTime').get();
    var docs = snapshot.docs;

    return docs.map((doc) => doc.data()['name'] as String).toList();
  }

  Future<void> delete(Exercise exercise) async {
    var exercises = await _collection
        .where('category', isEqualTo: translator[exercise.category])
        .where('name', isEqualTo: exercise.name)
        .limit(1)
        .get();

    var exerciseRef = exercises.docs.first.reference;
    await exerciseRef.delete();
  }
}
