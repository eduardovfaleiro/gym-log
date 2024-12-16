import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gym_log/repositories/exercise_repository.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'utils/init.dart';

class MainController {
  Future<List<String>> getExercises() {
    return ExerciseRepository.getAll();
  }

  Future<void> addExercise(BuildContext context) async {
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
                onPressed: () {
                  ExerciseRepository.add(exerciseController.text);
                  Navigator.pop(context);
                },
                child: const Text('Ok')),
          ],
        );
      },
    );
  }
}
