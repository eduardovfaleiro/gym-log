import 'package:gym_log/repositories/exercise_selection_repository.dart';

class AddExerciseController {
  final String category;
  final Set<String> exercisesInUse;

  const AddExerciseController({
    required this.category,
    required this.exercisesInUse,
  });

  Future<List<String>> getAllNotSelected() async {
    List<String> exercises =
        await ExerciseSelectionRepository().getAllFromCategory(category);

    List<String> exercisesNotSelected = exercises
        .where((exercise) => !exercisesInUse.contains(exercise))
        .toList();

    return exercisesNotSelected;
  }
  // Future<List<String>> getAllNotSelected() async {
  //   var futures = await Future.wait([
  //     ExerciseSelectionRepository().getAllFromCategory(category),
  //     ExerciseRepository().getAllFromCategory(category)
  //   ]);

  //   List<String> exercises = futures[0];
  //   List<String> selectedExercises = futures[1];

  //   List<String> exercisesNotSelected = [];

  //   for (var exercise in exercises) {
  //     if (!selectedExercises.contains(exercise)) {
  //       exercisesNotSelected.add(exercise);
  //     }
  //   }

  //   return exercisesNotSelected;
  // }
}
