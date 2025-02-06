// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
import '../utils/routers.dart';
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
                setLoading(true);
                String category = categoryController.text;
                final categoryRepository = CategoryRepository();

                if (await categoryRepository.exists(category)) {
                  showError(context, content: 'Já existe uma categoria com este nome.');
                  setLoading(false);
                  return;
                } else {
                  await CategoryRepository().add(category);
                  await _updateCategories();
                  setState(() {});

                  Navigator.pop(context);
                }
                setLoading(false);
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

    setLoading(true);

    _updateCategories().whenComplete(() {
      setState(() {});
      setLoading(false);
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
      showLoadingAnimation: false,
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            _addCategory(context);
          },
          child: const Icon(Icons.add),
        ),
        appBar: AppBar(
          title: SvgPicture.asset(
            'assets/gym_log_horizontal_logo.svg',
            height: 20,
            fit: BoxFit.fitHeight,
            colorFilter: ColorFilter.mode(
              Theme.of(context).colorScheme.primary,
              BlendMode.srcIn,
            ),
          ),
          actions: [
            Container(
              constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * .4),
              child: Builder(
                builder: (context) {
                  return TextButton.icon(
                    icon: const Icon(Icons.account_circle_outlined),
                    onPressed: () async {
                      showPopup(
                        context,
                        xOffset: -48,
                        builder: (context) {
                          return PopupButton(
                            label: 'Desconectar',
                            onTap: () async {
                              setLoading(true);
                              await FirebaseUIAuth.signOut(
                                context: context,
                                auth: fa,
                              );
                              Navigator.pop(context);
                              setLoading(false);
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
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              width: 40,
              child: IconButton(
                onPressed: () {
                  brightnessManager.switchBrightness();
                },
                icon: const Icon(Icons.light_mode),
                selectedIcon: const Icon(Icons.dark_mode),
                isSelected: brightnessManager.brightness == Brightness.dark,
              ),
            ),
          ],
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
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
            Container(
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.only(left: 12, right: 12, top: 16, bottom: 8),
              child: Text('Categorias', style: Theme.of(context).textTheme.titleLarge),
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
                child: StatefulBuilder(
                  builder: (context, setStateListView) {
                    if (isLoading) {
                      return const SizedBox.shrink();
                    }

                    if (_categories.isEmpty) {
                      return const EmptyMessage('Você não possui categorias para selecionar.\nCrie uma em ( + )');
                    }

                    return ReorderableListView(
                      physics: const ClampingScrollPhysics(),
                      onReorder: (oldIndex, newIndex) async {
                        if (oldIndex < newIndex) {
                          newIndex -= 1;
                        }
                        final String category = _categories.removeAt(oldIndex);
                        _categories.insert(newIndex, category);

                        Map<String, int> orderedCategories = {};

                        for (int i = 0; i < _categories.length; i++) {
                          orderedCategories[_categories[i]] = i;
                        }

                        setLoading(true);
                        setStateListView(() {});
                        await CategoryRepository().updateOrder(orderedCategories: orderedCategories);
                        setLoading(false);
                      },
                      children: List.generate(_categories.length, (index) {
                        String category = _categories[index];

                        return Column(
                          key: UniqueKey(),
                          children: [
                            ActionCard(
                              onTap: () async {
                                _focusNode = FocusNode();
                                await Navigator.push(
                                  context,
                                  HorizontalRouter(child: ExercisesPage(category: _categories[index])),
                                );
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
                                                    setLoading(true);
                                                    await CategoryRepository().delete(category);
                                                    await _updateCategories();
                                                    setStateListView(() {});
                                                    setLoading(false);
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
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
