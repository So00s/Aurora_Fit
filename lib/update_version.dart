import 'dart:io';

void main() {
  const specFilePath = '/home/loodsman/aurora_fit/aurora/rpm/ru.aurora.aurora_fit.spec'; // Укажите путь к вашему spec-файлу

  final specFile = File(specFilePath);

  if (!specFile.existsSync()) {
    print('Error: Spec file not found at $specFilePath');
    exit(1);
  }

  final lines = specFile.readAsLinesSync();
  final updatedLines = lines.map((line) {
    if (line.startsWith('Version:')) {
      final version = line.split(':')[1].trim();
      final parts = version.split('.');
      parts[3] = (int.parse(parts[3]) + 1).toString(); // Увеличиваем последнюю цифру версии
      final newVersion = parts.join('.');
      print('Version updated: $version -> $newVersion');
      return 'Version: $newVersion';
    }
    return line;
  }).toList();
  
  updatedLines.add('');

  specFile.writeAsStringSync(updatedLines.join('\n'));
  print('Spec file updated successfully!');
}