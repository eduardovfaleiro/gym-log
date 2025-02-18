// ignore_for_file: use_build_context_synchronously

import 'package:community_material_icon/community_material_icon.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:gym_log/pages/exercise_chart_controller.dart';
import 'package:gym_log/pages/view_imported_logs_page.dart';
import 'package:gym_log/pages/view_logs_page.dart';
import 'package:gym_log/repositories/config.dart';
import 'package:gym_log/utils/exceptions.dart';
import 'package:gym_log/utils/extensions.dart';
import 'package:gym_log/utils/show_confirm_dialog.dart';
import 'package:gym_log/utils/show_error.dart';
import 'package:gym_log/utils/show_snackbar.dart';
import 'package:gym_log/widgets/loading_manager.dart';
import 'package:gym_log/widgets/logs_list_view.dart';
import 'package:gym_log/widgets/popup_buton.dart';
import 'package:open_file/open_file.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../entities/exercise.dart';
import '../entities/log.dart';
import '../services/csv_service.dart';
import '../services/excel_service.dart';
import '../utils/log_dialogs.dart';
import '../utils/show_popup.dart';

class ExerciseChartPage extends StatefulWidget {
  final Exercise exercise;

  const ExerciseChartPage({super.key, required this.exercise});

  @override
  State<ExerciseChartPage> createState() => _ExerciseChartPageState();
}

class _ExerciseChartPageState extends State<ExerciseChartPage> with LoadingManager {
  late final ExerciseChartController _controller;

  @override
  void initState() {
    super.initState();

    _controller = ExerciseChartController(widget.exercise);

    setLoading(true);

    _controller.loadLogs().whenComplete(() {
      setState(() {});
      setLoading(false);
    });
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

                setLoading(true);
                await _controller.logRepository.replaceAll(logs);
                setState(() {});
                Navigator.pop(context);
                setLoading(false);
              });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext scaffoldContext) {
    return LoadingPresenter(
      isLoadingNotifier: isLoadingNotifier,
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.exercise.name),
          actions: [
            Builder(
              builder: (context) {
                return IconButton(
                  onPressed: () {
                    showPopup(
                      context,
                      height: 260,
                      width: 200,
                      builder: (context) {
                        return PopupContainer(
                          child: Container(
                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                PopupContainer(
                                  child: Container(
                                    padding: const EdgeInsets.only(left: 12, top: 12, bottom: 4),
                                    width: 200,
                                    child: Text('Exportar para', style: Theme.of(context).textTheme.titleMedium!),
                                  ),
                                ),
                                PopupIconButton(
                                  onTap: () async {
                                    bool isSure = await _showConfirmExport(context);
                                    if (!isSure) return;

                                    var result = await _controller.exportAndOpenAsCsv();
                                    if (result.resultType != ResultType.done) {
                                      showSnackBar(
                                        'Arquivo "${result.fileName}" criado em Downloads',
                                        context,
                                        duration: const Duration(seconds: 4),
                                      );
                                    }
                                  },
                                  child: const Text('csv'),
                                ),
                                PopupIconButton(
                                  onTap: () async {
                                    bool isSure = await _showConfirmExport(context);
                                    if (!isSure) return;

                                    var result = await _controller.exportAndOpenAsExcel();
                                    if (result.resultType != ResultType.done) {
                                      showSnackBar(
                                        'Arquivo "${result.fileName}" criado em Downloads',
                                        context,
                                        duration: const Duration(seconds: 4),
                                      );
                                    }
                                  },
                                  child: const Text('xlsx'),
                                ),
                                PopupContainer(
                                  child: Container(
                                    padding: const EdgeInsets.only(left: 12, top: 12, bottom: 4),
                                    width: 200,
                                    child: Text(
                                      'Importar de',
                                      style: Theme.of(context).textTheme.titleMedium!,
                                    ),
                                  ),
                                ),
                                PopupIconButton(
                                  onTap: () async {
                                    FilePickerResult? result = await FilePicker.platform.pickFiles(
                                      allowedExtensions: ['csv'],
                                      type: FileType.custom,
                                    );
                                    if (result == null) return;

                                    setLoading(true);
                                    String csvPath = result.files.single.path!;
                                    List<Log> logs = [];

                                    try {
                                      setLoading(true);
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
                                    } finally {
                                      _pushViewImportedLogs(
                                        context: context,
                                        sheetName: result.names.first!,
                                        logs: logs,
                                      );
                                      setLoading(false);
                                    }
                                  },
                                  child: const Text('csv'),
                                ),
                                PopupIconButton(
                                  onTap: () async {
                                    FilePickerResult? result = await FilePicker.platform.pickFiles(
                                      allowedExtensions: ['xlsx'],
                                      type: FileType.custom,
                                    );
                                    if (result == null) return;

                                    setLoading(true);
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
                                      setLoading(false);
                                      return;
                                    } catch (error) {
                                      showError(
                                        context,
                                        content:
                                            'Não foi possível importar o arquivo .xlsx. Por favor, tente novamente.',
                                      );
                                      setLoading(false);
                                      return;
                                    }

                                    _pushViewImportedLogs(
                                      context: context,
                                      sheetName: result.names.first!,
                                      logs: logs,
                                    );
                                    setLoading(false);
                                  },
                                  child: const Text('xlsx'),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                  icon: const Icon(Icons.more_vert),
                );
              },
            ),
          ],
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: DropdownMenu(
                initialSelection: Config.getInt('repMax', defaultValue: 1),
                dropdownMenuEntries: List.generate(13, (rpm) {
                  return DropdownMenuEntry(value: rpm, label: '$rpm RPM');
                }).sublist(1, 13),
                width: double.infinity,
                label: const Text('Normalizar para'),
                onSelected: (selectedRpm) async {
                  setLoading(true);
                  Config.setInt('repMax', selectedRpm!);
                  setState(() {});
                  setLoading(false);
                },
              ),
            ),
            SfCartesianChart(
              zoomPanBehavior: ZoomPanBehavior(enablePanning: true),
              primaryXAxis: CategoryAxis(
                autoScrollingDelta: 4,
              ),
              series: <CartesianSeries<Log, String>>[
                LineSeries<Log, String>(
                  dataSource: _controller.getChartLogs(),
                  xValueMapper: (Log log, _) => log.date.formatReadableShort(),
                  yValueMapper: (Log log, _) => double.parse(log.weight.toStringAsFixed(1)),
                  dataLabelSettings: const DataLabelSettings(isVisible: true),
                )
              ],
            ),
            Expanded(
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    child: Stack(
                      alignment: Alignment.centerLeft,
                      children: [
                        const Row(
                          children: [
                            Expanded(flex: 3, child: Text('Peso')),
                            Expanded(flex: 3, child: Text('Reps')),
                            Expanded(flex: 3, child: Text('Data')),
                            SizedBox(width: 12),
                            Expanded(flex: 6, child: Text('Notas')),
                            Expanded(flex: 2, child: SizedBox.shrink()),
                          ],
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: IconButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ViewLogsPage(
                                      exercise: widget.exercise,
                                      logs: _controller.logs,
                                      onUpdate: () {
                                        setState(() {});
                                      },
                                    ),
                                  ),
                                );
                              },
                              icon: const Icon(CommunityMaterialIcons.arrow_expand)),
                        )
                      ],
                    ),
                  ),
                  const Divider(height: 0),
                  Expanded(
                    child: Visibility(
                      visible: _controller.logs.isNotEmpty,
                      replacement: const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text('Ainda não existem logs para exibir.'),
                      ),
                      child: LogsListView(
                        logs: _controller.logs,
                        onDelete: (Log log) async {
                          setLoading(true);
                          await _controller.logRepository.delete(log);
                          showSnackBar('Log excluído com sucesso!', scaffoldContext);
                          setState(() {});
                          setLoading(false);
                        },
                        onEdit: (Log oldLog, Log newLog) async {
                          setLoading(true);
                          await _controller.updateLog(newLog);
                          setState(() {});
                          setLoading(false);
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            showAddLog(context, exercise: widget.exercise, onConfirm: (logToAdd) async {
              setLoading(true);
              await _controller.logRepository.add(logToAdd);
              await _controller.loadLogs();
              setState(() {});
              setLoading(false);
            });
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
