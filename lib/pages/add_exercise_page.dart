// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:gym_log/pages/add_exercise_controller.dart';
import 'package:gym_log/pages/export_category_page.dart';
import 'package:gym_log/utils/extensions.dart';
import 'package:gym_log/utils/routers.dart';
import 'package:gym_log/utils/show_error.dart';
import 'package:gym_log/utils/show_popup.dart';
import 'package:gym_log/widgets/empty_message.dart';
import 'package:gym_log/widgets/loading_elevated_button.dart';
import 'package:gym_log/widgets/loading_manager.dart';
import 'package:gym_log/widgets/popup_buton.dart';

import '../entities/exercise.dart';
import '../repositories/exercise_repository.dart';
import '../repositories/exercise_selection_repository.dart';
import 'import_category_page.dart';

class AddExercisePage extends StatefulWidget {
  final String category;
  final Set<String> exercisesInUse;

  const AddExercisePage({
    super.key,
    required this.category,
    required this.exercisesInUse,
  });

  @override
  State<AddExercisePage> createState() => _AddExercisePageState();
}

class _AddExercisePageState extends State<AddExercisePage> with LoadingManager {
  Future<void> _addExercise() async {
    var exerciseController = TextEditingController();

    // TODO(um form ficaria melhor)
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Adicionar exercício'),
          content: TextField(
            controller: exerciseController,
            decoration:
                const InputDecoration(labelText: 'Nome', counterText: ''),
            maxLength: 50,
          ),
          actions: [
            ElevatedButton(
              onPressed: () async {
                String exerciseName = exerciseController.text.trim();

                if (exerciseName.isEmpty) {
                  Navigator.pop(context);
                  return;
                }

                if (_exercises
                    .any((exercise) => exercise.name == exerciseName)) {
                  showError(context,
                      content: 'Já existe um exercício com este nome.');
                  return;
                }

                setLoading(true);
                Navigator.pop(context);

                await ExerciseSelectionRepositoryX(widget.category)
                    .add(exerciseName);
                await _updateExercises();
                setState(() {});
                setLoading(false);
              },
              child: const Text('Ok'),
            ),
          ],
        );
      },
    );
  }

  // TODO(não vou alterar agora, mas curioso essas variáveis. por que existe o _selectedExerciseName?)
  // Nota: é mais fácil alterar a estrutura no FireStore por enquanto.
  // String _selectedExercise = '';
  // String _selectedExerciseName = '';

  final List<String> _selectedExerciseIds = [];
  Set<String> _selectedExerciseIdsSet = {};
  // final Set<String> _selectedExerciseIds = {};
  // String _selectedExerciseId = '';

  // late AddExerciseController _controller;
  late AddExerciseControllerX _controller;
  List<ExerciseX> _exercises = [];
  late final Future<void> _exercisesLoader;

  Future<void> _updateExercises() async {
    _exercises = await _controller.getAllNotSelected();
  }

  @override
  void initState() {
    super.initState();

    _controller = AddExerciseControllerX(
      categoryId: widget.category,
      exercisesInUse: widget.exercisesInUse,
    );
    _exercisesLoader = _updateExercises();
  }

  @override
  Widget build(BuildContext context) {
    return LoadingPresenter(
      isLoadingNotifier: isLoadingNotifier,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Adicionar exercício'),
          actions: [
            Builder(builder: (context) {
              return IconButton(
                onPressed: () {
                  showPopup(
                    context,
                    height: 200,
                    width: 200,
                    builder: (context) {
                      return Container();

                      // TODO(desfazer)
                      // return Column(
                      //   mainAxisSize: MainAxisSize.min,
                      //   children: [
                      //     PopupIconButton(
                      //       icon: const Icon(Icons.arrow_upward),
                      //       onTap: () {
                      //         Navigator.pop(context);
                      //         Navigator.push(
                      //           context,
                      //           HorizontalRouter(
                      //             child: ExportCategoryPage(
                      //               category: widget.category,
                      //               exercises: _exercises,
                      //             ),
                      //           ),
                      //         );
                      //       },
                      //       child: const Text('Exportar lista para...'),
                      //     ),
                      //     PopupIconButton(
                      //       icon: const Icon(Icons.arrow_downward),
                      //       onTap: () {
                      //         Navigator.pop(context);
                      //         Navigator.push(
                      //           context,
                      //           HorizontalRouter(
                      //               child: ImportCategoryPage(
                      //                   category: widget.category,
                      //                   exercises: _exercises)),
                      //         ).then((_) async {
                      //           await _updateExercises();
                      //           setState(() {});
                      //         });
                      //       },
                      //       child: const Text('Importar lista de...'),
                      //     ),
                      //   ],
                      // );
                    },
                  );
                },
                icon: const Icon(Icons.import_export),
              );
            }),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: () {
            _addExercise();
          },
        ),
        body: FutureBuilder(
          future: _exercisesLoader,
          builder: (context, _) {
            return Visibility(
              visible: _exercises.isNotEmpty,
              replacement: const EmptyMessage(
                  'Não existem exercícios para serem selecionados.\nCrie um em ( + )'),
              child: Scrollbar(
                child: ListView.separated(
                  padding: const EdgeInsets.only(bottom: 70),
                  physics: const ClampingScrollPhysics(),
                  itemCount: _exercises.length,
                  separatorBuilder: (context, index) =>
                      const Divider(height: 0),
                  itemBuilder: (context, index) {
                    final exercise = _exercises[index];

                    return Stack(
                      children: [
                        CheckboxListTile(
                          controlAffinity: ListTileControlAffinity.leading,
                          title: Text(exercise.name),
                          value: _selectedExerciseIdsSet.contains(exercise.id),
                          onChanged: (isActive) {
                            if (isActive!) {
                              _selectedExerciseIds.add(exercise.id);
                            } else {
                              _selectedExerciseIds.remove(exercise.id);
                            }

                            _selectedExerciseIdsSet =
                                _selectedExerciseIds.toSet();

                            setState(() {});
                          },
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: Builder(builder: (context) {
                            return IconButton(
                              onPressed: () {
                                showPopup(context, builder: (context) {
                                  return PopupButton(
                                      label: 'Excluir',
                                      onTap: () async {
                                        setLoading(true);
                                        Navigator.pop(context);
                                        await ExerciseSelectionRepositoryX(
                                                widget.category)
                                            .delete(exercise.id);

                                        _selectedExerciseIds
                                            .remove(exercise.id);

                                        _exercises.remove(exercise);

                                        setState(() {});
                                        setLoading(false);
                                      });
                                });
                              },
                              icon: const Icon(Icons.more_vert),
                            );
                          }),
                        ),
                      ],
                    );
                  },
                ),
              ),
            );
          },
        ),
        bottomNavigationBar: Container(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
          child: Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Cancelar'),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: LoadingElevatedButton(
                  onPressed: () async {
                    if (_selectedExerciseIds.isEmpty) return;

                    setLoading(true);

                    // Usa set para não adicionar nomes repetidos. Tudo bem ter isso
                    // nesta página caso o usuário consiga essa façanha, mas é desnecessário
                    // levar isso pros exercícios selecionados.
                    // Set<String> selectedExercisesNames = _exercises
                    //     .where((exercise) =>
                    //         _selectedExerciseIdsSet.contains(exercise.id))
                    //     .map((exercise) => exercise.name)
                    //     .toSet();

                    List<String> selectedExercisesNames = _exercises
                        .where((exercise) =>
                            _selectedExerciseIdsSet.contains(exercise.id))
                        .map((exercise) => exercise.name)
                        .toList();

                    await ExerciseRepositoryX(widget.category)
                        .addAll(selectedExercisesNames);

                    Navigator.pop(context, true);
                    setLoading(false);
                  },
                  child: const Text('Adicionar'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
