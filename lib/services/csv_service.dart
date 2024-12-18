import 'dart:io';

import 'package:gym_log/entities/log.dart';
import 'package:intl/intl.dart';
import 'package:csv/csv.dart';

class CsvService {
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
