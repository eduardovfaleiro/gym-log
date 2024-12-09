import 'package:firebase_auth/firebase_auth.dart';
import 'package:gym_log/utils/init.dart';

class ExerciseRepository {
  static Future<void> add(String name) async {
    await fs.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).collection('exercises').doc(name).set({});
  }

  static Future<List<String>> getAll() async {
    var exercises =
        await fs.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).collection('exercises').get();

    return exercises.docs.map((exercise) => exercise.id).toList();
  }
}
