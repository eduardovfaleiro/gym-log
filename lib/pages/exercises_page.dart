import 'package:flutter/material.dart';
import 'package:gym_log/pages/add_exercise_page.dart';
import 'package:gym_log/utils/show_confirm_dialog.dart';
import 'package:gym_log/widgets/loading_manager.dart';
import 'package:popover/popover.dart';

import '../entities/exercise.dart';
import '../entities/log.dart';
import '../repositories/exercise_repository.dart';
import '../repositories/log_repository.dart';
import 'exercise_chart_page.dart';

class ExercisesPage extends StatefulWidget {
  final String category;

  const ExercisesPage({super.key, required this.category});

  @override
  State<ExercisesPage> createState() => _ExercisesPageState();
}

class _ExercisesPageState extends State<ExercisesPage> {
  @override
  Widget build(BuildContext context) {
    return LoadingManager(
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: () async {
            await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return AddExercisePage(category: widget.category);
                },
              ),
            );
            setState(() {});
          },
        ),
        appBar: AppBar(
          title: Text(widget.category),
        ),
        body: FutureBuilder(
          future: ExerciseRepository().getAllFromCategory(widget.category),
          builder: (context, snapshot) {
            var exercises = snapshot.data;

            return Visibility(
              visible: exercises?.isNotEmpty ?? true,
              replacement: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                alignment: Alignment.center,
                child: const Text(
                  'Você ainda não selecionou nenhum exercício. Selecione em ( + )',
                  textAlign: TextAlign.center,
                ),
              ),
              child: ListView.separated(
                physics: const ClampingScrollPhysics(),
                itemCount: exercises?.length ?? 0,
                separatorBuilder: (context, index) {
                  return const Divider(height: 0);
                },
                itemBuilder: (context, index) {
                  var exercise = Exercise(name: exercises![index], category: widget.category);

                  return Builder(
                    builder: (context) {
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
                                          LogRepository(exercise).add(Log(
                                            date: date,
                                            reps: reps,
                                            weight: weight,
                                            notes: notes,
                                          ));
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
                                                  setState(() {});
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
                    },
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
