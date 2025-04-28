// lib/core/services/local_storage.dart
import 'package:shared_preferences/shared_preferences.dart'; // Import the shared_preferences package

// A service class for handling local data storage using SharedPreferences.
// This is suitable for simple key-value pairs.
class LocalStorage {
  // Define static keys for different data types to be stored
  static const String _authTokenKey = 'auth_token'; // Key for storing the authentication token
  static const String _userIdKey = 'user_id'; // Key for storing the authenticated user's ID
  static const String _userNameKey = 'user_name'; // Key for storing the authenticated user's name
  static const String _userEmailKey = 'user_email'; // Key for storing the authenticated user's email
  static const String _appSettingsKey = 'app_settings'; // Key for storing application settings (e.g., theme preference)
  // Add more keys as needed for different data types or features

  // --- Authentication Token Methods ---

  // Saves the authentication token to local storage.
  Future<void> saveAuthToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_authTokenKey, token);
  }

  // Retrieves the authentication token from local storage.
  Future<String?> getAuthToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_authTokenKey);
  }

  // Removes the authentication token from local storage.
  Future<void> removeAuthToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_authTokenKey);
  }

  // --- User ID Methods ---

  // Saves the user ID to local storage.
  Future<void> saveUserId(int userId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_userIdKey, userId);
  }

  // Retrieves the user ID from local storage.
  Future<int?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_userIdKey);
  }

  // Removes the user ID from local storage.
  Future<void> removeUserId() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userIdKey);
  }

  // --- User Name Methods ---

  // Saves the user name to local storage.
  Future<void> saveUserName(String name) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userNameKey, name);
  }

  // Retrieves the user name from local storage.
  Future<String?> getUserName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userNameKey);
  }

  // Removes the user name from local storage.
  Future<void> removeUserName() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userNameKey);
  }

  // --- User Email Methods ---

  // Saves the user email to local storage.
  Future<void> saveUserEmail(String email) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userEmailKey, email);
  }

  // Retrieves the user email from local storage.
  Future<String?> getUserEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userEmailKey);
  }

  // Removes the user email from local storage.
  Future<void> removeUserEmail() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userEmailKey);
  }


  // --- Generic Methods for other data types ---

  // Saves a String value to local storage with a given key.
  Future<void> saveString(String key, String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, value);
  }

  // Retrieves a String value from local storage with a given key.
  Future<String?> getString(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(key);
  }

  // Saves a boolean value to local storage with a given key.
  Future<void> saveBool(String key, bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(key, value);
  }

  // Retrieves a boolean value from local storage with a given key.
  Future<bool?> getBool(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(key);
  }

  // Saves an integer value to local storage with a given key.
  Future<void> saveInt(String key, int value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(key, value);
  }

  // Retrieves an integer value from local storage with a given key.
  Future<int?> getInt(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(key);
  }

  // Saves a double value to local storage with a given key.
  Future<void> saveDouble(String key, double value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(key, value);
  }

  // Retrieves a double value from local storage with a given key.
  Future<double?> getDouble(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getDouble(key);
  }

   // Saves a list of String values to local storage with a given key.
  Future<void> saveStringList(String key, List<String> value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(key, value);
  }

  // Retrieves a list of String values from local storage with a given key.
  Future<List<String>?> getStringList(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(key);
  }

  // Removes a value from local storage with a given key.
  Future<void> removeValue(String key) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(key);
  }

  // Clears all data from local storage. Use with caution.
  Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
