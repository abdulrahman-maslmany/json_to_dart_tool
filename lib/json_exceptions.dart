/// استثناءات وفحص أمني صارم لمدخلات الـ JSON
class JsonParseException implements Exception {
  final String message;
  final dynamic details;

  const JsonParseException(this.message, [this.details]);

  @override
  String toString() =>
      'JsonParseException: $message ${details != null ? "($details)" : ""}';
}

class EmptyInputException extends JsonParseException {
  const EmptyInputException()
      : super('JSON payload cannot be empty or whitespace only.');
}

class OversizedInputException extends JsonParseException {
  const OversizedInputException(int size, int limit)
      : super(
          'Payload size ($size characters) exceeds safe limit ($limit characters).',
        );
}

class JsonSecurityValidator {
  static const int maxSafePayloadLength =
      100000; // 100 KB limit for client protection

  static void validate(String? rawJson) {
    if (rawJson == null || rawJson.trim().isEmpty) {
      throw const EmptyInputException();
    }
    if (rawJson.length > maxSafePayloadLength) {
      throw OversizedInputException(rawJson.length, maxSafePayloadLength);
    }
  }
}
