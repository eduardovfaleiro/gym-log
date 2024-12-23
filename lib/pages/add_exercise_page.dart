// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:gym_log/widgets/loading_manager.dart';

import '../entities/exercise.dart';
import '../repositories/exercise_repository.dart';
import '../repositories/exercise_selection_repository.dart';

class AddExercisePage extends StatefulWidget {
  final String section;

  const AddExercisePage({super.key, required this.section});

  @override
  State<AddExercisePage> createState() => _AddExercisePageState();
}

class _AddExercisePageState extends State<AddExercisePage> {
  Future<void> _addExercise(BuildContext context) async {
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
                await ExerciseSelectionRepository().add(
                  Exercise(name: exerciseController.text, section: widget.section),
                );
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

  List<String> _exercises = [];

  @override
  void initState() {
    super.initState();

    ExerciseSelectionRepository().getFromSection(widget.section).then((exercises) {
      setState(() {
        _exercises = exercises;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return LoadingManager(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Adicionar exercício'),
        ),
        floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: () async {
            await _addExercise(context);
          },
        ),
        body: ListView.separated(
          physics: const ClampingScrollPhysics(),
          itemCount: _exercises.length,
          separatorBuilder: (context, index) => const Divider(height: 0),
          itemBuilder: (context, index) {
            String exercise = _exercises[index];

            return RadioListTile(
              title: Text(exercise),
              value: exercise.toLowerCase(),
              groupValue: _selectedExercise,
              onChanged: (value) {
                setState(() {
                  _selectedExercise = value!;
                  _selectedExerciseName = exercise;
                });
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
                  onPressed: () {
                    LoadingManager.run(() async {
                      await ExerciseRepository.add(Exercise(name: _selectedExerciseName, section: widget.section));
                      Navigator.pop(context);
                    });
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
