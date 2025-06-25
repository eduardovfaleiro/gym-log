import 'package:gym_log/entities/exercise.dart';
import 'package:gym_log/repositories/exercise_selection_repository.dart';

class AddExerciseControllerX {
  final String categoryId;
  final Set<String> exercisesInUse;

  const AddExerciseControllerX({
    required this.categoryId,
    required this.exercisesInUse,
  });

  Future<List<ExerciseX>> getAllNotSelected() async {
    List<ExerciseX> exercises =
        await ExerciseSelectionRepositoryX(categoryId).getAll();

    List<ExerciseX> exercisesNotSelected = exercises
        .where((exercise) => !exercisesInUse.contains(exercise.name))
        .toList();

    return exercisesNotSelected;
  }
}

// class AddExerciseController {
//   final String category;
//   final Set<String> exercisesInUse;

//   const AddExerciseController({
//     required this.category,
//     required this.exercisesInUse,
//   });

//   Future<List<ExerciseX>> getAllNotSelectedX() async {
//     List<ExerciseX> exercises =
//         await ExerciseSelectionRepositoryX().getAllFromCategory(category);

//     List<String> exercisesNotSelected = exercises
//         .where((exercise) => !exercisesInUse.contains(exercise))
//         .toList();

//     return exercisesNotSelected;
//   }
//   Future<List<ExerciseX>> getAllNotSelected() async {
//     List<String> exercises =
//         await ExerciseSelectionRepository().getAllFromCategory(category);

//     List<String> exercisesNotSelected = exercises
//         .where((exercise) => !exercisesInUse.contains(exercise))
//         .toList();

//     return exercisesNotSelected;
//   }
//   // Future<List<String>> getAllNotSelected() async {
//   //   var futures = await Future.wait([
//   //     ExerciseSelectionRepository().getAllFromCategory(category),
//   //     ExerciseRepository().getAllFromCategory(category)
//   //   ]);

//   //   List<String> exercises = futures[0];
//   //   List<String> selectedExercises = futures[1];

//   //   List<String> exercisesNotSelected = [];

//   //   for (var exercise in exercises) {
//   //     if (!selectedExercises.contains(exercise)) {
//   //       exercisesNotSelected.add(exercise);
//   //     }
//   //   }

//   //   return exercisesNotSelected;
//   // }
// }
