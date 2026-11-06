import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:json_to_dart_tool/cli_error.dart';
import '../bin/json_to_dart.dart';

void main() {
  group('CliError Model Tests', () {
    test('CliError formats structured code and message correctly', () {
      const error = CliError('INVALID_JSON', 'Malformed payload');
      expect(error.code, 'INVALID_JSON');
      expect(error.message, 'Malformed payload');
      expect(error.toString(), '[INVALID_JSON] Malformed payload');
    });
  });

  group('CLI Error Code Integration Tests', () {
    test('runCli outputs [MISSING_ARG] when input flag is absent', () {
      final errBuffer = StringBuffer();
      final outBuffer = StringBuffer();

      final exitCode = runCli(['-o', 'out.dart'], out: outBuffer, err: errBuffer);

      expect(exitCode, 1);
      expect(errBuffer.toString(), contains('[MISSING_ARG]'));
    });

    test('runCli outputs [FILE_NOT_FOUND] when file does not exist', () {
      final errBuffer = StringBuffer();
      final outBuffer = StringBuffer();

      final exitCode = runCli(['-i', 'non_existing_file_9999.json'], out: outBuffer, err: errBuffer);

      expect(exitCode, 1);
      expect(errBuffer.toString(), contains('[FILE_NOT_FOUND]'));
    });

    test('runCli outputs [INVALID_JSON] when JSON payload is malformed', () {
      final tempFile = File('temp_malformed_test.json');
      tempFile.writeAsStringSync('{ invalid_json: ');

      final errBuffer = StringBuffer();
      final outBuffer = StringBuffer();

      try {
        final exitCode = runCli(['-i', tempFile.path], out: outBuffer, err: errBuffer);
        expect(exitCode, 1);
        expect(errBuffer.toString(), contains('[INVALID_JSON]'));
      } finally {
        if (tempFile.existsSync()) {
          tempFile.deleteSync();
        }
      }
    });

    test('runCli outputs [EMPTY_INPUT] when JSON file is completely empty', () {
      final tempFile = File('temp_empty_test.json');
      tempFile.writeAsStringSync('');

      final errBuffer = StringBuffer();
      final outBuffer = StringBuffer();

      try {
        final exitCode = runCli(['-i', tempFile.path], out: outBuffer, err: errBuffer);
        expect(exitCode, 1);
        expect(errBuffer.toString(), contains('[EMPTY_INPUT]'));
      } finally {
        if (tempFile.existsSync()) {
          tempFile.deleteSync();
        }
      }
    });
  });
}
