import 'package:gym_log/log.dart';
import 'package:gym_log/repositories/config.dart';
import 'package:gym_log/repositories/log_repository.dart';

class LogService {
  static double getRepMax(double weight, {required int currentReps, required int futureReps}) {
    double oneRepMax;

    if (currentReps < 11) {
      oneRepMax = weight * (1 + currentReps / 30);
    } else {
      oneRepMax = weight * 36 / (37 - currentReps);
    }

    if (futureReps == 1) return oneRepMax;
    if (futureReps == 2) return oneRepMax * .95;
    if (futureReps == 3) return oneRepMax * .93;
    if (futureReps == 4) return oneRepMax * .9;
    if (futureReps == 5) return oneRepMax * .87;
    if (futureReps == 6) return oneRepMax * .85;
    if (futureReps == 7) return oneRepMax * .83;
    if (futureReps == 8) return oneRepMax * .8;
    if (futureReps == 9) return oneRepMax * .77;
    if (futureReps == 10) return oneRepMax * .75;
    if (futureReps == 11) return oneRepMax * .73;
    if (futureReps == 12) return oneRepMax * .7;

    throw UnimplementedError();
  }

  static Future<List<Log>> getRepMaxLogs(String exercise) async {
    var logs = await LogRepository.getAll(exercise);
    int reps = Config.getInt('repMax');

    return logs
        .map((e) => Log(date: e.date, weight: getRepMax(e.weight, currentReps: e.reps, futureReps: reps), reps: reps))
        .toList();
  }

  static Future<List<Log>> getSortedRepMaxLogs(String exercise) async {
    var logs = await getRepMaxLogs(exercise);
    logs.sort((a, b) => a.date.compareTo(b.date));

    return logs;
  }

  static Future<List<Log>> getSortedLogs(String exercise) async {
    var logs = await LogRepository.getAll(exercise);
    logs.sort((a, b) => a.date.compareTo(b.date));

    return logs;
  }
}
