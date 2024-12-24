import 'package:firebase_auth/firebase_auth.dart';

import '../entities/exercise.dart';
import '../utils/init.dart';
import 'exercise_repository.dart';

class ExerciseSelectionRepository {
  final _collection =
      fs.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).collection('exercisesSelection');

  Future<void> add(Exercise exercise) async {
    await _collection.add(exercise.toMap());
  }

  Future<List<String>> getAllFromCategory(String category) async {
    var snapshot = await _collection.where('category', isEqualTo: translator[category]).get();
    var docs = snapshot.docs;

    return docs.map((doc) => doc.data()['name'] as String).toList();
  }
}
