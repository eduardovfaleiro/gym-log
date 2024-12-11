import 'dart:io';

import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:gym_log/repositories/log_repository.dart';
import 'package:path_provider/path_provider.dart';

import '../log.dart';
import 'log_service.dart';

class SpreadsheetService {
  static Future<void> export(String exercise) async {
    List<Log> logs = await LogRepository.getAll(exercise);

    Excel excel = Excel.createExcel();
    Sheet sheet = excel[exercise];

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

  static Future<List<Log>> import() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(allowedExtensions: ['xlsx'], type: FileType.custom);

    if (result != null) {
      File file = File(result.files.single.path!);

      var bytes = await file.readAsBytes();
      var excel = Excel.decodeBytes(bytes);

      for (var row in excel.tables[excel.tables.keys.first]!.rows.skip(1)) {}
    } else {
      // User canceled the picker
    }
    return [];
  }
}
