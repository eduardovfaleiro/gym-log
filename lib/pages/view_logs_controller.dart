import '../entities/exercise.dart';
import '../entities/log.dart';
import '../repositories/log_repository.dart';

class ViewLogsController {
  // TODO(tá criando LogRepository toda hora)
  Future<List<Log>> getSortedLogsByDate(Exercise exercise) async {
    var logs = await LogRepository(exercise).getAll();
    logs.sort((a, b) => a.date.compareTo(b.date));

    return logs;
  }
}
