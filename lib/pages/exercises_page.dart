import 'package:flutter/material.dart';

import '../repositories/exercise_repository.dart';
import 'exercise_chart_page.dart';

class ExercisesPage extends StatefulWidget {
  final String section;

  const ExercisesPage({super.key, required this.section});

  @override
  State<ExercisesPage> createState() => _ExercisesPageState();
}

class _ExercisesPageState extends State<ExercisesPage> {
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
              onPressed: () {
                ExerciseRepository.add(exerciseController.text, section: widget.section);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () async {
          await _addExercise(context);
        },
      ),
      appBar: AppBar(
        title: Text(widget.section),
      ),
      body: FutureBuilder(
        future: ExerciseRepository().getAllFromSection(widget.section),
        builder: (context, snapshot) {
          var exercises = snapshot.data;

          return Visibility(
            visible: snapshot.connectionState != ConnectionState.waiting,
            replacement: const SizedBox.shrink(),
            child: ListView.separated(
              physics: const ClampingScrollPhysics(),
              itemCount: exercises?.length ?? 0,
              separatorBuilder: (context, index) {
                return const Divider(height: 0);
              },
              itemBuilder: (context, index) {
                return ListTile(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ExerciseChart(title: exercises[index].name),
                      ),
                    );
                  },
                  visualDensity: VisualDensity.comfortable,
                  title: Text(exercises![index].name),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 12),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
