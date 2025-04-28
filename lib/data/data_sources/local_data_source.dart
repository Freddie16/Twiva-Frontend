// lib/data/data_sources/local_data_source.dart
import '../../core/services/local_storage.dart'; // Import the LocalStorage service

// A data source class for handling local data operations.
// It acts as a wrapper around the LocalStorage service, providing a data source interface.
// This can be useful if you have multiple local data sources (e.g., SharedPreferences, SQLite)
// and want to abstract the underlying storage mechanism.
class LocalDataSource {
  // Dependency on the LocalStorage service.
  final LocalStorage _localStorage;

  // Constructor receives the LocalStorage dependency.
  LocalDataSource(this._localStorage);

  // --- Authentication Token Methods ---

  // Retrieves the authentication token from local storage.
  Future<String?> getAuthToken() {
    return _localStorage.getAuthToken();
  }

  // Saves the authentication token to local storage.
  Future<void> saveAuthToken(String token) {
    return _localStorage.saveAuthToken(token);
  }

  // Removes the authentication token from local storage.
  Future<void> removeAuthToken() {
    return _localStorage.removeAuthToken();
  }

  // --- User ID Methods ---

  // Retrieves the user ID from local storage.
  Future<int?> getUserId() {
    return _localStorage.getUserId();
  }

  // Saves the user ID to local storage.
  Future<void> saveUserId(int userId) {
    return _localStorage.saveUserId(userId);
  }

  // Removes the user ID from local storage.
  Future<void> removeUserId() {
    return _localStorage.removeUserId();
  }

  // --- User Name Methods ---

  // Retrieves the user name from local storage.
  Future<String?> getUserName() {
    return _localStorage.getUserName();
  }

  // Saves the user name to local storage.
  Future<void> saveUserName(String name) {
    return _localStorage.saveUserName(name);
  }

  // Removes the user name from local storage.
  Future<void> removeUserName() {
    return _localStorage.removeUserName();
  }

  // --- User Email Methods ---

  // Retrieves the user email from local storage.
  Future<String?> getUserEmail() {
    return _localStorage.getUserEmail();
  }

  // Saves the user email to local storage.
  Future<void> saveUserEmail(String email) {
    return _localStorage.saveUserEmail(email);
  }

  // Removes the user email from local storage.
  Future<void> removeUserEmail() {
    return _localStorage.removeUserEmail();
  }

  // --- Generic Methods for other data types (Delegating to LocalStorage) ---

  // Saves a String value to local storage with a given key.
  Future<void> saveString(String key, String value) {
    return _localStorage.saveString(key, value);
  }

  // Retrieves a String value from local storage with a given key.
  Future<String?> getString(String key) {
    return _localStorage.getString(key);
  }

  // Saves a boolean value to local storage with a given key.
  Future<void> saveBool(String key, bool value) {
    return _localStorage.saveBool(key, value);
  }

  // Retrieves a boolean value from local storage with a given key.
  Future<bool?> getBool(String key) {
    return _localStorage.getBool(key);
  }

  // Saves an integer value to local storage with a given key.
  Future<void> saveInt(String key, int value) {
    return _localStorage.saveInt(key, value);
  }

  // Retrieves an integer value from local storage with a given key.
  Future<int?> getInt(String key) {
    return _localStorage.getInt(key);
  }

  // Saves a double value to local storage with a given key.
  Future<void> saveDouble(String key, double value) {
    return _localStorage.saveDouble(key, value);
  }

  // Retrieves a double value from local storage with a given key.
  Future<double?> getDouble(String key) {
    return _localStorage.getDouble(key);
  }

  // Saves a list of String values to local storage with a given key.
  Future<void> saveStringList(String key, List<String> value) {
    return _localStorage.saveStringList(key, value);
  }

  // Retrieves a list of String values from local storage with a given key.
  Future<List<String>?> getStringList(String key) {
    return _localStorage.getStringList(key);
  }

  // Removes a value from local storage with a given key.
  Future<void> removeValue(String key) {
    return _localStorage.removeValue(key);
  }

  // Clears all data from local storage. Use with caution.
  Future<void> clearAll() {
    return _localStorage.clearAll();
  }
}
