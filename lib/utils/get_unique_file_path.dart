import 'dart:io';

Future<String> getUniqueFilePath({
  required String directory,
  required String baseName,
  required String extension,
}) async {
  // Gera o caminho inicial sem contador.
  String filePath = '$directory/$baseName.$extension';
  int counter = 1;

  // Enquanto o arquivo existir, adiciona o contador no nome.
  while (await File(filePath).exists()) {
    filePath = '$directory/$baseName ($counter).$extension';
    counter++;
  }

  return filePath;
}
