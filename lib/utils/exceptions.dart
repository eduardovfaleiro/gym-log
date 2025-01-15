enum ExcelValueTypeError {
  weight,
  reps,
  date,
  notes,
}

extension ExcelValueTypeErrorExtension on ExcelValueTypeError {
  String toReadableString() {
    switch (this) {
      case ExcelValueTypeError.weight:
        return 'Peso';

      case ExcelValueTypeError.reps:
        return 'Repetições';
      case ExcelValueTypeError.date:
        return 'Data';
      case ExcelValueTypeError.notes:
        return 'Notas';
    }
  }
}

class ExcelValueException<T> {
  final String column;
  final int row;
  final ExcelValueTypeError type;
  final T value;

  ExcelValueException({required this.column, required this.row, required this.type, required this.value});
}
