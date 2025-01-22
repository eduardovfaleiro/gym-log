import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:gym_log/utils/exceptions.dart';
import 'package:gym_log/utils/extensions.dart';
import 'package:gym_log/utils/routers.dart';
import 'package:gym_log/utils/log_dialogs.dart';
import 'package:gym_log/utils/show_error.dart';
import 'package:gym_log/widgets/loading_manager.dart';
import 'package:gym_log/entities/log.dart';
import 'package:gym_log/repositories/config.dart';
import 'package:gym_log/services/csv_service.dart';
import 'package:gym_log/services/excel_service.dart';
import 'package:gym_log/pages/view_logs_page.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../entities/exercise.dart';
import 'exercise_chart_controller.dart';
import '../repositories/log_repository.dart';
import '../utils/show_confirm_dialog.dart';
import 'view_imported_logs_page.dart';

class ExerciseChartPage extends StatefulWidget {
  final Exercise exercise;

  const ExerciseChartPage({super.key, required this.exercise});

  @override
  State<ExerciseChartPage> createState() => _ExerciseChartPageState();
}

class _ExerciseChartPageState extends State<ExerciseChartPage> with LoadingManager {
  late final ExerciseChartController _controller;
  List<Log> _logs = [];

  @override
  void initState() {
    super.initState();

    _controller = ExerciseChartController(widget.exercise);
  }

  Future<bool> _showConfirmExport(BuildContext context) {
    return showConfirmDialog(
      context,
      'Tem certeza que deseja exportar os registros para planilha?',
      content: 'O arquivo será salvo na pasta de Downloads do dispositivo.',
      confirm: 'Sim, exportar',
    );
  }

  Future<void> _pushViewImportedLogs({
    required BuildContext context,
    required String sheetName,
    required List<Log> logs,
  }) async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return ViewImportedLogsPage(
              title: sheetName,
              logs: logs,
              onConfirm: () async {
                bool isSure = await showConfirmDialog(
                  context,
                  'Tem certeza que deseja importar os dados da planilha "$sheetName"?',
                  content:
                      'Todos os logs já existentes deste exercício serão REMOVIDOS e SUBSTITUÍDOS pelos logs desta planilha.',
                  confirm: 'Sim, importar e substituir dados',
                  cancel: 'Não, cancelar',
                );

                if (!isSure) return;

                runLoading(() async {
                  await LogRepository(widget.exercise).replaceAll(logs);
                  setState(() {});
                  Navigator.pop(context);
                });
              });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LoadingPresenter(
      isLoadingNotifier: isLoadingNotifier,
      child: Scaffold(
        appBar: AppBar(title: Text(widget.exercise.name)),
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
              future: LogRepository(widget.exercise).getAll(),
              builder: (context, snapshot) {
                _logs = snapshot.data ?? [];

                return SfCartesianChart(
                  zoomPanBehavior: ZoomPanBehavior(
                    enablePanning: true,
                  ),
                  primaryXAxis: CategoryAxis(
                    autoScrollingDelta: 4,
                  ),
                  series: <CartesianSeries<Log, String>>[
                    LineSeries<Log, String>(
                        dataSource: _controller.getSortedLogsByDate(_logs),
                        xValueMapper: (Log sales, _) => sales.date.formatReadableShort(),
                        yValueMapper: (Log sales, _) => double.parse(sales.weight.toStringAsFixed(1)),
                        name: 'Sales',
                        dataLabelSettings: const DataLabelSettings(isVisible: true))
                  ],
                );
              },
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Exportar para'),
                        Row(
                          children: [
                            Expanded(
                              child: _OutlinedButton(
                                onPressed: () async {
                                  bool isSure = await _showConfirmExport(context);

                                  if (isSure) {
                                    _controller.exportAndOpenAsExcel();
                                  }
                                },
                                child: const Text(
                                  'xlsx',
                                  style: TextStyle(
                                    color: Color(0xff217346),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 4),
                            Expanded(
                              child: _OutlinedButton(
                                onPressed: () async {
                                  bool isSure = await _showConfirmExport(context);

                                  if (isSure) {
                                    _controller.exportAndOpenAsCsv();
                                  }
                                },
                                child: const Text('csv'),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Importar de'),
                        Row(
                          children: [
                            Expanded(
                              child: _OutlinedButton(
                                onPressed: () async {
                                  FilePickerResult? result = await FilePicker.platform.pickFiles(
                                    allowedExtensions: ['xlsx'],
                                    type: FileType.custom,
                                  );
                                  if (result == null) return;

                                  runLoading(() async {
                                    String excelPath = result.files.single.path!;
                                    List<Log> logs = [];

                                    try {
                                      logs = ExcelService().convertExcelToLogs(excelPath);
                                    } on SheetValueException catch (error) {
                                      showError(
                                        context,
                                        title: 'Ocorreu um erro na célula ${error.column}${error.row}',
                                        content:
                                            '${error.message}\n\nPor favor, exclua ou altere o valor para que seja possível importar o arquivo.',
                                      );
                                      return;
                                    } catch (error) {
                                      showError(
                                        context,
                                        content:
                                            'Não foi possível importar o arquivo .xlsx. Por favor, tente novamente.',
                                      );
                                      return;
                                    }

                                    _pushViewImportedLogs(context: context, sheetName: result.names.first!, logs: logs);
                                  });

                                  // Navigator.push(
                                  //   context,
                                  //   MaterialPageRoute(
                                  //     builder: (context) {
                                  //       return ViewImportedLogsPage(
                                  //           title: result.files.single.name,
                                  //           logs: logs,
                                  //           onConfirm: () async {
                                  //             await _onConfirmImport(
                                  //                 context: context, logs: logs, sheetName: result.names.first!);
                                  //           });
                                  //     },
                                  //   ),
                                  // );
                                },
                                child: const Text(
                                  'xlsx',
                                  style: TextStyle(
                                    color: Color(0xff217346),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 4),
                            Expanded(
                              child: _OutlinedButton(
                                onPressed: () async {
                                  FilePickerResult? result = await FilePicker.platform.pickFiles(
                                    allowedExtensions: ['csv'],
                                    type: FileType.custom,
                                  );
                                  if (result == null) return;

                                  runLoading(() async {
                                    String csvPath = result.files.single.path!;
                                    List<Log> logs = [];

                                    try {
                                      logs = CsvService().convertCsvToLogs(csvPath);
                                    } on SheetValueException catch (error) {
                                      showError(
                                        context,
                                        title: 'Ocorreu um erro na célula ${error.column}${error.row}',
                                        content:
                                            '${error.message}\n\nPor favor, exclua ou altere o valor para que seja possível importar o arquivo.',
                                      );
                                      return;
                                    } catch (error) {
                                      showError(
                                        context,
                                        content:
                                            'Não foi possível importar o arquivo .csv. Por favor, tente novamente.',
                                      );
                                      return;
                                    }

                                    _pushViewImportedLogs(context: context, sheetName: result.names.first!, logs: logs);
                                  });
                                },
                                child: const Text('csv'),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                HorizontalRouter(
                                  child: ViewLogsPage(
                                    exercise: widget.exercise,
                                    logs: _logs,
                                    onUpdate: () {
                                      setState(() {});
                                    },
                                  ),
                                ),
                              );
                            },
                            child: const Text('Visualizar logs')),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            showAddLog(context, exercise: widget.exercise, onConfirm: (weight, reps, date, notes) {
              LogRepository(widget.exercise)
                  .add(Log(date: date, reps: reps, weight: weight, notes: notes))
                  .then((_) => setState(() {}));
            });
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}

class _OutlinedButton extends OutlinedButton {
  _OutlinedButton({required super.onPressed, required super.child})
      : super(
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 20),
            minimumSize: const Size(0, 0),
          ),
        );
}
