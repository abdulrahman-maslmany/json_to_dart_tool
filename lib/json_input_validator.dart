import 'dart:convert';

/// نتيجة التحقق من صحة مدخلات الـ JSON
class JsonValidationResult {
  final bool isValid;
  final dynamic parsedData;
  final String? errorMessage;

  const JsonValidationResult.success(this.parsedData)
    : isValid = true,
      errorMessage = null;

  const JsonValidationResult.failure(this.errorMessage)
    : isValid = false,
      parsedData = null;
}

class JsonInputValidator {
  /// التحقق الصارم من صحة النص كـ JSON صالح
  static JsonValidationResult validate(String rawInput) {
    if (rawInput.trim().isEmpty) {
      return const JsonValidationResult.failure('Input cannot be empty');
    }

    try {
      final dynamic decoded = jsonDecode(rawInput);
      if (decoded is! Map<String, dynamic> && decoded is! List) {
        return const JsonValidationResult.failure(
          'JSON must be an object or an array',
        );
      }
      return JsonValidationResult.success(decoded);
    } catch (e) {
      return JsonValidationResult.failure(
        'Malformed JSON format: ${e.toString()}',
      );
    }
  }
}
