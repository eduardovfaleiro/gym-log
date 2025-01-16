class SheetValueException<T> {
  final String column;
  final int row;
  final String message;

  SheetValueException({required this.column, required this.row, required this.message});
}
