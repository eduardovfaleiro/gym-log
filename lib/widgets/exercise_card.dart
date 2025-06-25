import 'package:flutter/material.dart';
import 'package:gym_log/entities/exercise.dart';
import 'package:gym_log/entities/log.dart';
import 'package:gym_log/utils/routers.dart';
import 'package:gym_log/utils/show_async_confirm_dialog.dart';
import 'package:gym_log/utils/show_popup.dart';
import 'package:gym_log/widgets/popup_buton.dart';

import '../pages/exercise_chart_page.dart';
import '../utils/log_dialogs.dart';
import '../utils/show_confirm_dialog.dart';

class ActionCard extends StatelessWidget {
  final void Function() onTap;
  final Widget child;
  final EdgeInsets contentPadding;

  const ActionCard({
    super.key,
    required this.onTap,
    required this.child,
    this.contentPadding =
        const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: contentPadding,
        child: DefaultTextStyle(
          style: Theme.of(context).textTheme.bodyLarge!,
          child: child,
        ),
      ),
    );
  }
}

class ExerciseCardX extends StatelessWidget {
  final ExerciseX exercise;
  final Function() onDelete;
  final Function(Log log) onAddLog;
  final bool showCategory;

  const ExerciseCardX({
    super.key,
    required this.exercise,
    required this.onDelete,
    required this.onAddLog,
    this.showCategory = false,
  });

  @override
  Widget build(BuildContext context) {
    return ActionCard(
      onTap: () {
        Navigator.push(
          context,
          HorizontalRouter(child: ExerciseChartPage(exercise: exercise)),
        );
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(exercise.name),
                // Visibility(
                //   visible: showCategory,
                //   child: Text(
                //     exercise.category,
                //     style: Theme.of(context)
                //         .textTheme
                //         .bodySmall!
                //         .copyWith(color: Theme.of(context).colorScheme.primary),
                //   ),
                // ),
              ],
            ),
          ),
          Row(
            children: [
              // IconButton(
              //   onPressed: () {
              //     showAddLog(context, exercise: exercise,
              //         onConfirm: (log) async {
              //       await onAddLog(log);
              //     });
              //   },
              //   icon: const Icon(Icons.note_add_outlined),
              // ),
              Builder(
                builder: (context) {
                  return IconButton(
                    onPressed: () {
                      showPopup(
                        context,
                        builder: (context) {
                          return PopupButton(
                            label: 'Excluir',
                            onTap: () async {
                              Navigator.pop(context);
                              bool isSure = await showConfirmDialog(
                                context,
                                'Tem certeza que deseja excluir o exercício "${exercise.name}"?',
                                content:
                                    'Os logs deste exercício NÃO poderão ser recuperados.',
                                confirm: 'Sim, excluir',
                              );

                              if (isSure) {
                                onDelete();
                              }
                            },
                          );
                        },
                      );
                    },
                    icon: const Icon(Icons.more_vert, size: 24),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class ExerciseCard extends StatelessWidget {
  final ExerciseX exercise;
  final Function() onDelete;
  final Function(Log log) onAddLog;
  final String? categoryName;

  const ExerciseCard({
    super.key,
    required this.exercise,
    required this.onDelete,
    required this.onAddLog,
    this.categoryName,
  });

  @override
  Widget build(BuildContext context) {
    return ActionCard(
      onTap: () {
        Navigator.push(
          context,
          HorizontalRouter(child: ExerciseChartPage(exercise: exercise)),
        );
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(exercise.name),
                Visibility(
                  visible: categoryName != null,
                  child: Text(
                    categoryName!,
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall!
                        .copyWith(color: Theme.of(context).colorScheme.primary),
                  ),
                ),
              ],
            ),
          ),
          Row(
            children: [
              IconButton(
                onPressed: () {
                  // TODO(desfazer)
                  // showAddLog(context, exercise: exercise,
                  //     onConfirm: (log) async {
                  //   await onAddLog(log);
                  // });
                },
                icon: const Icon(Icons.note_add_outlined),
              ),
              Builder(
                builder: (context) {
                  return IconButton(
                    onPressed: () {
                      showPopup(
                        context,
                        builder: (context) {
                          return PopupButton(
                            label: 'Excluir',
                            onTap: () async {
                              Navigator.pop(context);
                              bool isSure = await showConfirmDialog(
                                // await showConfirmDialog(
                                context,
                                'Tem certeza que deseja excluir o exercício "${exercise.name}"?',
                                content:
                                    'Os logs deste exercício NÃO poderão ser recuperados.',
                                confirm: 'Sim, excluir',
                                // onConfirm: (context) async {
                                //   Navigator.pop(context);
                                //   onDelete();
                                //   // await onDelete();
                                //   // // ignore: use_build_context_synchronously
                                //   // Navigator.pop(context);
                                // },
                              );

                              if (isSure) {
                                onDelete();
                              }
                            },
                          );
                        },
                      );
                    },
                    icon: const Icon(Icons.more_vert, size: 24),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
