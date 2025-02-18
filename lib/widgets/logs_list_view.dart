// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:community_material_icon/community_material_icon.dart';
import 'package:flutter/material.dart';
import 'package:gym_log/entities/log.dart';
import 'package:gym_log/utils/extensions.dart';
import 'package:gym_log/utils/log_dialogs.dart';
import 'package:gym_log/utils/show_confirm_dialog.dart';
import 'package:gym_log/utils/show_popup.dart';
import 'package:gym_log/widgets/popup_buton.dart';

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
  late List<Log> _orderedLogs;

  void _orderLogsByDateDesc() async {
    _orderedLogs = widget.logs;
    _orderedLogs.sort((a, b) => b.date.compareTo(a.date));
  }

  @override
  Widget build(BuildContext context) {
    _orderLogsByDateDesc();

    return Scrollbar(
      child: ListView.builder(
        physics: const ClampingScrollPhysics(),
        itemCount: _orderedLogs.length,
        padding: const EdgeInsets.only(bottom: 90),
        itemBuilder: (context, index) {
          var log = _orderedLogs[index];

          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
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
                                  showPopup(context, width: 200, height: 145, builder: (context) {
                                    return PopupContainer(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          PopupIconButton(
                                            icon: const Icon(CommunityMaterialIcons.arrow_expand),
                                            onTap: () {
                                              Navigator.pop(context);
                                              showDialog(
                                                context: context,
                                                builder: (context) {
                                                  return AlertDialog(
                                                    insetPadding:
                                                        const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
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
                                                onConfirm: (editedLog) {
                                                  widget.onEdit!(log, editedLog);
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
                                              }
                                            },
                                            child: const Text('Excluir'),
                                          ),
                                        ],
                                      ),
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
      ),
    );
  }
}
