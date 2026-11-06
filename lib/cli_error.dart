class CliError implements Exception {
  final String code;
  final String message;

  const CliError(this.code, this.message);

  @override
  String toString() => '[$code] $message';
}
