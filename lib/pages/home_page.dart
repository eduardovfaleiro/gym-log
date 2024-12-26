import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:gym_log/utils/extensions.dart';
import 'package:gym_log/utils/show_confirm_dialog.dart';
import 'package:gym_log/widgets/popup_buton.dart';

import '../entities/exercise.dart';
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

class _HomePageState extends State<HomePage> {
  final List<String> _categories = ['Pernas', 'Peito', 'Costas', 'Ombro', 'Bíceps', 'Tríceps', 'Antebraço', 'Abdômen'];
  List<Exercise> _exercisesSearched = [];

  final _searchController = TextEditingController();
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();

    _focusNode = FocusNode();

    _searchController.addListener(() async {
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

    return Scaffold(
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
                                auth: FirebaseAuth.instance,
                              );
                              // ignore: use_build_context_synchronously
                              Navigator.pop(context);
                            },
                          );
                        },
                      );
                    },
                    label: Text(
                      FirebaseAuth.instance.currentUser?.email.toString() ?? '',
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
                  );
                },
                separatorBuilder: (context, index) {
                  return const Divider(height: 0);
                },
              ),
              child: ListView.separated(
                physics: const ClampingScrollPhysics(),
                itemCount: _categories.length,
                separatorBuilder: (context, index) {
                  return const Divider(height: 0);
                },
                itemBuilder: (context, index) {
                  return ListTile(
                    onTap: () async {
                      await Navigator.push(
                        context,
                        HorizontalRouter(child: ExercisesPage(category: _categories[index])),
                      );
                      _focusNode = FocusNode();
                    },
                    visualDensity: VisualDensity.comfortable,
                    title: Text(_categories[index]),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 12),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
