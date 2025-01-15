// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:gym_log/main.dart';
import 'package:gym_log/utils/extensions.dart';
import 'package:gym_log/utils/show_confirm_dialog.dart';
import 'package:gym_log/utils/show_error.dart';
import 'package:gym_log/widgets/empty_message.dart';
import 'package:gym_log/widgets/loading_manager.dart';
import 'package:gym_log/widgets/popup_buton.dart';

import '../entities/exercise.dart';
import '../repositories/category_repository.dart';
import '../repositories/exercise_repository.dart';
import '../utils/horizontal_router.dart';
import '../utils/show_popup.dart';
import '../widgets/brightness_manager.dart';
import '../widgets/exercise_card.dart';
import 'exercises_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with LoadingManager {
  List<Exercise> _exercisesSearched = [];
  List<String> _categories = [];

  // TODO(talvez criar meu próprio controller)
  String _oldValueSearchController = '';
  final _searchController = TextEditingController();
  late FocusNode _focusNode;

  Future<void> _addCategory(BuildContext context) async {
    var categoryController = TextEditingController();

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Adicionar categoria'),
          content: TextField(
            controller: categoryController,
            decoration: const InputDecoration(labelText: 'Nome'),
            maxLength: 50,
          ),
          actions: [
            ElevatedButton(
              onPressed: () async {
                runLoading(() async {
                  String category = categoryController.text;
                  final categoryRepository = CategoryRepository();

                  if (await categoryRepository.exists(category)) {
                    showError(context, content: 'Já existe uma categoria com este nome.');
                    return;
                  } else {
                    await CategoryRepository().add(category);
                    await _updateCategories();
                    setState(() {});

                    Navigator.pop(context);
                  }
                });
              },
              child: const Text('Ok'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _updateCategories() async {
    _categories = await CategoryRepository().getAll();
  }

  @override
  void initState() {
    super.initState();

    _focusNode = FocusNode();

    runLoading(() async {
      await _updateCategories();
      setState(() {});
    });

    _searchController.addListener(() async {
      if (_oldValueSearchController == _searchController.text) return;
      _oldValueSearchController = _searchController.text;

      if (_searchController.text.isBlank) {
        _exercisesSearched = [];
        setState(() {});
        return;
      }

      _exercisesSearched = await ExerciseRepository().getAllWithArgs(name: _searchController.text.trim());
      setState(() {});
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _focusNode.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final brightnessManager = BrightnessManager.of(context);

    return LoadingPresenter(
      isLoadingNotifier: isLoadingNotifier,
      showLoadingAnimation: true,
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            _addCategory(context);
          },
          child: const Icon(Icons.add),
        ),
        appBar: AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Gym Log'),
              Container(
                constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * .5),
                child: Builder(
                  builder: (context) {
                    return TextButton.icon(
                      icon: const Icon(Icons.account_circle_outlined),
                      onPressed: () async {
                        showPopup(
                          context,
                          builder: (context) {
                            return PopupButton(
                              label: 'Desconectar',
                              onTap: () async {
                                await FirebaseUIAuth.signOut(
                                  context: context,
                                  auth: fa,
                                );
                                // ignore: use_build_context_synchronously
                                Navigator.pop(context);
                              },
                            );
                          },
                        );
                      },
                      label: Text(
                        fa.currentUser?.email.toString() ?? '',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    );
                  },
                ),
              ),
              IconButton(
                onPressed: () {
                  brightnessManager.updateBrightness(brightnessManager.brightness);
                },
                icon: const Icon(Icons.light_mode),
                selectedIcon: const Icon(Icons.dark_mode),
                isSelected: brightnessManager.brightness == Brightness.dark,
              ),
            ],
          ),
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: TextField(
                autofocus: false,
                focusNode: _focusNode,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: IconButton(
                    onPressed: () {
                      _searchController.clear();
                    },
                    icon: const Icon(Icons.clear),
                  ),
                  hintText: 'Pesquisar exercício...',
                ),
                controller: _searchController,
              ),
            ),
            Expanded(
              child: Visibility(
                visible: _searchController.text.isBlank,
                replacement: ListView.separated(
                  physics: const ClampingScrollPhysics(),
                  itemCount: _exercisesSearched.length,
                  itemBuilder: (context, index) {
                    return ExerciseCard(
                      exercise: _exercisesSearched[index],
                      onDelete: () {
                        setState(() {});
                      },
                      showCategory: true,
                    );
                  },
                  separatorBuilder: (context, index) {
                    return const Divider(height: 0);
                  },
                ),
                child: Builder(builder: (context) {
                  if (isLoading) {
                    return const SizedBox.shrink();
                  }

                  if (_categories.isEmpty) {
                    return const EmptyMessage('Você não possui categorias para selecionar.\nCrie uma em ( + )');
                  }

                  return ReorderableListView(
                    physics: const ClampingScrollPhysics(),
                    onReorder: (oldIndex, newIndex) {
                      if (oldIndex < newIndex) {
                        newIndex -= 1;
                      }
                      final String category = _categories.removeAt(oldIndex);
                      _categories.insert(newIndex, category);

                      Map<String, int> orderedCategories = {};

                      for (int i = 0; i < _categories.length; i++) {
                        orderedCategories[_categories[i]] = i;
                      }

                      runLoading(() async {
                        setState(() {});

                        CategoryRepository().updateOrder(orderedCategories: orderedCategories);
                      });
                    },
                    children: List.generate(_categories.length, (index) {
                      String category = _categories[index];

                      return Column(
                        key: UniqueKey(),
                        children: [
                          ActionCard(
                            onTap: () async {
                              await Navigator.push(
                                context,
                                HorizontalRouter(child: ExercisesPage(category: _categories[index])),
                              );
                              _focusNode = FocusNode();
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(_categories[index]),
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
                                                  'Tem certeza que deseja excluir a categoria "$category"?',
                                                  content:
                                                      'Os logs dos exercícios desta categoria NÃO poderão ser recuperados.',
                                                  confirm: 'Sim, excluir',
                                                );
                                                if (isSure) {
                                                  runLoading(() async {
                                                    await CategoryRepository().delete(category);
                                                    await _updateCategories();
                                                    setState(() {});
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
                              ],
                            ),
                          ),
                          const Divider(height: 0),
                        ],
                      );
                    }),
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
