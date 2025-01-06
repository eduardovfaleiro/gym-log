// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:gym_log/entities/log.dart';
import 'package:gym_log/repositories/log_repository.dart';
import 'package:gym_log/utils/extensions.dart';
import 'package:gym_log/utils/show_confirm_dialog.dart';
import 'package:gym_log/utils/show_popup.dart';
import 'package:gym_log/widgets/loading_manager.dart';
import 'package:gym_log/widgets/popup_buton.dart';

import '../entities/exercise.dart';

class LogsListView extends StatelessWidget {
  final Exercise? exercise;
  final List<Log> logs;
  final void Function()? onDelete;

  const LogsListView({
    super.key,
    this.exercise,
    required this.logs,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: const ClampingScrollPhysics(),
      itemCount: logs.length,
      itemBuilder: (context, index) {
        var log = logs[index];

        return Container(
          decoration: BoxDecoration(color: index % 2 == 0 ? Colors.transparent : Colors.grey[300]),
          padding: const EdgeInsets.all(4),
          alignment: Alignment.center,
          child: Container(
            padding: const EdgeInsets.only(left: 8),
            child: Row(
              children: [
                Expanded(child: Text('${log.weight} kg')),
                Expanded(child: Text(log.reps.toString())),
                Expanded(child: Text(log.date.formatReadableShort())),
                Expanded(child: Text(log.notes)),
                Expanded(
                  child: Builder(
                    builder: (context) {
                      return IconButton(
                          onPressed: () {
                            showPopup(context, height: 200, builder: (context) {
                              return Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
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
                                        await LogRepository(exercise!).delete(log);
                                        onDelete!();
                                      }
                                    },
                                    child: const Text('Excluir'),
                                  ),
                                  PopupIconButton(
                                    icon: const Icon(Icons.edit),
                                    onTap: () {},
                                    child: const Text('Editar'),
                                  ),
                                ],
                              );
                            });
                          },
                          icon: const Icon(Icons.more_vert));
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
