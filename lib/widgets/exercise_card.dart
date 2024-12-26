import 'package:flutter/material.dart';
import 'package:gym_log/entities/exercise.dart';
import 'package:gym_log/repositories/log_repository.dart';
import 'package:gym_log/utils/horizontal_router.dart';
import 'package:gym_log/utils/show_popup.dart';
import 'package:gym_log/widgets/popup_buton.dart';
import 'package:popover/popover.dart';

import '../entities/log.dart';
import '../pages/exercise_chart_page.dart';
import '../repositories/exercise_repository.dart';
import '../utils/show_confirm_dialog.dart';
import 'loading_manager.dart';

class ExerciseCard extends StatelessWidget {
  final Exercise exercise;
  final void Function() onDelete;

  const ExerciseCard({
    super.key,
    required this.exercise,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
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
                    ExerciseChartPage.showAddLog(context, exercise: exercise, onConfirm: (weight, reps, date, notes) {
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
                  icon: const Icon(Icons.post_add_rounded)),
              Text(exercise.name, style: const TextStyle(fontSize: 16)),
            ],
          ),
          Row(
            children: [
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
                                LoadingManager.run(() async {
                                  await ExerciseRepository().delete(exercise);
                                  onDelete();
                                });
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
              // const Icon(Icons.arrow_forward_ios, size: 14),
            ],
          ),
        ],
      ),
    );
  }
}