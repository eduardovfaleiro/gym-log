import 'package:flutter/material.dart';
import 'package:gym_log/pages/add_exercise_page.dart';
import 'package:gym_log/utils/horizontal_router.dart';
import 'package:gym_log/utils/show_confirm_dialog.dart';
import 'package:gym_log/widgets/exercise_card.dart';
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
              HorizontalRouter(
                child: AddExercisePage(category: widget.category),
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
                child: ReorderableListView(
                  children: List.generate(exercises?.length ?? 0, (index) {
                    var exercise = Exercise(name: exercises![index], category: widget.category);

                    return Column(
                      key: ValueKey(exercise.hashCode),
                      children: [
                        ExerciseCard(
                            exercise: exercise,
                            onDelete: () {
                              setState(() {});
                            }),
                        const Divider(height: 0),
                      ],
                    );
                  }),
                  onReorder: (oldIndex, newIndex) {
                    ExerciseRepository().updateOrder(
                      exercise1: exercise1,
                      newOrderExercise1: newOrderExercise1,
                      exercise2: exercise2,
                      newOrderExercise2: newOrderExercise2,
                    );
                  },
                )
                // child: ListView.separated(
                //   physics: const ClampingScrollPhysics(),
                //   itemCount: exercises?.length ?? 0,
                //   separatorBuilder: (context, index) {
                //     return const Divider(height: 0);
                //   },
                //   itemBuilder: (context, index) {
                //     var exercise = Exercise(name: exercises![index], category: widget.category);

                //     return ExerciseCard(
                //         exercise: exercise,
                //         onDelete: () {
                //           setState(() {});
                //         });
                //   },
                // ),
                );
          },
        ),
      ),
    );
  }
}
