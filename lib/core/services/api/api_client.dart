// lib/core/services/api/api_client.dart
import 'package:dio/dio.dart';
import '../local_storage.dart';
import '../../constants/app_constants.dart';
import 'interceptors/logging_interceptor.dart';

class ApiClient {
  late Dio _dio;
  final LocalStorage _localStorage;

  // Constructor receives the LocalStorage instance
  ApiClient(this._localStorage) {
    // Configure Dio with base options
    _dio = Dio(
      BaseOptions(
        baseUrl: AppConstants.baseUrl, // Use the base URL from constants
        connectTimeout: const Duration(seconds: 10), // Connection timeout
        receiveTimeout: const Duration(seconds: 60), // Receive timeout
        headers: {
          'Accept': 'application/json', // Request JSON responses
        },
      ),
    );

    // Add interceptors to the Dio instance
    _dio.interceptors.add(LoggingInterceptor()); // Add logging for requests/responses

    // Add an interceptor for handling requests and errors
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          // Before sending the request, add the authorization token if available
          final token = await _localStorage.getAuthToken();
          if (token != null) {
            // Add the Authorization header with the Bearer token
            options.headers['Authorization'] = 'Bearer $token';
          }
          // Continue with the request
          return handler.next(options);
        },
        onError: (DioException e, handler) {
          // Handle API errors
          // A 401 status code typically indicates an authentication error (e.g., invalid or expired token)
          if (e.response?.statusCode == 401) {
            // In case of a 401, the responsibility to clear the token and
            // trigger logout logic (like navigating to the login screen)
            // should ideally reside in the calling code (repositories or notifiers)
            // that catches this specific error. This avoids the ApiClient
            // having direct dependencies on authentication state management.
            // The repository/notifier can catch the DioException, check the status code,
            // clear the token via LocalStorage, and then update the AuthNotifier state.

            // For now, we just log the error in the LoggingInterceptor and
            // re-throw the exception so it can be caught by the calling code.
          }
          // Continue with the error handling (e.g., pass the error to the next interceptor or the caller)
          return handler.next(e);
        },
      ),
    );
  }

  // Getter to access the configured Dio instance
  Dio get dio => _dio;
}
