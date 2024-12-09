import 'package:gym_log/log.dart';
import 'package:gym_log/services/log_service.dart';

class ExerciseChartController {
  static Future<List<Log>> getSortedRepMaxLogs(String exercise) async {
    var logs = await LogService.getRepMaxLogs(exercise);
    logs.sort((a, b) => a.date.compareTo(b.date));

    return logs;
  }
}
