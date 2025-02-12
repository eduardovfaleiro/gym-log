// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:gym_log/pages/add_exercise_page.dart';
import 'package:gym_log/repositories/log_repository.dart';
import 'package:gym_log/utils/routers.dart';
import 'package:gym_log/utils/show_snackbar.dart';
import 'package:gym_log/widgets/exercise_card.dart';
import 'package:gym_log/widgets/loading_manager.dart';

import '../entities/exercise.dart';
import '../repositories/exercise_repository.dart';
import '../widgets/empty_message.dart';

class ExercisesPage extends StatefulWidget {
  final String category;

  const ExercisesPage({super.key, required this.category});

  @override
  State<ExercisesPage> createState() => _ExercisesPageState();
}

class _ExercisesPageState extends State<ExercisesPage> with LoadingManager {
  List<String>? _exercises;
  final _exerciseRepository = ExerciseRepository();

  @override
  Widget build(BuildContext context) {
    return LoadingPresenter(
      isLoadingNotifier: isLoadingNotifier,
      showLoadingAnimation: false,
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: () {
            Navigator.push(
              context,
              HorizontalRouter(
                child: AddExercisePage(category: widget.category),
              ),
            ).then((added) {
              if (added == true) setState(() {});
            });
          },
        ),
        appBar: AppBar(
          title: Text(widget.category),
        ),
        body: FutureBuilder(
          future: _exerciseRepository.getAllFromCategory(widget.category),
          builder: (context, snapshot) {
            _exercises = snapshot.data;

            return StatefulBuilder(
              builder: (context, setStateList) {
                return Visibility(
                  visible: _exercises?.isNotEmpty ?? true,
                  replacement: const EmptyMessage('Você ainda não selecionou nenhum exercício. Selecione em ( + )'),
                  child: ReorderableListView(
                    children: List.generate(_exercises?.length ?? 0, (index) {
                      var exercise = Exercise(name: _exercises![index], category: widget.category);
                      return Column(
                        key: UniqueKey(),
                        children: [
                          ExerciseCard(
                            exercise: exercise,
                            onAddLog: (log) async {
                              setLoading(true);
                              final logRepository = LogRepository(exercise);

                              await logRepository.add(log);
                              bool isPR = await logRepository.isPR(log);

                              if (isPR) {
                                showSnackBar('Novo PR alcançado!', context);
                              }
                              showSnackBar('Log adicionado com sucesso!', context);
                              setLoading(false);
                            },
                            onDelete: () async {
                              setLoading(true);
                              await _exerciseRepository.delete(exercise);
                              setState(() {});
                              setLoading(false);
                            },
                          ),
                          const Divider(height: 0),
                        ],
                      );
                    }),
                    onReorder: (oldIndex, newIndex) async {
                      if (oldIndex < newIndex) {
                        newIndex -= 1;
                      }
                      final String exercise = _exercises!.removeAt(oldIndex);
                      _exercises!.insert(newIndex, exercise);

                      List<OrderedExercise> orderedExercises = [];

                      for (int i = 0; i < _exercises!.length; i++) {
                        orderedExercises.add(OrderedExercise(name: _exercises![i], order: i));
                      }

                      setStateList(() {});

                      setLoading(true);
                      await _exerciseRepository.updateOrder(
                        category: widget.category,
                        orderedExercises: orderedExercises,
                      );
                      setLoading(false);
                    },
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
