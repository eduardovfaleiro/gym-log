// ignore_for_file: use_build_context_synchronously

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gym_log/utils/extensions.dart';
import 'package:gym_log/utils/horizontal_router.dart';
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

  static Future<void> showAddLog(
    BuildContext context, {
    required void Function(double weight, int reps, DateTime date, String notes) onConfirm,
    required Exercise exercise,
  }) async {
    var notesController = TextEditingController();

    Log? lastLogFromExercise = await LogRepository(exercise).getLast();

    var date = DateTime.now();
    var dateController = TextEditingController(text: date.formatReadable());
    DateTime selectedDate = date;

    var weightController = TextEditingController(text: lastLogFromExercise?.weight.toString());
    var repsController = TextEditingController(text: lastLogFromExercise?.reps.toString());

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Adicionar log'),
          insetPadding: const EdgeInsets.symmetric(horizontal: 16),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: dateController,
                decoration: const InputDecoration(labelText: 'Data'),
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                    initialDate: selectedDate,
                    context: context,
                    firstDate: DateTime(2000),
                    lastDate: date,
                  );

                  if (pickedDate == null) return;
                  selectedDate = pickedDate;
                  dateController.text = selectedDate.formatReadable();
                },
                readOnly: true,
                inputFormatters: const [],
              ),
              TextField(
                controller: weightController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true, signed: false),
                inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^[0-9]+.?[0-9]*'))],
                decoration: InputDecoration(
                  labelText: 'Peso (kg)',
                  suffix: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        onPressed: () {
                          double weight = double.tryParse(weightController.text) ?? 0;
                          weight++;
                          weightController.text = weight.toString();
                        },
                        icon: const Icon(Icons.add),
                        padding: EdgeInsets.zero,
                      ),
                      IconButton(
                        onPressed: () {
                          double weight = double.tryParse(weightController.text) ?? 0;
                          if (weight < 1) return;

                          weight--;
                          weightController.text = weight.toString();
                        },
                        icon: const Icon(Icons.remove),
                        padding: EdgeInsets.zero,
                      ),
                    ],
                  ),
                ),
              ),
              TextField(
                controller: repsController,
                decoration: InputDecoration(
                  labelText: 'Repetições',
                  suffix: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        onPressed: () {
                          int reps = int.tryParse(repsController.text) ?? 0;
                          reps++;
                          repsController.text = reps.toString();
                        },
                        icon: const Icon(Icons.add),
                        padding: EdgeInsets.zero,
                      ),
                      IconButton(
                        onPressed: () {
                          int reps = int.tryParse(repsController.text) ?? 0;
                          if (reps < 1) return;
                          reps--;

                          repsController.text = reps.toString();
                        },
                        icon: const Icon(Icons.remove),
                        padding: EdgeInsets.zero,
                      ),
                    ],
                  ),
                ),
                keyboardType: const TextInputType.numberWithOptions(),
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              ),
              TextField(
                keyboardType: TextInputType.multiline,
                maxLines: null,
                controller: notesController,
                decoration: const InputDecoration(labelText: 'Notas'),
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () async {
                if (weightController.text.isEmpty || repsController.text.isEmpty) {
                  showError(context, content: 'Os campos "Peso (kg)" e "Repetições" devem estar preenchidos.');
                  return;
                }

                double weight = double.parse(weightController.text);
                int reps = int.parse(repsController.text);

                onConfirm(weight, reps, selectedDate, notesController.text);

                Navigator.pop(context);
              },
              child: const Text('Ok'),
            ),
          ],
        );
      },
    );
  }
}

class _ExerciseChartPageState extends State<ExerciseChartPage> with LoadingManager {
  late final ExerciseChartController _controller;

  @override
  void initState() {
    super.initState();

    _controller = ExerciseChartController(widget.exercise);
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
              future: _controller.getSortedRepMaxLogs(),
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
                              child: OutlinedButton(
                                onPressed: () async {
                                  bool isSure = await showConfirmDialog(
                                    context,
                                    'Tem certeza que deseja exportar os registros para planilha?',
                                    content: 'O arquivo será salvo na pasta de Downloads do dispositivo.',
                                    confirm: 'Sim, exportar',
                                  );

                                  if (isSure) {
                                    _controller.exportAndOpenAsExcel();
                                  }
                                },
                                style: OutlinedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 20),
                                  minimumSize: const Size(0, 0),
                                ),
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
                              child: OutlinedButton(
                                onPressed: () async {
                                  bool isSure = await showConfirmDialog(
                                    context,
                                    'Tem certeza que deseja exportar os registros para planilha?',
                                    content: 'O arquivo será salvo na pasta de Downloads do dispositivo.',
                                    confirm: 'Sim, exportar',
                                  );

                                  if (isSure) {
                                    _controller.exportAndOpenAsCsv();
                                  }
                                },
                                style: OutlinedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 20),
                                  minimumSize: const Size(0, 0),
                                ),
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
                              child: OutlinedButton(
                                onPressed: () async {
                                  FilePickerResult? result = await FilePicker.platform.pickFiles(
                                    allowedExtensions: ['xlsx'],
                                    type: FileType.custom,
                                  );

                                  if (result != null) {
                                    String excelPath = result.files.single.path!;
                                    List<Log> logs = [];

                                    try {
                                      logs = ExcelService().convertExcelToLogs(excelPath);
                                    } catch (error) {
                                      showError(
                                        context,
                                        content:
                                            'Não foi possível importar o arquivo .xlsx. Por favor, tente novamente.',
                                      );
                                      return;
                                    }

                                    Navigator.push(
                                      context,
                                      HorizontalRouter(
                                        child: ViewImportedLogsPage(
                                          title: result.files.single.name,
                                          logs: logs,
                                          onConfirm: () async {
                                            bool isSure = await showConfirmDialog(
                                              context,
                                              'Tem certeza que deseja importar os dados da planilha "${result.names.first}"?',
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
                                          },
                                        ),
                                      ),
                                    );
                                  }
                                },
                                style: OutlinedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 20),
                                  minimumSize: const Size(0, 0),
                                ),
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
                              child: OutlinedButton(
                                onPressed: () async {
                                  FilePickerResult? result = await FilePicker.platform.pickFiles(
                                    allowedExtensions: ['csv'],
                                    type: FileType.custom,
                                  );

                                  if (result != null) {
                                    String csvPath = result.files.single.path!;
                                    List<Log> logs = CsvService().convertCsvToLogs(csvPath);

                                    Navigator.push(
                                      context,
                                      HorizontalRouter(
                                        child: ViewImportedLogsPage(
                                          title: result.files.single.name,
                                          logs: logs,
                                          onConfirm: () async {
                                            bool isSure = await showConfirmDialog(
                                              context,
                                              'Tem certeza que deseja importar os dados da planilha "${result.names.first}"?',
                                              content:
                                                  'Todos os logs já existentes deste exercício serão REMOVIDOS e SUBSTITUÍDOS pelos logs desta planilha.',
                                              confirm: 'Sim, importar e substituir dados',
                                              cancel: 'Não, cancelar',
                                            );

                                            if (!isSure) return;

                                            runLoading(() async {
                                              await _controller.importCsv(result.files.single.path!);
                                              setState(() {});
                                              Navigator.pop(context);
                                            });
                                          },
                                        ),
                                      ),
                                    );
                                  }
                                },
                                style: OutlinedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 20),
                                  minimumSize: const Size(0, 0),
                                ),
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
                                  child: ViewLogsPage(exercise: widget.exercise),
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
            ExerciseChartPage.showAddLog(context, exercise: widget.exercise, onConfirm: (weight, reps, date, notes) {
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
