class JsonParser {
  static String generateDartClass(String className, Map<String, dynamic> json) {
    StringBuffer buffer = StringBuffer();
    Set<String> generatedClasses = {};
    _generateRecursive(_toPascalCase(className), json, buffer, generatedClasses);
    return buffer.toString();
  }

  static void _generateRecursive(String className, Map<String, dynamic> json, StringBuffer buffer, Set<String> generatedClasses) {
    if (generatedClasses.contains(className)) return;
    generatedClasses.add(className);

    Map<String, String> subClassesToGenerate = {};

    buffer.writeln('class $className {');

    // Fields
    json.forEach((key, value) {
      String type = _getDartType(key, value);
      buffer.writeln('  final $type? ${_toCamelCase(key)};');
    });

    // Constructor
    buffer.writeln('\n  $className({');
    json.forEach((key, _) {
      buffer.writeln('    this.${_toCamelCase(key)},');
    });
    buffer.writeln('  });');

    // fromJson
    buffer.writeln('\n  factory $className.fromJson(Map<String, dynamic> json) => $className(');
    json.forEach((key, value) {
      String fieldName = _toCamelCase(key);
      if (value is Map<String, dynamic>) {
        String subClassName = _toPascalCase(key);
        buffer.writeln('    $fieldName: json["$key"] == null ? null : $subClassName.fromJson(json["$key"]),');
        subClassesToGenerate[key] = subClassName;
      } else if (value is List) {
        if (value.isNotEmpty && value[0] is Map<String, dynamic>) {
          String subClassName = _toPascalCase(key);
          buffer.writeln('    $fieldName: json["$key"] == null ? null : List<$subClassName>.from(json["$key"].map((x) => $subClassName.fromJson(x))),');
          subClassesToGenerate[key] = subClassName;
        } else {
          String innerType = value.isEmpty ? 'dynamic' : _getDartType(key, value[0]);
          buffer.writeln('    $fieldName: json["$key"] == null ? null : List<$innerType>.from(json["$key"].map((x) => x)),');
        }
      } else {
        buffer.writeln('    $fieldName: json["$key"],');
      }
    });
    buffer.writeln('  );');

    // toJson
    buffer.writeln('\n  Map<String, dynamic> toJson() => {');
    json.forEach((key, value) {
      String fieldName = _toCamelCase(key);
      if (value is Map<String, dynamic>) {
        buffer.writeln('    "$key": $fieldName?.toJson(),');
      } else if (value is List) {
        if (value.isNotEmpty && value[0] is Map<String, dynamic>) {
          buffer.writeln('    "$key": $fieldName?.map((i) => i.toJson()).toList(),');
        } else {
          buffer.writeln('    "$key": $fieldName,');
        }
      } else {
        buffer.writeln('    "$key": $fieldName,');
      }
    });
    buffer.writeln('  };');

    buffer.writeln('}\n');

    // Generate nested classes
    subClassesToGenerate.forEach((key, subClassName) {
      dynamic value = json[key];
      if (value is Map<String, dynamic>) {
        _generateRecursive(subClassName, value, buffer, generatedClasses);
      } else if (value is List && value.isNotEmpty && value[0] is Map<String, dynamic>) {
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
