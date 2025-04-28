// lib/data/repositories/auth_repository.dart
import '../data_sources/auth_data_source.dart';
import '../data_sources/local_data_source.dart';
import '../models/auth/auth_response.dart';
import '../models/user/user.dart';
import '../../core/services/local_storage.dart';
class AuthRepository {
  final AuthDataSource _authDataSource;
  final LocalStorage _localStorage;

  AuthRepository(this._authDataSource, this._localStorage);

  Future<AuthResponse> login(String email, String password) async {
    try {
      final authResponse = await _authDataSource.login(email, password);
      await _localStorage.saveAuthToken(authResponse.token);
      await _localStorage.saveUserId(authResponse.user.id);
      return authResponse;
    } catch (e) {
      rethrow;
    }
  }

  Future<AuthResponse> register(String name, String username, String email, String password) async {
     try {
      final authResponse = await _authDataSource.register(name, username, email, password);
      await _localStorage.saveAuthToken(authResponse.token);
       await _localStorage.saveUserId(authResponse.user.id);
      return authResponse;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> logout() async {
    try {
      await _authDataSource.logout();
      await _localStorage.removeAuthToken();
      await _localStorage.removeUserId();
    } catch (e) {
      rethrow;
    }
  }

  Future<User?> getAuthenticatedUser() async {
     try {
      final token = await _localStorage.getAuthToken();
      if (token == null) {
        return null;
      }
      // Optionally fetch user details from API to ensure they are current
      // For simplicity, we might rely on the user object from login/register response initially
       return await _authDataSource.getAuthenticatedUser();
    } catch (e) {
      // Handle token expiration or invalid token
       await _localStorage.removeAuthToken();
       await _localStorage.removeUserId();
      return null;
    }
  }

  Future<bool> isAuthenticated() async {
    final token = await _localStorage.getAuthToken();
    return token != null;
  }
}