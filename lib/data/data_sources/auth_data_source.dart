// lib/data/data_sources/auth_data_source.dart
import '../../core/services/api/api_client.dart'; // Import ApiClient
import '../../core/services/api/api_endpoints.dart'; // Import ApiEndpoints
import '../models/auth/auth_response.dart'; // Import AuthResponse model
import '../models/user/user.dart'; // Import User model
import 'package:dio/dio.dart'; // Corrected import for Dio

// Data source for handling authentication-related API calls.
// It interacts directly with the ApiClient to make requests to the backend.
class AuthDataSource {
  // Dependency on the ApiClient to make HTTP requests.
  final ApiClient _apiClient;

  // Constructor receives the ApiClient dependency.
  AuthDataSource(this._apiClient);

  // Sends a login request to the backend API.
  // Throws an exception if the login fails.
  Future<AuthResponse> login(String email, String password) async {
    try {
      // Make a POST request to the login endpoint with email and password in the body.
      final response = await _apiClient.dio.post(
        ApiEndpoints.login,
        data: {
          'email': email,
          'password': password,
        },
      );
      // Assuming the API returns a JSON structure that can be mapped to AuthResponse.
      return AuthResponse.fromJson(response.data);
    } on DioException catch (e) {
      // Catch Dio-specific errors and throw a more descriptive exception.
      // Try to extract the error message from the response data, otherwise use the Dio error message.
      throw Exception('Failed to login: ${e.response?.data['message'] ?? e.message}');
    } catch (e) {
      // Catch any other unexpected errors.
      throw Exception('Failed to login: $e');
    }
  }

  // Sends a registration request to the backend API.
  // Throws an exception if the registration fails.
  Future<AuthResponse> register(String name, String username, String email, String password) async {
    try {
      // Make a POST request to the register endpoint with user details in the body.
      final response = await _apiClient.dio.post(
        ApiEndpoints.register,
        data: {
          'name': name,
          'username': username,
          'email': email,
          'password': password,
          'password_confirmation': password, // Assuming backend requires password confirmation
        },
      );
      // Assuming the API returns a JSON structure that can be mapped to AuthResponse.
      return AuthResponse.fromJson(response.data);
    } on DioException catch (e) {
       // Catch Dio-specific errors and throw a more descriptive exception.
       throw Exception('Failed to register: ${e.response?.data['message'] ?? e.message}');
    } catch (e) {
      // Catch any other unexpected errors.
      throw Exception('Failed to register: $e');
    }
  }

  // Sends a logout request to the backend API.
  // Throws an exception if the logout fails.
  Future<void> logout() async {
    try {
      // Make a POST request to the logout endpoint.
      await _apiClient.dio.post(ApiEndpoints.logout);
      // No need to process response data for a successful logout.
    } on DioException catch (e) {
       // Catch Dio-specific errors and throw a more descriptive exception.
       throw Exception('Failed to logout: ${e.response?.data['message'] ?? e.message}');
    } catch (e) {
       // Catch any other unexpected errors.
       throw Exception('Failed to logout: $e');
    }
  }

  // Fetches the authenticated user's details from the backend API.
  // Throws an exception if fetching user details fails (e.g., not authenticated).
  Future<User> getAuthenticatedUser() async {
     try {
      // Make a GET request to the user endpoint.
      final response = await _apiClient.dio.get(ApiEndpoints.user);
       // Assuming the API returns a JSON structure that can be mapped to a User model.
       return User.fromJson(response.data);
    } on DioException catch (e) {
       // Catch Dio-specific errors and throw a more descriptive exception.
       throw Exception('Failed to fetch user: ${e.response?.data['message'] ?? e.message}');
    } catch (e) {
       // Catch any other unexpected errors.
       throw Exception('Failed to fetch user: $e');
    }
  }
}
