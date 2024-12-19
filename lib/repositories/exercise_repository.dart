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
  static Future<void> add(String name, {required String section}) async {
    fs
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('exercises')
        .doc(name)
        .set({'section': translator[section]!.toLowerCase()});
  }

  static Future<List<String>> getAll() async {
    var exercises =
        await fs.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).collection('exercises').get();

    return exercises.docs.map((exercise) => exercise.id).toList();
  }

  Future<List<Exercise>> getAllFromSection(String section) async {
    var exercises = await fs
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('exercises')
        .where('section', isEqualTo: translator[section])
        .get();

    return exercises.docs
        .map(
          (exercise) => Exercise(
            name: exercise.id,
            section: exercise.data()['section'],
          ),
        )
        .toList();
  }
}
