import 'package:flutter/material.dart';
import 'package:gym_log/entities/exercise.dart';
import 'package:gym_log/repositories/log_repository.dart';
import 'package:gym_log/utils/routers.dart';
import 'package:gym_log/utils/show_popup.dart';
import 'package:gym_log/widgets/popup_buton.dart';

import '../entities/log.dart';
import '../pages/exercise_chart_page.dart';
import '../repositories/exercise_repository.dart';
import '../utils/log_dialogs.dart';
import '../utils/show_confirm_dialog.dart';
import 'loading_manager.dart';

class ActionCard extends StatelessWidget {
  final void Function() onTap;
  final Widget child;
  final EdgeInsets contentPadding;

  const ActionCard({
    super.key,
    required this.onTap,
    required this.child,
    this.contentPadding = const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
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

class ExerciseCard extends StatelessWidget with LoadingManager {
  final Exercise exercise;
  final void Function() onDelete;
  final bool showCategory;

  ExerciseCard({
    super.key,
    required this.exercise,
    required this.onDelete,
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
          Row(
            children: [
              IconButton(
                onPressed: () {
                  showAddLog(context, exercise: exercise, onConfirm: (weight, reps, date, notes) {
                    LogRepository(exercise).add(
                      Log(
                        date: date,
                        reps: reps,
                        weight: weight,
                        notes: notes,
                      ),
                    );
                  });
                },
                icon: const Icon(Icons.post_add_rounded),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(exercise.name),
                  Visibility(
                    visible: showCategory,
                    child: Text(
                      exercise.category,
                      style: Theme.of(context).textTheme.bodySmall!.copyWith(color: Theme.of(context).primaryColor),
                    ),
                  ),
                ],
              ),
            ],
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
                            context,
                            'Tem certeza que deseja excluir o exercício "${exercise.name}"?',
                            content: 'Os logs deste exercício NÃO poderão ser recuperados.',
                            confirm: 'Sim, excluir',
                          );

                          if (isSure) {
                            setLoading(true);
                            // runLoading(() async {
                            await ExerciseRepository().delete(exercise);
                            onDelete();
                            // });
                            setLoading(false);
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
    );

    // return InkWell(
    //   onTap: () {
    //     Navigator.push(
    //       context,
    //       HorizontalRouter(child: ExerciseChartPage(exercise: exercise)),
    //     );
    //   },
    //   child: Padding(
    //     padding: const EdgeInsets.symmetric(vertical: 4),
    //     child: Row(
    //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //       children: [
    //         Row(
    //           children: [
    //             IconButton(
    //                 onPressed: () {
    //                   ExerciseChartPage.showAddLog(context, exercise: exercise, onConfirm: (weight, reps, date, notes) {
    //                     LogRepository(exercise).add(
    //                       Log(
    //                         date: date,
    //                         reps: reps,
    //                         weight: weight,
    //                         notes: notes,
    //                       ),
    //                     );
    //                   });
    //                 },
    //                 icon: const Icon(Icons.post_add_rounded)),
    //             Column(
    //               crossAxisAlignment: CrossAxisAlignment.start,
    //               children: [
    //                 Text(exercise.name, style: const TextStyle(fontSize: 16)),
    //                 Visibility(
    //                   visible: showCategory,
    //                   child: Text(
    //                     exercise.category,
    //                     style: TextStyle(color: Theme.of(context).primaryColor),
    //                   ),
    //                 ),
    //               ],
    //             ),
    //           ],
    //         ),
    //         Row(
    //           children: [
    //             Builder(
    //               builder: (context) {
    //                 return IconButton(
    //                   onPressed: () {
    //                     showPopup(
    //                       context,
    //                       builder: (context) {
    //                         return PopupButton(
    //                           label: 'Excluir',
    //                           onTap: () async {
    //                             Navigator.pop(context);
    //                             bool isSure = await showConfirmDialog(
    //                               context,
    //                               'Tem certeza que deseja excluir o exercício "${exercise.name}"?',
    //                               content: 'Os logs deste exercício NÃO poderão ser recuperados.',
    //                               confirm: 'Sim, excluir',
    //                             );

    //                             if (isSure) {
    //                               LoadingManager.run(() async {
    //                                 await ExerciseRepository().delete(exercise);
    //                                 onDelete();
    //                               });
    //                             }
    //                           },
    //                         );
    //                       },
    //                     );
    //                   },
    //                   icon: const Icon(Icons.more_vert, size: 24),
    //                 );
    //               },
    //             ),
    //             // const Icon(Icons.arrow_forward_ios, size: 14),
    //           ],
    //         ),
    //       ],
    //     ),
    //   ),
    // );
  }
}
