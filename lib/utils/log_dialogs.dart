import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gym_log/entities/log.dart';
import 'package:gym_log/main.dart';
import 'package:gym_log/utils/extensions.dart';

import '../entities/exercise.dart';
import '../repositories/log_repository.dart';

class IntInputFormatter extends TextInputFormatter {
  final int maxLength;
  late final RegExp _regex;
  late final int _maxValue;

  IntInputFormatter({required this.maxLength}) {
    _regex = RegExp(r'[0-9]{1,' + maxLength.toString() + r'}');
    _maxValue = int.parse('9' * maxLength);
  }

  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.isEmpty) {
      return newValue;
    }

    if (_regex.hasMatch(newValue.text)) {
      final int? value = int.tryParse(newValue.text);
      if (value != null && value <= _maxValue) {
        return newValue;
      }
    }

    return oldValue; // Reject the change if it doesn't match the pattern or exceeds the range.
  }
}

class DoubleInputFormatter extends TextInputFormatter {
  late final RegExp _regex;
  final int maxLength;
  late final double _maxValue;

  DoubleInputFormatter({required this.maxLength}) {
    _regex = RegExp(r'^(?:[0-9]{1,' + maxLength.toString() + r'}|0)(?:\.[0-9]{0,2})?$');
    _maxValue = int.parse('9' * maxLength) + .99;
  }

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.isEmpty) {
      return newValue;
    }

    if (_regex.hasMatch(newValue.text)) {
      final double? value = double.tryParse(newValue.text);
      if (value != null && value <= _maxValue) {
        return newValue;
      }
    }

    return oldValue; // Reject the change if it doesn't match the pattern or exceeds the range.
  }
}

Future<void> showAddLog(
  BuildContext context, {
  required void Function(Log log) onConfirm,
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
  required void Function(Log log) onConfirm,
}) async {
  var notesController = TextEditingController(text: log?.notes);

  var dateNow = DateTime.now();
  var dateController = TextEditingController(text: log?.date.formatReadable() ?? dateNow.formatReadable());
  DateTime selectedDate = log?.date ?? dateNow;

  var weightController = TextEditingController(text: log?.weight.toString());
  var repsController = TextEditingController(text: log?.reps.toString());

  final formKey = GlobalKey<FormState>();

  await showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(title),
        insetPadding: const EdgeInsets.all(16),
        content: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Form(
            key: formKey,
            child: Column(
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
                const SizedBox(height: 8),
                TextFormField(
                  validator: (weight) {
                    if (weight!.isEmpty) return 'O peso deve ser preenchido.';
                    if (double.parse(weight) <= 0) return 'O peso deve ser maior que 0.';

                    return null;
                  },
                  controller: weightController,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true, signed: false),
                  inputFormatters: [DoubleInputFormatter(maxLength: kMaxLengthWeight)],
                  decoration: InputDecoration(
                    labelText: 'Peso (kg)',
                    suffix: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          onPressed: () {
                            double weight = double.tryParse(weightController.text) ?? 0;
                            if (weight >= kMaxWeight - 1) return;

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
                const SizedBox(height: 8),
                TextFormField(
                  validator: (reps) {
                    if (reps!.isEmpty) return 'As repetições devem ser preenchidas.';
                    if (int.parse(reps) <= 0) return 'As repetições devem ser maiores que 0.';

                    return null;
                  },
                  controller: repsController,
                  decoration: InputDecoration(
                    labelText: 'Repetições',
                    suffix: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          onPressed: () {
                            int reps = int.tryParse(repsController.text) ?? 0;
                            if (reps >= kMaxReps - 1) return;

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
                  inputFormatters: [IntInputFormatter(maxLength: kMaxLengthReps)],
                ),
                const SizedBox(height: 8),
                Flexible(
                  child: TextField(
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    controller: notesController,
                    decoration: const InputDecoration(labelText: 'Notas'),
                    maxLength: kMaxLengthNotes,
                  ),
                ),
              ],
            ),
          ),
        ),
        actions: [
          ElevatedButton(
            onPressed: () async {
              bool isValid = formKey.currentState!.validate();
              if (!isValid) return;

              double weight = double.parse(weightController.text);
              int reps = int.parse(repsController.text);

              onConfirm(Log(weight: weight, reps: reps, date: selectedDate, notes: notesController.text));

              Navigator.pop(context);
            },
            child: const Text('Ok'),
          ),
        ],
      );
    },
  );
}
