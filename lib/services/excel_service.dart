import 'dart:io';

import 'package:excel/excel.dart';
import 'package:gym_log/repositories/log_repository.dart';
import 'package:gym_log/services/sheet_service.dart';

import '../entities/exercise.dart';
import '../entities/log.dart';

class ExcelService {
  // TODO(tá criando LogRepository toda hora)
  Future<List<int>?> convertLogsToExcel(Exercise exercise) async {
    List<Log> logs = await LogRepository(exercise).getAll();

    var excel = Excel.createExcel();
    excel.rename(excel.getDefaultSheet()!, exercise.name);

    Sheet sheet = excel.sheets[exercise.name]!;

    sheet.appendRow([
      TextCellValue('Peso (kg)'),
      TextCellValue('Repetições'),
      TextCellValue('Data'),
      TextCellValue('Notas'),
    ]);

    for (Log log in logs) {
      sheet.appendRow([
        DoubleCellValue(log.weight),
        IntCellValue(log.reps),
        DateCellValue.fromDateTime(log.date),
        TextCellValue(log.notes),
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

    var rows = excel.tables[excel.tables.keys.first]!.rows;

    for (int i = 1; i < rows.length; i++) {
      var row = rows[i];

      weight = double.parse(row[0]!.value.toString());
      reps = (row[1]!.value as IntCellValue).value;
      date = (row[2]!.value as DateCellValue).asDateTimeLocal();
      notes = (row[3]!.value as TextCellValue).value.text!;

      SheetService().validateLogFromCell(log: Log(date: date, weight: weight, reps: reps, notes: notes), row: i);

      log = Log(date: date, weight: weight, reps: reps, notes: notes);
      logs.add(log);
    }

    return logs;
  }
}
