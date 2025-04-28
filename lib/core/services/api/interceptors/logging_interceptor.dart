// lib/core/services/api/interceptors/logging_interceptor.dart
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart'; // Import for kDebugMode

// A custom Dio interceptor for logging API requests, responses, and errors.
// This helps in debugging network calls during development.
class LoggingInterceptor extends Interceptor {

  // This method is called before a request is sent.
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // Only log in debug mode to avoid printing sensitive info in production
    if (kDebugMode) {
      print('--- API Request ---');
      print('METHOD: ${options.method}'); // HTTP method (GET, POST, etc.)
      print('PATH: ${options.path}'); // Request path
      print('BASE URL: ${options.baseUrl}'); // Base URL
      print('HEADERS: ${options.headers}'); // Request headers
      print('QUERY PARAMETERS: ${options.queryParameters}'); // Query parameters
      // Log request data for methods like POST, PUT, PATCH
      if (options.data != null) {
        print('DATA: ${options.data}');
      }
      print('-------------------');
    }
    // Continue with the request
    super.onRequest(options, handler);
  }

  // This method is called when a response is received successfully.
  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    // Only log in debug mode
    if (kDebugMode) {
      print('--- API Response ---');
      print('STATUS CODE: ${response.statusCode}'); // HTTP status code
      print('PATH: ${response.requestOptions.path}'); // Request path
      print('DATA: ${response.data}'); // Response body data
      print('--------------------');
    }
    // Continue with the response
    super.onResponse(response, handler);
  }

  // This method is called when an error occurs during the request or response.
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // Only log in debug mode
    if (kDebugMode) {
      print('--- API Error ---');
      print('ERROR TYPE: ${err.type}'); // Type of Dio error
      print('ERROR MESSAGE: ${err.message}'); // Error message
      print('PATH: ${err.requestOptions.path}'); // Request path
      // Log response details if available (e.g., for 4xx or 5xx errors)
      if (err.response != null) {
        print('RESPONSE STATUS CODE: ${err.response?.statusCode}');
        print('RESPONSE DATA: ${err.response?.data}');
        print('RESPONSE HEADERS: ${err.response?.headers}');
      }
      print('-----------------');
    }
    // Continue with the error handling
    super.onError(err, handler);
  }
}
