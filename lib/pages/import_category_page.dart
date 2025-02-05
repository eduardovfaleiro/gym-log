import 'package:flutter/material.dart';
import 'package:gym_log/entities/exercise.dart';
import 'package:gym_log/repositories/category_repository.dart';
import 'package:gym_log/repositories/exercise_selection_repository.dart';
import 'package:gym_log/widgets/empty_message.dart';
import 'package:gym_log/widgets/loading_manager.dart';

class ImportCategoryPage extends StatefulWidget {
  final String category;
  final List<String> exercises;

  const ImportCategoryPage({super.key, required this.category, required this.exercises});

  @override
  State<ImportCategoryPage> createState() => _ImportCategoryPageState();
}

class _ImportCategoryPageState extends State<ImportCategoryPage> with LoadingManager {
  String? _selectedCategory;

  @override
  Widget build(BuildContext context) {
    return LoadingPresenter(
      isLoadingNotifier: isLoadingNotifier,
      child: Scaffold(
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
                    if (_selectedCategory == null) {
                      Navigator.pop(context);
                      return;
                    }

                    setLoading(true);
                    // runLoading(() async {
                    String selectedCategory = _selectedCategory!;
                    List<String> exercises = await ExerciseSelectionRepository().getAllFromCategory(selectedCategory);

                    exercises.removeWhere((exercise) {
                      return widget.exercises.contains(exercise);
                    });

                    await ExerciseSelectionRepository().addAll(
                      exercises.map((exercise) => Exercise(name: exercise, category: widget.category)).toList(),
                    );
                    // ignore: use_build_context_synchronously
                    Navigator.pop(context);
                    // });
                    setLoading(false);
                  },
                  child: const Text('Importar'),
                ),
              ),
            ],
          ),
        ),
        appBar: AppBar(),
        body: FutureBuilder(
          future: CategoryRepository().getAll(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting || !snapshot.hasData) {
              return const SizedBox.shrink();
            }

            List<String> categories = snapshot.data!;
            categories.removeWhere((category) => category == widget.category);

            if (categories.isEmpty) {
              return const EmptyMessage(
                'Não existem categorias para serem selecionadas.\nCrie uma no Menu Principal -> ( + )',
              );
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  child: Text('Obs: A lista de exercícios atual não será substituída, '
                      'será apenas concatenada com a lista a ser importada.'),
                ),
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text('Importar lista de exercícios de', style: Theme.of(context).textTheme.titleLarge),
                ),
                Flexible(
                  child: StatefulBuilder(
                    builder: (contex, setStateList) {
                      return SingleChildScrollView(
                        child: Column(
                          children: List.generate(
                            categories.length,
                            (index) {
                              String category = categories[index];

                              return Column(
                                children: [
                                  RadioListTile(
                                    title: Text(category),
                                    value: category,
                                    groupValue: _selectedCategory,
                                    onChanged: (value) {
                                      setStateList(() {
                                        _selectedCategory = value!;
                                      });
                                    },
                                  ),
                                  const Divider(height: 0),
                                ],
                              );
                            },
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text('Para', style: Theme.of(context).textTheme.titleLarge),
                ),
                RadioListTile(
                  title: Text(widget.category),
                  value: null,
                  groupValue: null,
                  selected: true,
                  onChanged: (_) {},
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
