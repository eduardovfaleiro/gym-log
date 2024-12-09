import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gym_log/extensions.dart';
import 'package:gym_log/log.dart';
import 'package:gym_log/repositories/config.dart';
import 'package:gym_log/view_logs_page.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import 'exercise_chart_controller.dart';
import 'repositories/log_repository.dart';
import 'services/log_service.dart';

class ExerciseChart extends StatefulWidget {
  final String title;

  const ExerciseChart({super.key, required this.title});

  @override
  State<ExerciseChart> createState() => _ExerciseChartState();
}

class _ExerciseChartState extends State<ExerciseChart> {
  Future<void> _showAddLog() async {
    var weightController = TextEditingController(text: '90');
    var repsController = TextEditingController(text: '10');
    var date = DateTime.now();

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Adicionar log'),
          insetPadding: EdgeInsets.zero,
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: 100,
                width: 300,
                child: CupertinoDatePicker(
                  onDateTimeChanged: (time) {
                    date = time;
                  },
                  mode: CupertinoDatePickerMode.date,
                  minimumDate: DateTime(2000, 1, 1),
                  maximumDate: DateTime(date.year, date.month, date.day + 1),
                  itemExtent: 30,
                ),
              ),
              TextField(
                  controller: weightController,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true, signed: false),
                  inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^[0-9]+.?[0-9]*'))],
                  decoration: const InputDecoration(labelText: 'Peso (kg)')),
              TextField(
                controller: repsController,
                decoration: const InputDecoration(labelText: 'Repetições'),
                keyboardType: const TextInputType.numberWithOptions(),
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () async {
                double weight = double.parse(weightController.text);
                int reps = int.parse(repsController.text);

                LogRepository.add(widget.title, Log(date: date, reps: reps, weight: weight))
                    .then((_) => setState(() {}));

                Navigator.pop(context);
              },
              child: const Text('Ok'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Column(
              children: [
                const Text(
                  'Somente insira a melhor série (geralmente a primeira) do dia que deseja deste exercício em específico.',
                ),
                const SizedBox(height: 8),
                DropdownButton(
                  value: Config.getInt('repMax', defaultValue: 1),
                  isExpanded: true,
                  items: List.generate(
                    13,
                    (rpm) => DropdownMenuItem(value: rpm, child: Text('Normalizar para $rpm RPM')),
                  ).sublist(1, 13),
                  onChanged: (rpm) async {
                    setState(() {
                      Config.setInt('repMax', rpm!);
                    });
                  },
                ),
              ],
            ),
          ),
          FutureBuilder(
            future: LogService.getSortedRepMaxLogs(widget.title),
            builder: (context, snapshot) {
              List<Log> logs = snapshot.data ?? [];

              return SfCartesianChart(
                zoomPanBehavior: ZoomPanBehavior(
                  enablePanning: true,
                ),
                primaryXAxis: CategoryAxis(
                  autoScrollingDelta: 4,
                ),
                series: <CartesianSeries<Log, String>>[
                  LineSeries<Log, String>(
                      dataSource: logs,
                      xValueMapper: (Log sales, _) => sales.date.formatReadable(),
                      yValueMapper: (Log sales, _) => double.parse(sales.weight.toStringAsFixed(1)),
                      name: 'Sales',
                      dataLabelSettings: const DataLabelSettings(isVisible: true))
                ],
              );
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              children: [
                Expanded(
                    child: OutlinedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return ViewLogsPage(exercise: widget.title);
                              },
                            ),
                          );
                        },
                        child: const Text('Visualizar logs'))),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddLog();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
