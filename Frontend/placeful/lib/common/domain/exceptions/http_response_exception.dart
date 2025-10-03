class HttpResponseException implements Exception {
  HttpResponseException(this.statusCode, {this.message});

  final int statusCode;
  final String? message;

  @override
  String toString() {
    return message ?? 'HTTP Response Exception with status code: $statusCode';
  }
}