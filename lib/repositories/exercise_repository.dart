import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gym_log/utils/init.dart';

import '../entities/exercise.dart';

// TODO(temporário)
// final translator = {
//   'Pernas': 'legs',
//   'Costas': 'back',
//   'Peito': 'chest',
//   'Ombro': 'shoulders',
//   'Abdômen': 'abs',
//   'Antebraço': 'forearm',
//   'Bíceps': 'biceps',
//   'Tríceps': 'triceps',
// };

class ExerciseRepository {
  static CollectionReference<Map<String, dynamic>> get _exercisesCollection {
    return fs.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).collection('exercises');
  }

  Future<void> add(Exercise exercise) async {
    // var query = await _exercisesCollection.where('category', isEqualTo: translator[exercise.category]).count().get();
    var query = await _exercisesCollection.where('category', isEqualTo: exercise.category).count().get();
    int count = query.count ?? 0;

    await _exercisesCollection.doc().set({
      'name': exercise.name,
      // 'category': translator[exercise.category]!.toLowerCase(),
      'category': exercise.category,
      'dateTime': DateTime.now(),
      'order': count,
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
        return _exercisesCollection
            // .where('category', isEqualTo: translator[category])
            .where('category', isEqualTo: category)
            .where('name', whereIn: exercisesNames)
            .get();
      }),
    );

    WriteBatch writeBatch = fs.batch();

    for (var exerciseSnapshot in exercisesSnapshot) {
      for (var exerciseDoc in exerciseSnapshot.docs) {
        String exerciseName = (exerciseDoc.data() as Map<String, dynamic>)['name'];
        writeBatch.update(exerciseDoc.reference, {'order': orderedExercisesMap[exerciseName]});
      }
    }

    await writeBatch.commit();
  }

  Future<void> delete(Exercise exercise) async {
    var exerciseQuery = await _exercisesCollection
        .where('name', isEqualTo: exercise.name)
        // .where('category', isEqualTo: translator[exercise.category])
        .where('category', isEqualTo: exercise.category)
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
        // await _exercisesCollection.where('category', isEqualTo: translator[category]).orderBy('order').get();
        await _exercisesCollection.where('category', isEqualTo: category).orderBy('order').get();

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

    return exercises.where((exercise) => exercise.name.toLowerCase().contains(name.toLowerCase())).toList();
  }
}
