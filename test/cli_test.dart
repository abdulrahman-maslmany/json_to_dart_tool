import 'dart:io';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('CLI Tool Integration Tests', () {
    final cliPath = 'bin/json_to_dart.dart';
    // مسار محرك Dart الحقيقي المتوافق مع Windows و Linux
    final dartExecutable = Platform.resolvedExecutable;

    test('CLI prints help message with --help flag', () async {
      final result = await Process.run(
        dartExecutable,
        ['run', cliPath, '--help'],
        runInShell: Platform.isWindows,
      );
      expect(result.exitCode, equals(0));
      expect(result.stdout.toString(), contains('JSON to Dart CLI Tool'));
      expect(result.stdout.toString(), contains('Usage:'));
    });

    test('CLI fails with exit code 1 when -i is missing', () async {
      final result = await Process.run(
        dartExecutable,
        ['run', cliPath],
        runInShell: Platform.isWindows,
      );
      expect(result.exitCode, equals(1));
      expect(result.stderr.toString(),
          contains('Error: Missing required argument'));
    });

    test('CLI fails when input file does not exist', () async {
      final result = await Process.run(
        dartExecutable,
        ['run', cliPath, '-i', 'non_existent_file.json'],
        runInShell: Platform.isWindows,
      );
      expect(result.exitCode, equals(1));
      expect(result.stderr.toString(), contains('does not exist'));
    });

    test('CLI successfully converts valid JSON and writes output file',
        () async {
      final tempDir = Directory.systemTemp.createTempSync('json_test_');
      final sampleJson = File('${tempDir.path}/sample.json');
      final outputDart = File('${tempDir.path}/output.dart');

      sampleJson.writeAsStringSync('{"name": "FlutterDev", "age": 25}');

      final result = await Process.run(
        dartExecutable,
        [
          'run',
          cliPath,
          '-i',
          sampleJson.path,
          '-o',
          outputDart.path,
          '--class',
          'ProfileModel'
        ],
        runInShell: Platform.isWindows,
      );

      expect(result.exitCode, equals(0));
      expect(outputDart.existsSync(), isTrue);
      final generatedCode = outputDart.readAsStringSync();
      expect(generatedCode, contains('class ProfileModel'));
      expect(generatedCode, contains('name'));

      tempDir.deleteSync(recursive: true);
    });
  });
}
