// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:gym_log/main.dart';
import 'package:gym_log/repositories/log_repository.dart';
import 'package:gym_log/services/google_sign_in_service.dart';
import 'package:gym_log/utils/delete_user.dart';
import 'package:gym_log/utils/extensions.dart';
import 'package:gym_log/utils/show_confirm_dialog.dart';
import 'package:gym_log/utils/show_error.dart';
import 'package:gym_log/utils/show_snackbar.dart';
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
  List<String>? _categories = [];

  String _oldValueSearchController = '';
  final _searchController = TextEditingController();
  late FocusNode _focusNode;
  Timer? _debounce;

  final _exerciseRepository = ExerciseRepository();
  final _categoryRepository = CategoryRepository();

  Future<void> _addCategory(BuildContext context) async {
    var categoryController = TextEditingController();

    final formKey = GlobalKey<FormState>();

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Adicionar categoria'),
          content: Form(
            key: formKey,
            child: TextFormField(
              validator: (nome) {
                if (nome == null || nome.trim().isEmpty) {
                  return 'O nome deve estar preenchido.';
                }
              },
              controller: categoryController,
              decoration: const InputDecoration(labelText: 'Nome'),
              maxLength: 50,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () async {
                if (!formKey.currentState!.validate()) return;
                Navigator.pop(context);

                setLoading(true);
                String category = categoryController.text;

                if (await _categoryRepository.exists(category)) {
                  showError(
                    context,
                    content: 'Já existe uma categoria com este nome.',
                  );
                  setLoading(false);
                  return;
                } else {
                  await _categoryRepository.add(category);
                  await _updateCategories();
                  setState(() {});
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
    _categories = await _categoryRepository.getAll();
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

      if (_debounce?.isActive ?? false) _debounce!.cancel();
      _debounce = Timer(const Duration(milliseconds: 300), () async {
        await _updateSearchedExercises();
        setState(() {});
      });
    });
  }

  Future<void> _updateSearchedExercises() async {
    _exercisesSearched = await _exerciseRepository.getAllWithArgs(
        name: _searchController.text.trim());
  }

  Future<bool> _showConfirmDeletion(BuildContext context) async {
    return await showDialog(
            context: context,
            builder: (context) {
              return StatefulBuilder(
                builder: (context, setStateDialog) {
                  return AlertDialog(
                    title: const Text('Excluir conta'),
                    content: Text(
                        'Tem certeza que deseja excluir a conta ${fa.currentUser!.email}?'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context, false);
                        },
                        child: const Text('Não'),
                      ),
                      TextButton(
                        onPressed: () async {
                          _showLoadingDialog(context);
                          bool userDeleted = await deleteUser(context);
                          _hideLoadingDialog(context);
                          Navigator.pop(context, userDeleted);
                        },
                        child: const Text('Sim, excluir'),
                      ),
                    ],
                  );
                },
              );
            }) ??
        false;
  }

  @override
  void dispose() {
    _searchController.dispose();
    _debounce?.cancel();
    _focusNode.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final brightnessManager = BrightnessManager.of(context);

    return LoadingPresenter(
      isLoadingNotifier: isLoadingNotifier,
      // showLoadingAnimation: false,
      child: Scaffold(
        floatingActionButton: Builder(builder: (context) {
          return FloatingActionButton(
            onPressed: () {
              _addCategory(context);
            },
            child: const Icon(Icons.add),
          );
        }),
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
              constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * .4),
              child: TextButton.icon(
                icon: const Icon(Icons.account_circle_outlined),
                onPressed: () async {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: const Text('Conta'),
                          content: Text(
                              'Você está logado como ${fa.currentUser?.email.toString()}.'),
                          actions: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: const Text('Permanecer nesta conta'),
                                ),
                                TextButton(
                                  onPressed: () async {
                                    bool isSure = await showConfirmDialog(
                                      context,
                                      'Tem certeza que deseja desconectar desta conta?',
                                      confirm: 'Sim, desconectar',
                                    );
                                    if (!isSure) return;

                                    setLoading(true);
                                    await FirebaseUIAuth.signOut(
                                      context: context,
                                      auth: fa,
                                    );
                                    Navigator.pop(context);
                                    setLoading(false);
                                  },
                                  child: const Text('Desconectar'),
                                ),
                                TextButton(
                                  onPressed: () async {
                                    if (!hasInternetConnection) {
                                      showError(context,
                                          title: 'Não é possível fazer isso',
                                          content:
                                              'Aplicativo está em modo offline. '
                                              'Por favor, reconecte-se à internet, reinicie o aplicativo e tente novamente.');
                                      return;
                                    }

                                    bool isCheckingPassword = false;
                                    bool isPasswordWrong = false;

                                    final passwordController =
                                        TextEditingController();
                                    User currentUser = fa.currentUser!;

                                    bool usesEmailAndPassword = currentUser
                                        .providerData
                                        .any((provider) =>
                                            provider.providerId == 'password');

                                    bool usesGoogleSignIn = currentUser
                                        .providerData
                                        .any((provider) =>
                                            provider.providerId ==
                                            'google.com');

                                    final formKey = GlobalKey<FormState>();

                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        bool isCheckingPassword = false;

                                        return StatefulBuilder(
                                          builder: (context, setState) {
                                            return PopScope(
                                              canPop: !isCheckingPassword,
                                              child: AlertDialog(
                                                title: const Text(
                                                    'Exclusão desta conta'),
                                                content: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    const Text(
                                                        'Para excluir esta conta, você precisa verificar que é o dono dela.'),
                                                    if (usesEmailAndPassword)
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(top: 8),
                                                        child: Form(
                                                          key: formKey,
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .stretch,
                                                            children: [
                                                              TextFormField(
                                                                validator:
                                                                    (password) {
                                                                  if (password ==
                                                                          null ||
                                                                      password
                                                                          .isEmpty) {
                                                                    return 'A senha deve ser preenchida.';
                                                                  }

                                                                  if (isPasswordWrong) {
                                                                    return 'A senha está incorreta.';
                                                                  }

                                                                  return null;
                                                                },
                                                                controller:
                                                                    passwordController,
                                                                obscureText:
                                                                    true,
                                                                maxLength: 64,
                                                                decoration:
                                                                    const InputDecoration(
                                                                  counterText:
                                                                      '',
                                                                  labelText:
                                                                      'Senha desta conta',
                                                                ),
                                                              ),
                                                              const SizedBox(
                                                                  height: 12),
                                                              ElevatedButton(
                                                                onPressed:
                                                                    () async {
                                                                  if (isCheckingPassword) {
                                                                    return;
                                                                  }

                                                                  UserCredential?
                                                                      credential;
                                                                  try {
                                                                    setState(
                                                                        () {
                                                                      isCheckingPassword =
                                                                          true;
                                                                    });

                                                                    isPasswordWrong =
                                                                        false;
                                                                    if (!formKey
                                                                        .currentState!
                                                                        .validate()) {
                                                                      isCheckingPassword =
                                                                          false;
                                                                      return;
                                                                    }

                                                                    setLoading(
                                                                        true);

                                                                    credential =
                                                                        await fa
                                                                            .signInWithEmailAndPassword(
                                                                      email: currentUser
                                                                          .email!,
                                                                      password:
                                                                          passwordController
                                                                              .text,
                                                                    );
                                                                  } on FirebaseAuthException catch (e) {
                                                                    if (e.code ==
                                                                        'invalid-credential') {
                                                                      isPasswordWrong =
                                                                          true;

                                                                      formKey
                                                                          .currentState!
                                                                          .validate();
                                                                    } else if (e
                                                                            .code ==
                                                                        'network-request-failed') {
                                                                      showError(
                                                                        context,
                                                                        content:
                                                                            'Não foi possível estabelecer conexão com o servidor. '
                                                                            'Por favor, cheque sua conexão e tente novamente.',
                                                                      );
                                                                    }
                                                                  } finally {
                                                                    if (credential
                                                                            ?.user !=
                                                                        null) {
                                                                      bool
                                                                          userDeleted =
                                                                          await _showConfirmDeletion(
                                                                              context);

                                                                      if (userDeleted) {
                                                                        Navigator.pop(
                                                                            context);
                                                                        Navigator.pop(
                                                                            context);
                                                                      }
                                                                    }

                                                                    setState(
                                                                        () {
                                                                      isCheckingPassword =
                                                                          false;
                                                                    });

                                                                    if (context
                                                                        .mounted) {
                                                                      setLoading(
                                                                          false);
                                                                    }
                                                                  }
                                                                },
                                                                child: const Text(
                                                                    'Confirmar'),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    Visibility(
                                                      visible:
                                                          usesEmailAndPassword &&
                                                              usesGoogleSignIn,
                                                      replacement:
                                                          const SizedBox(
                                                              height: 16),
                                                      child: const Padding(
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                vertical: 16),
                                                        child: Row(
                                                          children: [
                                                            Expanded(
                                                                child: Divider(
                                                                    height: 0)),
                                                            SizedBox(width: 12),
                                                            Text('ou'),
                                                            SizedBox(width: 12),
                                                            Expanded(
                                                                child: Divider(
                                                                    height: 0)),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                    Visibility(
                                                      visible: usesGoogleSignIn,
                                                      child: OutlinedButton(
                                                        onPressed: () async {
                                                          if (isCheckingPassword) {
                                                            return;
                                                          }

                                                          setLoading(true);
                                                          await FirebaseUIAuth
                                                              .signOut(
                                                            context: context,
                                                            auth: fa,
                                                          );

                                                          var signIn =
                                                              await GoogleSignInService()
                                                                  .signIn(
                                                                      context);

                                                          Navigator.pop(
                                                              context);
                                                          Navigator.pop(
                                                              context);

                                                          if (!signIn.result &&
                                                              signIn.message
                                                                  .isNotEmpty) {
                                                            showError(context,
                                                                content: signIn
                                                                    .message);
                                                          } else if (fa
                                                                  .currentUser
                                                                  ?.uid ==
                                                              currentUser.uid) {
                                                            await _showConfirmDeletion(
                                                                context);
                                                          }

                                                          if (context.mounted) {
                                                            setLoading(false);
                                                          }
                                                        },
                                                        style: OutlinedButton.styleFrom(
                                                            padding:
                                                                const EdgeInsets
                                                                    .symmetric(
                                                                    vertical:
                                                                        6)),
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            SizedBox(
                                                              height: 36,
                                                              child: SvgPicture
                                                                  .asset(
                                                                'assets/google_logo.svg',
                                                                height: 36,
                                                                fit: BoxFit
                                                                    .fitHeight,
                                                              ),
                                                            ),
                                                            const Text(
                                                                'Entrar com Google'),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            );
                                          },
                                        );
                                      },
                                    );
                                  },
                                  child: const Text('Excluir esta conta'),
                                ),
                              ],
                            ),
                          ],
                        );
                      });
                },
                label: Text(
                  fa.currentUser?.email.toString() ?? '',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
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
            ValueListenableBuilder(
              valueListenable: hasInternetConnectionNotifier,
              builder: (context, hasInternetConnection, _) {
                return Visibility(
                  visible: !hasInternetConnection,
                  child: Container(
                    color: Colors.amber[100],
                    alignment: Alignment.center,
                    child: Text(
                      'Modo offline',
                      style: TextStyle(
                        color: brightnessManager.brightness == Brightness.dark
                            ? Theme.of(context).colorScheme.onInverseSurface
                            : Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                  ),
                );
              },
            ),
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
            Expanded(
              child: Visibility(
                visible: _searchController.text.isBlank,
                replacement: ListView.separated(
                  physics: const ClampingScrollPhysics(),
                  itemCount: _exercisesSearched.length,
                  itemBuilder: (context, index) {
                    Exercise exercise = _exercisesSearched[index];

                    // TODO(testar o onDelete)
                    return ExerciseCard(
                      exercise: exercise,
                      onAddLog: (log) async {
                        setLoading(true);
                        await LogRepository(exercise).add(log);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Log adicionado com sucesso!'),
                            duration: Duration(milliseconds: 2000),
                          ),
                        );
                        setLoading(false);
                      },
                      onDelete: () async {
                        // setLoading(true);
                        // await _exerciseRepository.delete(exercise);
                        // await _updateSearchedExercises();
                        // await Future.delayed(Duration(seconds: 5));
                        // setState(() {});
                        // setLoading(false);
                        setLoading(true);
                        await _exerciseRepository.delete(exercise);
                        await _updateSearchedExercises();
                        setLoading(false);
                        await Future.delayed(Duration(seconds: 5));
                        setState(() {});
                      },
                      showCategory: true,
                    );
                  },
                  separatorBuilder: (context, index) {
                    return const Divider(height: 0);
                  },
                ),
                child: Column(
                  children: [
                    Container(
                      alignment: Alignment.centerLeft,
                      padding: const EdgeInsets.only(
                          left: 12, right: 12, top: 16, bottom: 8),
                      child: Text('Categorias',
                          style: Theme.of(context).textTheme.titleLarge),
                    ),
                    Expanded(
                      child: StatefulBuilder(
                        builder: (context, setStateListView) {
                          if (_categories == null) {
                            return const SizedBox.shrink();
                          }

                          List<String> categories = _categories!;

                          if (categories.isEmpty) {
                            return const EmptyMessage(
                                'Você não possui categorias para selecionar.\nCrie uma em ( + )');
                          }

                          return ReorderableListView(
                            padding: const EdgeInsets.only(bottom: 80),
                            physics: const ClampingScrollPhysics(),
                            onReorder: (oldIndex, newIndex) async {
                              if (oldIndex < newIndex) {
                                newIndex -= 1;
                              }
                              final String category =
                                  categories.removeAt(oldIndex);
                              categories.insert(newIndex, category);

                              Map<String, int> orderedCategories = {};

                              for (int i = 0; i < categories.length; i++) {
                                orderedCategories[categories[i]] = i;
                              }

                              setStateListView(() {});
                              setLoading(true);
                              await _categoryRepository.updateOrder(
                                  orderedCategories: orderedCategories);
                              setLoading(false);
                            },
                            children: List.generate(categories.length, (index) {
                              String category = categories[index];

                              return Column(
                                key: UniqueKey(),
                                children: [
                                  ActionCard(
                                    onTap: () async {
                                      _focusNode = FocusNode();
                                      await Navigator.push(
                                        context,
                                        HorizontalRouter(
                                            child: ExercisesPage(
                                                category: categories[index])),
                                      );
                                    },
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(categories[index]),
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
                                                        bool isSure =
                                                            await showConfirmDialog(
                                                          context,
                                                          'Tem certeza que deseja excluir a categoria "$category"?',
                                                          content:
                                                              'Os logs dos exercícios desta categoria NÃO poderão ser recuperados.',
                                                          confirm:
                                                              'Sim, excluir',
                                                        );
                                                        if (isSure) {
                                                          setLoading(true);
                                                          await _categoryRepository
                                                              .delete(category);
                                                          await _updateCategories();
                                                          setStateListView(
                                                              () {});
                                                          setLoading(false);
                                                        }
                                                      },
                                                    );
                                                  },
                                                );
                                              },
                                              icon: const Icon(Icons.more_vert,
                                                  size: 24),
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
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void _showLoadingDialog(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return const PopScope(
        canPop: false,
        child: Center(child: CircularProgressIndicator()),
      );
    },
  );
}

void _hideLoadingDialog(BuildContext context) {
  Navigator.of(context, rootNavigator: true).pop();
}
