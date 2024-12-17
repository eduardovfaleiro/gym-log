import 'dart:io';

import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:gym_log/repositories/log_repository.dart';
import 'package:path_provider/path_provider.dart';

import '../log.dart';
import 'log_service.dart';

class SpreadsheetService {
  static Future<void> export(String exercise) async {
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

    List<int>? fileBytes = excel.save();
    String outputPath = '/storage/emulated/0/Download/$exercise.xlsx';

    if (fileBytes != null) {
      File(outputPath)
        ..createSync(recursive: true)
        ..writeAsBytesSync(fileBytes);
    }
  }

  // static Future<({logs = List, otherInfo = String})> import(File file) async {
  //   FilePickerResult? result = await FilePicker.platform.pickFiles(allowedExtensions: ['xlsx'], type: FileType.custom);

  //   if (result != null) {
  //     File file = File(result.files.single.path!);

  //     var bytes = await file.readAsBytes();
  //     var excel = Excel.decodeBytes(bytes);

  //     var logs = _convertExcelToLogs(excel);
  //     return logs;
  //   }

  //   return [];
  // }

  static List<Log> convertExcelToLogs(Excel excel) {
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
