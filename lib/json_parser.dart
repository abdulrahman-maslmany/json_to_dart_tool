class JsonParser {
  // 1. Standard Dart Class
  static String generateDartClass(String className, Map<String, dynamic> json) {
    StringBuffer buffer = StringBuffer();
    Set<String> generatedClasses = {};
    _generateRecursive(
      _toPascalCase(className),
      json,
      buffer,
      generatedClasses,
    );
    return buffer.toString();
  }

  // 2. Freezed Pro Model
  static String generateFreezedClass(String className, Map<String, dynamic> json, {String fileName = 'model'}) {
    StringBuffer buffer = StringBuffer();
    Set<String> generatedClasses = {};

    buffer.writeln("import 'package:freezed_annotation/freezed_annotation.dart';\n");
    buffer.writeln("part '$fileName.freezed.dart';");
    buffer.writeln("part '$fileName.g.dart';\n");

    _generateFreezedRecursive(
      _toPascalCase(className),
      json,
      buffer,
      generatedClasses,
    );

    return buffer.toString();
  }

  // 3. Mock Data Generator 🧪
  static String generateMockData(String className, Map<String, dynamic> json) {
    StringBuffer buffer = StringBuffer();
    String rootClass = _toPascalCase(className);
    String varName = 'mock${_toPascalCase(className)}';

    buffer.writeln('// Generated Mock Data for Testing & UI Prototyping');
    buffer.writeln('final $varName = ${_buildMockInstance(rootClass, json, 0)};\n');
    return buffer.toString();
  }

  static String _buildMockInstance(String className, Map<String, dynamic> json, int indentLevel) {
    String indent = '  ' * indentLevel;
    String childIndent = '  ' * (indentLevel + 1);
    StringBuffer sb = StringBuffer();

    sb.writeln('$className(');
    json.forEach((key, value) {
      String fieldName = _toCamelCase(key);
      String formattedValue = _formatMockValue(key, value, indentLevel + 1);
      sb.writeln('$childIndent$fieldName: $formattedValue,');
    });
    sb.write('$indent)');
    return sb.toString();
  }

  static String _formatMockValue(String key, dynamic value, int indentLevel) {
    String indent = '  ' * indentLevel;
    if (value == null) return 'null';
    if (value is String) return '"$value"';
    if (value is int || value is double || value is bool) return '$value';
    if (value is Map<String, dynamic>) {
      return _buildMockInstance(_toPascalCase(key), value, indentLevel);
    }
    if (value is List) {
      if (value.isEmpty) return '[]';
      if (value[0] is Map<String, dynamic>) {
        String subClass = _toPascalCase(key);
        var items = value
            .map((item) => '$indent  ${_buildMockInstance(subClass, item as Map<String, dynamic>, indentLevel + 1)}')
            .join(',\n');
        return '[\n$items,\n$indent]';
      }
      return '[' + value.map((e) => e is String ? '"$e"' : '$e').join(', ') + ']';
    }
    return 'null';
  }

  static void _generateFreezedRecursive(
    String className,
    Map<String, dynamic> json,
    StringBuffer buffer,
    Set<String> generatedClasses,
  ) {
    if (generatedClasses.contains(className)) return;
    generatedClasses.add(className);

    Map<String, String> subClassesToGenerate = {};

    buffer.writeln('@freezed');
    buffer.writeln('class $className with _\$$className {');
    buffer.writeln('  const factory $className({');

    json.forEach((key, value) {
      String fieldName = _toCamelCase(key);
      String type = _getDartType(key, value);

      if (key != fieldName) {
        buffer.writeln("    @JsonKey(name: '$key') $type? $fieldName,");
      } else {
        buffer.writeln('    $type? $fieldName,');
      }

      if (value is Map<String, dynamic>) {
        subClassesToGenerate[key] = _toPascalCase(key);
      } else if (value is List && value.isNotEmpty && value[0] is Map<String, dynamic>) {
        subClassesToGenerate[key] = _toPascalCase(key);
      }
    });

    buffer.writeln('  }) = _$className;\n');
    buffer.writeln('  factory $className.fromJson(Map<String, dynamic> json) =>');
    buffer.writeln('      _\$${className}FromJson(json);');
    buffer.writeln('}\n');

    subClassesToGenerate.forEach((key, subClassName) {
      dynamic value = json[key];
      if (value is Map<String, dynamic>) {
        _generateFreezedRecursive(subClassName, value, buffer, generatedClasses);
      } else if (value is List && value.isNotEmpty && value[0] is Map<String, dynamic>) {
        _generateFreezedRecursive(subClassName, value[0], buffer, generatedClasses);
      }
    });
  }

  static void _generateRecursive(
    String className,
    Map<String, dynamic> json,
    StringBuffer buffer,
    Set<String> generatedClasses,
  ) {
    if (generatedClasses.contains(className)) return;
    generatedClasses.add(className);

    Map<String, String> subClassesToGenerate = {};

    buffer.writeln('class $className {');

    json.forEach((key, value) {
      String type = _getDartType(key, value);
      buffer.writeln('  final $type? ${_toCamelCase(key)};');
    });

    buffer.writeln('\n  $className({');
    json.forEach((key, _) {
      buffer.writeln('    this.${_toCamelCase(key)},');
    });
    buffer.writeln('  });');

    buffer.writeln(
      '\n  factory $className.fromJson(Map<String, dynamic> json) => $className(',
    );
    json.forEach((key, value) {
      String fieldName = _toCamelCase(key);
      if (value is Map<String, dynamic>) {
        String subClassName = _toPascalCase(key);
        buffer.writeln(
          '    $fieldName: json["$key"] == null ? null : $subClassName.fromJson(json["$key"]),',
        );
        subClassesToGenerate[key] = subClassName;
      } else if (value is List) {
        if (value.isNotEmpty && value[0] is Map<String, dynamic>) {
          String subClassName = _toPascalCase(key);
          buffer.writeln(
            '    $fieldName: json["$key"] == null ? null : List<$subClassName>.from(json["$key"].map((x) => $subClassName.fromJson(x))),',
          );
          subClassesToGenerate[key] = subClassName;
        } else {
          String innerType =
              value.isEmpty ? 'dynamic' : _getDartType(key, value[0]);
          buffer.writeln(
            '    $fieldName: json["$key"] == null ? null : List<$innerType>.from(json["$key"].map((x) => x)),',
          );
        }
      } else {
        buffer.writeln('    $fieldName: json["$key"],');
      }
    });
    buffer.writeln('  );');

    buffer.writeln('\n  Map<String, dynamic> toJson() => {');
    json.forEach((key, value) {
      String fieldName = _toCamelCase(key);
      if (value is Map<String, dynamic>) {
        buffer.writeln('    "$key": $fieldName?.toJson(),');
      } else if (value is List) {
        if (value.isNotEmpty && value[0] is Map<String, dynamic>) {
          buffer.writeln(
            '    "$key": $fieldName?.map((i) => i.toJson()).toList(),',
          );
        } else {
          buffer.writeln('    "$key": $fieldName,');
        }
      } else {
        buffer.writeln('    "$key": $fieldName,');
      }
    });
    buffer.writeln('  };');

    buffer.writeln('}\n');

    subClassesToGenerate.forEach((key, subClassName) {
      dynamic value = json[key];
      if (value is Map<String, dynamic>) {
        _generateRecursive(subClassName, value, buffer, generatedClasses);
      } else if (value is List &&
          value.isNotEmpty &&
          value[0] is Map<String, dynamic>) {
        _generateRecursive(subClassName, value[0], buffer, generatedClasses);
      }
    });
  }

  static String _getDartType(String key, dynamic value) {
    if (value is int) return 'int';
    if (value is double) return 'double';
    if (value is String) return 'String';
    if (value is bool) return 'bool';
    if (value is Map<String, dynamic>) return _toPascalCase(key);
    if (value is List) {
      if (value.isEmpty) return 'List<dynamic>';
      return 'List<${_getDartType(key, value[0])}>';
    }
    return 'dynamic';
  }

  static String _capitalize(String s) {
    if (s.isEmpty) return s;
    return s[0].toUpperCase() + s.substring(1);
  }

  static String _toPascalCase(String s) {
    return s.split(RegExp(r'(_| )')).map(_capitalize).join('');
  }

  static String _toCamelCase(String s) {
    String pascal = _toPascalCase(s);
    return pascal[0].toLowerCase() + pascal.substring(1);
  }
}