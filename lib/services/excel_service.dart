import 'dart:io';

import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:gym_log/repositories/log_repository.dart';
import 'package:path_provider/path_provider.dart';

import '../entities/log.dart';
import 'log_service.dart';

class ExcelService {
  Future<List<int>?> convertLogsToExcel(String exercise) async {
    List<Log> logs = await LogRepository(exercise).getAll();

    var excel = Excel.createExcel();
    excel.rename(excel.getDefaultSheet()!, exercise);

    Sheet sheet = excel.sheets[exercise]!;

    sheet.appendRow([
      TextCellValue('Peso (kg)'),
      TextCellValue('Repetições'),
      TextCellValue('Data'),
      TextCellValue('Observações'),
    ]);

    for (Log log in logs) {
      sheet.appendRow([
        DoubleCellValue(log.weight),
        IntCellValue(log.reps),
        DateCellValue.fromDateTime(log.date),
        TextCellValue(''),
      ]);
    }

    return excel.save();
  }

  List<Log> convertExcelToLogs(String path) {
    File file = File(path);

    var bytes = file.readAsBytesSync();
    var excel = Excel.decodeBytes(bytes);

    List<Log> logs = [];

    Log log;
    DateTime date;
    double weight;
    int reps;
    String notes;

    for (var row in excel.tables[excel.tables.keys.first]!.rows.skip(1)) {
      weight = double.parse(row[0]!.value.toString());
      reps = (row[1]!.value as IntCellValue).value;
      date = (row[2]!.value as DateCellValue).asDateTimeLocal();
      notes = (row[3]!.value as TextCellValue).value.text!;

      log = Log(date: date, weight: weight, reps: reps);
      logs.add(log);
    }

    return logs;
  }
}
