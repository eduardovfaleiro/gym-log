import 'dart:io';

import 'package:csv/csv.dart';
import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:gym_log/entities/log.dart';
import 'package:gym_log/repositories/log_repository.dart';
import 'package:gym_log/services/log_service.dart';
import 'package:gym_log/services/excel_service.dart';
import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';

import '../services/csv_service.dart';

class ExerciseChartController {
  final String exercise;

  ExerciseChartController(this.exercise);

  Future<List<Log>> getSortedRepMaxLogs() async {
    var logs = await LogService().getRepMaxLogs(exercise);
    logs.sort((a, b) => a.date.compareTo(b.date));

    return logs;
  }

  Future<void> importCsv(String path) async {
    List<Log> logs = CsvService().convertCsvToLogs(path);
    await LogRepository(exercise).replaceAll(logs);
  }

  Future<void> exportAndOpenAsCsv() async {
    String csvData = await CsvService().convertLogsToCsv(
      exercise,
      await LogRepository(exercise).getAll(),
    );

    String outputPath = '/storage/emulated/0/Download/$exercise.csv';
    File file = File(outputPath);
    await file.writeAsString(csvData);

    await OpenFile.open(outputPath);
  }

  // Future<void> importExcel(String path) async {
  //   List<Log> logs = ExcelService().convertExcelToLogs(path);
  //   await LogRepository(exercise).replaceAll(logs);
  // }

  Future<void> exportAndOpenAsExcel() async {
    List<int> excelFile = (await ExcelService().convertLogsToExcel(exercise))!;
    String outputPath = '/storage/emulated/0/Download/$exercise.xlsx';

    // if (excelFile != null) {
    File(outputPath)
      ..createSync(recursive: true)
      ..writeAsBytesSync(excelFile);
    // }

    await OpenFile.open(outputPath);
  }
}
