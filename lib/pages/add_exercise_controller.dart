import 'package:gym_log/repositories/exercise_repository.dart';
import 'package:gym_log/repositories/exercise_selection_repository.dart';

import '../entities/exercise.dart';

class AddExerciseController {
  final String category;

  AddExerciseController({required this.category});

  Future<List<String>> getAllNotSelected() async {
    List<String> exercises = await ExerciseSelectionRepository().getAllFromCategory(category);
    List<String> selectedExercises = await ExerciseRepository().getAllFromCategory(category);

    List<String> exercisesNotSelected = [];

    for (var exercise in exercises) {
      if (!selectedExercises.contains(exercise)) {
        exercisesNotSelected.add(exercise);
      }
    }

    return exercisesNotSelected;
  }
}
