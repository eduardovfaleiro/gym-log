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
  static Future<void> add(Exercise exercise) async {
    fs
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('exercises')
        .doc()
        .set({'name': exercise.name, 'section': translator[exercise.section]!.toLowerCase()});
  }

  Future<void> delete(Exercise exercise) async {
    var exerciseQuery = await fs
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('exercises')
        .where('name', isEqualTo: exercise.name)
        .where('section', isEqualTo: translator[exercise.section])
        .get();

    if (exerciseQuery.docs.length > 1) throw Exception();

    var docRef = exerciseQuery.docs.first.reference;
    var logs = await docRef.collection('logs').get();

    for (var log in logs.docs) {
      await log.reference.delete();
    }

    await docRef.delete();
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
            name: exercise.data()['name'],
            section: exercise.data()['section'],
          ),
        )
        .toList();
  }
}
