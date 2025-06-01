// Correção de possíveis erros: OK
// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:gym_log/pages/add_exercise_page.dart';
import 'package:gym_log/repositories/log_repository.dart';
import 'package:gym_log/utils/routers.dart';
import 'package:gym_log/utils/show_error.dart';
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
  List<String> _exercises = [];
  final _exerciseRepository = ExerciseRepository();
  late final Future<void> _exercisesLoader;

  Future<void> _updateExercises() async {
    _exercises = await _exerciseRepository.getAllFromCategory(widget.category);
  }

  @override
  void initState() {
    super.initState();

    _exercisesLoader = _updateExercises();
  }

  @override
  Widget build(BuildContext context) {
    return LoadingPresenter(
      isLoadingNotifier: isLoadingNotifier,
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: () {
            Navigator.push(
              context,
              HorizontalRouter(
                child: AddExercisePage(
                  category: widget.category,
                  exercisesInUse: _exercises.toSet(),
                ),
              ),
            ).then((added) async {
              // Deixar added == true, pode vir como null.
              if (added == true) {
                await _updateExercises();
                setState(() {});
              }
            });
          },
        ),
        appBar: AppBar(
          title: Text(widget.category),
        ),
        body: FutureBuilder(
          future: _exercisesLoader,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const SizedBox.shrink();
            }

            return Visibility(
              visible: _exercises.isNotEmpty,
              replacement: const EmptyMessage(
                  'Você ainda não selecionou nenhum exercício. Selecione em ( + )'),
              child: ReorderableListView(
                padding: const EdgeInsets.only(bottom: 96),
                children: List.generate(_exercises.length, (index) {
                  var exercise = Exercise(
                      name: _exercises[index], category: widget.category);
                  return Column(
                    key: UniqueKey(),
                    children: [
                      ExerciseCard(
                        exercise: exercise,
                        onAddLog: (log) async {
                          // TODO(ver melhor)
                          setLoading(true);
                          final logRepository = LogRepository(exercise);

                          await logRepository.add(log);
                          bool isPR = await logRepository.isPR(log);

                          if (isPR) {
                            showSnackBar('Novo PR alcançado!', context);
                          } else {
                            showSnackBar(
                                'Log adicionado com sucesso!', context);
                          }
                          setLoading(false);
                        },
                        onDelete: () async {
                          setLoading(true);
                          try {
                            await _exerciseRepository.delete(exercise);
                          } on ExerciseNotFound {
                            showError(context,
                                content: 'Exercício não encontrado.');
                            setLoading(false);
                            return;
                          }
                          await _updateExercises();
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
                  _exercises.insert(newIndex, exercise);

                  List<OrderedExercise> orderedExercises = [];

                  for (int i = 0; i < _exercises.length; i++) {
                    orderedExercises
                        .add(OrderedExercise(name: _exercises[i], order: i));
                  }

                  setState(() {});

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
        ),
      ),
    );
  }
}
