import 'dart:io';

import 'package:gym_log/entities/log.dart';
import 'package:intl/intl.dart';
import 'package:csv/csv.dart';

class CsvService {
  List<Log> convertCsvToLogs(String path) {
    File file = File(path);
    String csvData = file.readAsStringSync();

    List<List> logs = const CsvToListConverter().convert(csvData);
    List<Log> logsObj = [];

    for (var logList in logs.skip(1)) {
      var log = Log(
        weight: logList[0],
        reps: logList[1],
        date: DateFormat('dd-MM-yyyy').parse(logList[2]),
      );

      logsObj.add(log);
    }

    return logsObj;
  }

  Future<String> convertLogsToCsv(String exercise, List<Log> logs) async {
    List<String> headers = ['Peso', 'Repetições', 'Data'];
    List<List<dynamic>> rows = [headers];
    rows.addAll(logs.map((log) {
      return [
        log.weight.toString(),
        log.reps.toString(),
        DateFormat('dd-MM-yyyy').format(log.date),
      ];
    }));

    String csvData = const ListToCsvConverter().convert(rows);
    return csvData;
  }
}
