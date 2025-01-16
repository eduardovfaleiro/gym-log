import 'dart:io';

import 'package:gym_log/entities/log.dart';
import 'package:intl/intl.dart';
import 'package:csv/csv.dart';

import 'sheet_service.dart';

class CsvService {
  List<Log> convertCsvToLogs(String path) {
    File file = File(path);
    String csvData = file.readAsStringSync();

    List<List> logs = const CsvToListConverter().convert(csvData);
    List<Log> logsObj = [];

    for (int i = 1; i < logs.length; i++) {
      // for (var logList in logs.skip(1)) {
      var logList = logs[i];
      var log = Log(
        weight: logList[0],
        reps: logList[1],
        date: DateFormat('dd-MM-yyyy').parse(logList[2]),
        notes: logList[3],
      );

      SheetService().validateLogFromCell(log: log, row: i);
      logsObj.add(log);
    }

    return logsObj;
  }

  Future<String> convertLogsToCsv(String exercise, List<Log> logs) async {
    List<String> headers = ['Peso', 'Repetições', 'Data', 'Notas'];
    List<List<dynamic>> rows = [headers];
    rows.addAll(logs.map((log) {
      return [
        log.weight.toString(),
        log.reps.toString(),
        DateFormat('dd-MM-yyyy').format(log.date),
        log.notes,
      ];
    }));

    String csvData = const ListToCsvConverter().convert(rows);
    return csvData;
  }
}
