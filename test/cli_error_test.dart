import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:logging/logging.dart';
import '../bin/json_to_dart.dart';

void main() {
  group('Structured Logging & CLI Error Diagnostics Suite', () {
    final List<LogRecord> recordedLogs = [];

    setUpAll(() {
      Logger.root.level = Level.ALL;
      Logger.root.onRecord.listen((record) {
        recordedLogs.add(record);
      });
    });

    setUp(() {
      recordedLogs.clear();
    });

    test('runCli logs warning when input argument is missing', () {
      final err = StringBuffer();
      final exitCode = runCli(['-o', 'output.dart'], err: err);

      expect(exitCode, equals(1));
      expect(err.toString(), contains('Error: Missing required argument'));
      expect(recordedLogs.any((r) => r.level == Level.WARNING), isTrue);
    });

    test('runCli logs severe error when input file does not exist', () {
      final err = StringBuffer();
      final exitCode = runCli(['-i', 'ghost_file.json'], err: err);

      expect(exitCode, equals(1));
      expect(err.toString(), contains('does not exist'));
      expect(recordedLogs.any((r) => r.level == Level.SEVERE), isTrue);
    });

    test(
        'runCli captures invalid JSON syntax and logs structured SEVERE record',
        () {
      final tempDir = Directory.systemTemp.createTempSync('cli_err_test_');
      final brokenJson = File('${tempDir.path}/broken.json');
      brokenJson.writeAsStringSync('{invalid: json}');

      final err = StringBuffer();
      final exitCode = runCli(['-i', brokenJson.path], err: err);

      expect(exitCode, equals(1));
      expect(err.toString(), contains('Invalid JSON syntax'));

      final severeLog = recordedLogs.firstWhere((r) => r.level == Level.SEVERE);
      expect(severeLog.loggerName, equals('json_to_dart_cli'));
      expect(severeLog.error, isA<FormatException>());

      tempDir.deleteSync(recursive: true);
    });
  });
}
