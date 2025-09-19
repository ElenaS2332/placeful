import 'package:http/http.dart';
import 'package:placeful/core/domain/exceptions/http_response_exception.dart';

extension HttpResponseExtensions on Response {
  void ensureSuccessStatusCode() {
    if (statusCode >= 200 && statusCode <= 299) {
      return;
    }
    throw HttpResponseException(statusCode, message: reasonPhrase);
  }
}