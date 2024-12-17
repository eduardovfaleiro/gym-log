import 'dart:io';

import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:gym_log/log.dart';
import 'package:gym_log/repositories/log_repository.dart';
import 'package:gym_log/services/log_service.dart';
import 'package:gym_log/services/spreadsheet_service.dart';

class ExerciseChartController {
  final String exercise;

  ExerciseChartController(this.exercise);

  Future<List<Log>> getSortedRepMaxLogs() async {
    var logs = await LogService.getRepMaxLogs(exercise);
    logs.sort((a, b) => a.date.compareTo(b.date));

    return logs;
  }

  Future<void> import(File file) async {
    var bytes = await file.readAsBytes();
    var excel = Excel.decodeBytes(bytes);

    List<Log> logs = SpreadsheetService.convertExcelToLogs(excel);
    await LogRepository(exercise).replaceAll(logs);
  }
}
