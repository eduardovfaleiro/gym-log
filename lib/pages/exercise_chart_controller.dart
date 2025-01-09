import 'dart:io';

import 'package:gym_log/entities/log.dart';
import 'package:gym_log/repositories/log_repository.dart';
import 'package:gym_log/services/log_service.dart';
import 'package:gym_log/services/excel_service.dart';
import 'package:open_file/open_file.dart';

import '../entities/exercise.dart';
import '../services/csv_service.dart';

class ExerciseChartController {
  final Exercise exercise;

  ExerciseChartController(this.exercise);

  // TODO(estava trocando isso aqui)
  List<Log> getSortedLogsByDate(List<Log> logs) {
    var logsRepMax = LogService().convertLogsToRepMax(logs);
    logsRepMax.sort((a, b) => a.date.compareTo(b.date));

    return logsRepMax;
  }

  Future<void> importCsv(String path) async {
    List<Log> logs = CsvService().convertCsvToLogs(path);
    await LogRepository(exercise).replaceAll(logs);
  }

  Future<void> exportAndOpenAsCsv() async {
    String csvData = await CsvService().convertLogsToCsv(
      exercise.name,
      await LogRepository(exercise).getAll(),
    );

    String outputPath = '/storage/emulated/0/Download/${exercise.name}.csv';
    File file = File(outputPath);
    await file.writeAsString(csvData);

    await OpenFile.open(outputPath);
  }

  Future<void> exportAndOpenAsExcel() async {
    List<int> excelFile = (await ExcelService().convertLogsToExcel(exercise))!;
    String outputPath = '/storage/emulated/0/Download/${exercise.name}.xlsx';

    // if (excelFile != null) {
    File(outputPath)
      ..createSync(recursive: true)
      ..writeAsBytesSync(excelFile);
    // }

    await OpenFile.open(outputPath);
  }
}
