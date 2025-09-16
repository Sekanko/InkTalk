class CreateSentenceException implements Exception {
  final String message;
  CreateSentenceException(this.message);

  @override
  String toString() => "CreateSentenceException: $message";
}
