import 'package:flutter/material.dart';
import 'package:gym_log/entities/log.dart';
import 'package:gym_log/utils/extensions.dart';
import 'package:gym_log/utils/show_error.dart';
import 'package:flutter/services.dart';
import 'package:flutter/cupertino.dart';

import '../entities/exercise.dart';
import '../repositories/log_repository.dart';

Future<void> showAddLog(
  BuildContext context, {
  required void Function(double weight, int reps, DateTime date, String notes) onConfirm,
  required Exercise exercise,
}) async {
  Log? lastLogFromExercise = await LogRepository(exercise).getLast();

  await showLogDialog(
    // ignore: use_build_context_synchronously
    context,
    title: 'Adicionar log',
    log: lastLogFromExercise?.copyWith(date: DateTime.now(), notes: ''),
    onConfirm: onConfirm,
  );
}

Future<void> showLogDialog(
  BuildContext context, {
  required String title,
  required Log? log,
  required void Function(double weight, int reps, DateTime date, String notes) onConfirm,
}) async {
  var notesController = TextEditingController(text: log?.notes);

  var dateNow = DateTime.now();
  var dateController = TextEditingController(text: log?.date.formatReadable());
  DateTime selectedDate = log?.date ?? dateNow;

  var weightController = TextEditingController(text: log?.weight.toString());
  var repsController = TextEditingController(text: log?.reps.toString());

  await showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(title),
        insetPadding: const EdgeInsets.all(16),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: dateController,
              decoration: const InputDecoration(labelText: 'Data'),
              onTap: () async {
                DateTime? pickedDate = await showDatePicker(
                  initialDate: selectedDate,
                  context: context,
                  firstDate: DateTime(2000),
                  lastDate: dateNow,
                );

                if (pickedDate == null) return;
                selectedDate = pickedDate;
                dateController.text = selectedDate.formatReadable();
              },
              readOnly: true,
              inputFormatters: const [],
            ),
            TextField(
              controller: weightController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true, signed: false),
              inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^[0-9]+.?[0-9]*'))],
              decoration: InputDecoration(
                labelText: 'Peso (kg)',
                suffix: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      onPressed: () {
                        double weight = double.tryParse(weightController.text) ?? 0;
                        weight++;
                        weightController.text = weight.toString();
                      },
                      icon: const Icon(Icons.add),
                      padding: EdgeInsets.zero,
                    ),
                    IconButton(
                      onPressed: () {
                        double weight = double.tryParse(weightController.text) ?? 0;
                        if (weight < 1) return;

                        weight--;
                        weightController.text = weight.toString();
                      },
                      icon: const Icon(Icons.remove),
                      padding: EdgeInsets.zero,
                    ),
                  ],
                ),
              ),
            ),
            TextField(
              controller: repsController,
              decoration: InputDecoration(
                labelText: 'Repetições',
                suffix: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      onPressed: () {
                        int reps = int.tryParse(repsController.text) ?? 0;
                        reps++;
                        repsController.text = reps.toString();
                      },
                      icon: const Icon(Icons.add),
                      padding: EdgeInsets.zero,
                    ),
                    IconButton(
                      onPressed: () {
                        int reps = int.tryParse(repsController.text) ?? 0;
                        if (reps < 1) return;
                        reps--;

                        repsController.text = reps.toString();
                      },
                      icon: const Icon(Icons.remove),
                      padding: EdgeInsets.zero,
                    ),
                  ],
                ),
              ),
              keyboardType: const TextInputType.numberWithOptions(),
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            ),
            TextField(
              keyboardType: TextInputType.multiline,
              maxLines: null,
              controller: notesController,
              decoration: const InputDecoration(labelText: 'Notas'),
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () async {
              if (weightController.text.isEmpty || repsController.text.isEmpty) {
                showError(context, content: 'Os campos "Peso (kg)" e "Repetições" devem estar preenchidos.');
                return;
              }

              double weight = double.parse(weightController.text);
              int reps = int.parse(repsController.text);

              onConfirm(weight, reps, selectedDate, notesController.text);

              Navigator.pop(context);
            },
            child: const Text('Ok'),
          ),
        ],
      );
    },
  );
}
