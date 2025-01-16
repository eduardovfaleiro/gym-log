import 'package:gym_log/main.dart';
import 'package:gym_log/utils/exceptions.dart';
import 'package:gym_log/utils/extensions.dart';

import '../entities/log.dart';

class SheetService {
  void validateLogFromCell({required Log log, required int row}) {
    if (log.weight > kMaxWeight) {
      throw SheetValueException(
        column: 'A',
        row: row,
        message: 'O peso com valor "${log.weight}" é inválido: '
            'um peso não pode exceder $kMaxLengthWeight dígitos.',
      );
    } else if (log.weight <= 0) {
      throw SheetValueException(
        column: 'A',
        row: row,
        message: 'O peso com valor "${log.weight}" é inválido: '
            'um peso não pode ser igual ou menor a 0.',
      );
    }

    if (log.reps > kMaxReps) {
      throw SheetValueException(
        column: 'B',
        row: row,
        message: 'As repetições com valor "${log.reps}" são inválidas: '
            'repetições não exceder $kMaxLengthReps dígitos.',
      );
    } else if (log.reps < 1) {
      throw SheetValueException(
        column: 'B',
        row: row,
        message: 'As repetições com valor "${log.reps}" são inválidas: '
            'repetições não podem ser menores que 1.',
      );
    }
    if (log.date.isAfter(DateTime.now())) {
      throw SheetValueException(
        column: 'C',
        row: row,
        message: 'A data com valor "${log.date.formatReadable()}" é inválida: '
            'a data não pode ser posterior ao dia atual.',
      );
    }
    if (log.notes.length > kMaxLengthNotes) {
      throw SheetValueException(
        column: 'D',
        row: row,
        message: 'As notas com valor "${log.notes.substring(0, 25)}" são inválidas: '
            'as notas não podem exceder $kMaxLengthNotes caracteres.',
      );
    }
  }
}
