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

  Future<List<String>> getFromSection(String section) async {
    var snapshot = await _collection.where('section', isEqualTo: translator[section]).get();
    var docs = snapshot.docs;

    print('');

    return docs.map((doc) => doc.data()['name'] as String).toList();
  }
}
