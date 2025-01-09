import 'package:gym_log/entities/log.dart';
import 'package:gym_log/repositories/config.dart';
import 'package:gym_log/repositories/log_repository.dart';

import '../entities/exercise.dart';

class LogService {
  double getRepMax(double weight, {required int currentReps, required int targetReps}) {
    double oneRepMax;

    if (currentReps < 11) {
      oneRepMax = weight * (1 + currentReps / 30);
    } else {
      oneRepMax = weight * 36 / (37 - currentReps);
    }

    if (targetReps == 1) return oneRepMax;
    if (targetReps == 2) return oneRepMax * .95;
    if (targetReps == 3) return oneRepMax * .93;
    if (targetReps == 4) return oneRepMax * .9;
    if (targetReps == 5) return oneRepMax * .87;
    if (targetReps == 6) return oneRepMax * .85;
    if (targetReps == 7) return oneRepMax * .83;
    if (targetReps == 8) return oneRepMax * .8;
    if (targetReps == 9) return oneRepMax * .77;
    if (targetReps == 10) return oneRepMax * .75;
    if (targetReps == 11) return oneRepMax * .73;
    if (targetReps == 12) return oneRepMax * .7;

    throw UnimplementedError();
  }

  List<Log> convertLogsToRepMax(List<Log> logs) {
    int reps = Config.getInt('repMax', defaultValue: 1);

    return logs
        .map(
          (e) => Log(
            date: e.date,
            weight: getRepMax(e.weight, currentReps: e.reps, targetReps: reps),
            reps: reps,
            notes: e.notes,
          ),
        )
        .toList();
  }

  // Future<List<Log>> getRepMaxLogs(Exercise exercise) async {
  //   var logs = await LogRepository(exercise).getAll();
  //   int reps = Config.getInt('repMax', defaultValue: 1);

  //   return logs
  //       .map(
  //         (e) => Log(
  //           date: e.date,
  //           weight: getRepMax(e.weight, currentReps: e.reps, targetReps: reps),
  //           reps: reps,
  //           notes: e.notes,
  //         ),
  //       )
  //       .toList();
  // }
}
