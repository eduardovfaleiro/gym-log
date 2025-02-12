// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:gym_log/pages/add_exercise_controller.dart';
import 'package:gym_log/pages/export_category_page.dart';
import 'package:gym_log/utils/routers.dart';
import 'package:gym_log/utils/show_error.dart';
import 'package:gym_log/utils/show_popup.dart';
import 'package:gym_log/widgets/empty_message.dart';
import 'package:gym_log/widgets/loading_manager.dart';
import 'package:gym_log/widgets/popup_buton.dart';

import '../entities/exercise.dart';
import '../repositories/exercise_repository.dart';
import '../repositories/exercise_selection_repository.dart';
import 'import_category_page.dart';

class AddExercisePage extends StatefulWidget {
  final String category;

  const AddExercisePage({super.key, required this.category});

  @override
  State<AddExercisePage> createState() => _AddExercisePageState();
}

class _AddExercisePageState extends State<AddExercisePage> with LoadingManager {
  Future<void> _addExercise() async {
    var exerciseController = TextEditingController();

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Adicionar exercício'),
          content: TextField(
            controller: exerciseController,
            decoration: const InputDecoration(labelText: 'Nome'),
            maxLength: 50,
          ),
          actions: [
            ElevatedButton(
              onPressed: () async {
                if (exerciseController.text.isEmpty) {
                  Navigator.pop(context);
                  return;
                }

                final exerciseSelectionRepository = ExerciseSelectionRepository();

                Exercise? exercise = await exerciseSelectionRepository
                    .get(Exercise(name: exerciseController.text, category: widget.category));

                if (exercise != null) {
                  showError(context, content: 'Já existe um exercício com este nome.');
                  return;
                }

                await exerciseSelectionRepository
                    .add(Exercise(name: exerciseController.text, category: widget.category));

                setState(() {});

                Navigator.pop(context);
              },
              child: const Text('Ok'),
            ),
          ],
        );
      },
    );
  }

  String _selectedExercise = '';
  String _selectedExerciseName = '';

  // final List<String> _exercises = [];
  late AddExerciseController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AddExerciseController(category: widget.category);
  }

  List<String> _exercises = [];

  @override
  Widget build(BuildContext context) {
    return LoadingPresenter(
      isLoadingNotifier: isLoadingNotifier,
      showLoadingAnimation: false,
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
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          PopupIconButton(
                            icon: const Icon(Icons.arrow_upward),
                            onTap: () {
                              Navigator.pop(context);
                              Navigator.push(
                                context,
                                HorizontalRouter(
                                  child: ExportCategoryPage(category: widget.category, exercises: _exercises),
                                ),
                              );
                            },
                            child: const Text('Exportar lista para...'),
                          ),
                          PopupIconButton(
                            icon: const Icon(Icons.arrow_downward),
                            onTap: () {
                              Navigator.pop(context);
                              Navigator.push(
                                context,
                                HorizontalRouter(
                                    child: ImportCategoryPage(category: widget.category, exercises: _exercises)),
                              ).then((_) {
                                setState(() {});
                              });
                            },
                            child: const Text('Importar lista de...'),
                          ),
                        ],
                      );
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
          onPressed: () async {
            await _addExercise();
          },
        ),
        body: FutureBuilder(
          future: _controller.getAllNotSelected(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting || !snapshot.hasData) {
              return const SizedBox.shrink();
            }

            if (snapshot.data!.isEmpty) {
              return const EmptyMessage('Não existem exercícios para serem selecionados.\nCrie um em ( + )');
            }

            _exercises = snapshot.data!;

            return StatefulBuilder(
              builder: (context, setStateListView) {
                return Scrollbar(
                  child: ListView.separated(
                    padding: const EdgeInsets.only(bottom: 70),
                    physics: const ClampingScrollPhysics(),
                    itemCount: _exercises.length,
                    separatorBuilder: (context, index) => const Divider(height: 0),
                    itemBuilder: (context, index) {
                      String exercise = _exercises[index];

                      return Stack(
                        children: [
                          RadioListTile(
                            title: Text(exercise),
                            value: exercise,
                            groupValue: _selectedExercise,
                            onChanged: (value) {
                              setStateListView(() {
                                _selectedExercise = value!;
                                _selectedExerciseName = exercise;
                              });
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
                                          await ExerciseSelectionRepository().delete(
                                            Exercise(name: exercise, category: widget.category),
                                          );
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
                );
              },
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
                child: ElevatedButton(
                  onPressed: () async {
                    if (_selectedExercise.isEmpty) return;

                    setLoading(true);

                    await ExerciseRepository().add(Exercise(name: _selectedExerciseName, category: widget.category));
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
