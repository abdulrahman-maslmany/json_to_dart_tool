import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import '../bin/json_to_dart.dart';

void main() {
  group('CLI Tool Fast In-Memory Tests', () {
    test('CLI prints help message with --help flag', () {
      final out = StringBuffer();
      final exitCode = runCli(['--help'], out: out);

      expect(exitCode, equals(0));
      expect(out.toString(), contains('JSON to Dart CLI Tool'));
      expect(out.toString(), contains('Usage:'));
    });

    test('CLI fails with exit code 1 when -i is missing', () {
      final err = StringBuffer();
      final exitCode = runCli(['-c', 'CustomModel'], err: err);

      expect(exitCode, equals(1));
      expect(err.toString(), contains('Error: Missing required argument'));
    });

    test('CLI fails when input file does not exist', () {
      final err = StringBuffer();
      final exitCode = runCli(['-i', 'non_existent_file.json'], err: err);

      expect(exitCode, equals(1));
      expect(err.toString(), contains('does not exist'));
    });

    test('CLI successfully converts valid JSON and writes output file', () {
      final tempDir = Directory.systemTemp.createTempSync('json_test_');
      final sampleJson = File('${tempDir.path}/sample.json');
      final outputDart = File('${tempDir.path}/output.dart');

      sampleJson.writeAsStringSync('{"name": "FlutterDev", "age": 25}');

      final out = StringBuffer();
      final exitCode = runCli([
        '-i',
        sampleJson.path,
        '-o',
        outputDart.path,
        '--class',
        'ProfileModel',
      ], out: out);

      expect(exitCode, equals(0));
      expect(outputDart.existsSync(), isTrue);
      final generatedCode = outputDart.readAsStringSync();
      expect(generatedCode, contains('class ProfileModel'));
      expect(generatedCode, contains('name'));

      tempDir.deleteSync(recursive: true);
    });
  });
}
