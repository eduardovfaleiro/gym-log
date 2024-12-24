import 'package:flutter/material.dart';
import 'package:gym_log/entities/exercise.dart';
import 'package:gym_log/repositories/log_repository.dart';
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
          MaterialPageRoute(
            builder: (context) => ExerciseChartPage(exercise: exercise),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.only(right: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                IconButton(
                    onPressed: () {
                      ExerciseChartPage.showAddLog(context, onConfirm: (weight, reps, date, notes) {
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
                IconButton(
                  onPressed: () {
                    showPopover(
                      barrierColor: Colors.transparent,
                      context: context,
                      shadow: [],
                      transitionDuration: Duration.zero,
                      bodyBuilder: (context) {
                        return InkWell(
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
                                // setState(() {});
                                onDelete();
                              });
                            }
                          },
                          child: Container(
                            alignment: Alignment.center,
                            child: const Text('Excluir'),
                          ),
                        );
                      },
                      width: 150,
                      height: 40,
                      backgroundColor: Colors.white,
                      direction: PopoverDirection.bottom,
                    );
                  },
                  icon: const Icon(Icons.more_vert, size: 24),
                  visualDensity: const VisualDensity(),
                  padding: EdgeInsets.zero,
                ),
                const Icon(Icons.arrow_forward_ios, size: 14),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
