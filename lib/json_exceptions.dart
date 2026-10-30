/// استثناء مخصص وصارم لمعالجة أخطاء تحليل وتحويل نصوص الـ JSON
class JsonParseException implements Exception {
  final String message;
  final dynamic originalError;

  const JsonParseException(this.message, [this.originalError]);

  @override
  String toString() {
    if (originalError != null) {
      return 'JsonParseException: $message (Details: $originalError)';
    }
    return 'JsonParseException: $message';
  }
}
