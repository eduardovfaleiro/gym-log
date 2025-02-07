// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:gym_log/entities/log.dart';
import 'package:gym_log/repositories/log_repository.dart';
import 'package:gym_log/utils/extensions.dart';
import 'package:gym_log/utils/log_dialogs.dart';
import 'package:gym_log/utils/show_confirm_dialog.dart';
import 'package:gym_log/utils/show_popup.dart';
import 'package:gym_log/widgets/loading_manager.dart';
import 'package:gym_log/widgets/popup_buton.dart';

import '../entities/exercise.dart';

class LogsListView extends StatefulWidget {
  final List<Log> logs;

  final void Function(Log log)? onDelete;
  final void Function(Log oldLog, Log newLog)? onEdit;

  const LogsListView({
    super.key,
    required this.logs,
    this.onDelete,
    this.onEdit,
  });

  @override
  State<LogsListView> createState() => _LogsListViewState();
}

class _LogsListViewState extends State<LogsListView> {
  // late LogRepository _logRepository;

  @override
  void initState() {
    super.initState();

    // if (widget.exercise != null) {
    //   _logRepository = LogRepository(widget.exercise!);
    // }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: const ClampingScrollPhysics(),
      itemCount: widget.logs.length,
      itemBuilder: (context, index) {
        var log = widget.logs[index];

        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              // decoration: BoxDecoration(color: index % 2 == 0 ? Colors.transparent : Colors.grey[300]),
              padding: const EdgeInsets.all(4),
              alignment: Alignment.center,
              child: Padding(
                padding: const EdgeInsets.only(left: 8),
                child: Row(
                  children: [
                    Expanded(flex: 3, child: Text('${log.weight} kg')),
                    Expanded(flex: 3, child: Text(log.reps.toString())),
                    Expanded(flex: 3, child: Text(log.date.formatReadableShort())),
                    const SizedBox(width: 12),
                    Expanded(flex: 6, child: Text(log.notes, maxLines: 3)),
                    if (widget.onDelete != null || widget.onEdit != null)
                      Expanded(
                        flex: 2,
                        child: Builder(
                          builder: (context) {
                            return IconButton(
                              onPressed: () {
                                showPopup(context, width: 200, height: 200, builder: (context) {
                                  return Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      PopupIconButton(
                                        icon: const Icon(Icons.unfold_more),
                                        onTap: () {
                                          Navigator.pop(context);
                                          showDialog(
                                            context: context,
                                            builder: (context) {
                                              return AlertDialog(
                                                insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                                                title: const Text('Visualização completa'),
                                                content: Column(
                                                  mainAxisSize: MainAxisSize.min,
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text('Peso: ${log.weight}'),
                                                    Text('Repetições: ${log.reps}'),
                                                    Text('Data: ${log.date.formatReadable()}'),
                                                    const SizedBox(height: 12),
                                                    const Text('Notas:'),
                                                    Flexible(
                                                      child: SingleChildScrollView(
                                                        child: Text(
                                                          log.notes.isEmpty ? '[Vazio]' : log.notes,
                                                          maxLines: null,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                actions: [
                                                  ElevatedButton(
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                    },
                                                    child: const Text('Ok'),
                                                  ),
                                                ],
                                              );
                                            },
                                          );
                                        },
                                        child: const Text('Visualizar completo'),
                                      ),
                                      PopupIconButton(
                                        icon: const Icon(Icons.edit),
                                        onTap: () async {
                                          Navigator.pop(context);
                                          await showLogDialog(
                                            context,
                                            title: 'Editar log',
                                            log: log,
                                            onConfirm: (weight, reps, date, notes) {
                                              widget.onEdit!(
                                                log,
                                                Log(date: date, weight: weight, reps: reps, notes: notes),
                                              );
                                            },
                                          );
                                        },
                                        child: const Text('Editar'),
                                      ),
                                      PopupIconButton(
                                        icon: const Icon(Icons.delete),
                                        onTap: () async {
                                          Navigator.pop(context);
                                          bool isSure = await showConfirmDialog(
                                            context,
                                            'Tem certeza que deseja excluir log?',
                                            content: 'O seguinte log será excluído e NÃO poderá ser recuperado:'
                                                '\n- Peso: ${log.weight} kg'
                                                '\n- Repetições: ${log.reps}'
                                                '\n- Data: ${log.date.formatReadable()}',
                                            confirm: 'Sim, excluir',
                                            cancel: 'Não, cancelar',
                                          );

                                          if (isSure) {
                                            widget.onDelete!(log);
                                            // await _logRepository.delete(log);
                                            // // ignore: use_build_context_synchronously
                                            // ScaffoldMessenger.of(context).showSnackBar(
                                            //   const SnackBar(
                                            //     content: Text('Log excluído com sucesso!'),
                                            //     duration: Duration(milliseconds: 3000),
                                            //   ),
                                            // );

                                            // widget.onDelete!();
                                          }
                                        },
                                        child: const Text('Excluir'),
                                      ),
                                    ],
                                  );
                                });
                              },
                              icon: const Icon(Icons.more_vert),
                            );
                          },
                        ),
                      ),
                  ],
                ),
              ),
            ),
            const Divider(height: 0),
          ],
        );
      },
    );
  }
}
