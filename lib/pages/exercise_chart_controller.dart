import 'dart:io';

import 'package:gym_log/entities/log.dart';
import 'package:gym_log/repositories/log_repository.dart';
import 'package:gym_log/services/excel_service.dart';
import 'package:gym_log/services/log_service.dart';
import 'package:gym_log/utils/get_unique_file_path.dart';
import 'package:open_file/open_file.dart';

import '../entities/exercise.dart';
import '../services/csv_service.dart';

class ExerciseChartController {
  final Exercise exercise;
  late final LogRepository logRepository;

  List<Log> logs = [];

  ExerciseChartController(this.exercise) : logRepository = LogRepository(exercise);

  Future<void> loadLogs() async {
    logs = await logRepository.getAll();
  }

  List<Log> getChartLogs() {
    if (logs.isEmpty) return [];

    var logsRepMax = LogService().convertLogsToRepMax(logs);
    logsRepMax.sort((a, b) => a.date.compareTo(b.date));

    return logsRepMax;
  }

  Future<void> updateLog(Log log) async {
    await logRepository.update(newLog: log, currentLogList: logs);
  }

  Future<({ResultType resultType, String fileName})> exportAndOpenAsCsv() async {
    String csvData = await CsvService().convertLogsToCsv(
      exercise.name,
      await logRepository.getAll(),
    );

    String outputPath = await getUniqueFilePath(
      directory: '/storage/emulated/0/Download/',
      baseName: exercise.name,
      extension: 'csv',
    );

    String fileName = outputPath.split('/').last;

    File file = File(outputPath);
    await file.writeAsString(csvData);

    var openResult = await OpenFile.open(outputPath);
    return (resultType: openResult.type, fileName: fileName);
  }

  Future<({ResultType resultType, String fileName})> exportAndOpenAsExcel() async {
    List<int> excelFile = (await ExcelService().convertLogsToExcel(exercise, logs))!;

    String outputPath = await getUniqueFilePath(
      directory: '/storage/emulated/0/Download/',
      baseName: exercise.name,
      extension: 'xlsx',
    );

    String fileName = outputPath.split('/').last;

    File(outputPath)
      ..createSync(recursive: true)
      ..writeAsBytesSync(excelFile);

    var openResult = await OpenFile.open(outputPath);
    return (resultType: openResult.type, fileName: fileName);
  }
}
