import '../entities/exercise.dart';
import '../entities/log.dart';
import '../repositories/log_repository.dart';

class ViewLogsController {
  Future<List<Log>> getSortedLogs(Exercise exercise) async {
    var logs = await LogRepository(exercise).getAll();
    logs.sort((a, b) => a.date.compareTo(b.date));

    return logs;
  }
}
