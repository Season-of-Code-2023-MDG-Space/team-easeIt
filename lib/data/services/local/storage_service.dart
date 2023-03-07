import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static late StorageService instance;
  static late SharedPreferences _preferences;

  static Future<StorageService> getInstance() async {
    instance = StorageService();
    _preferences = await SharedPreferences.getInstance();

    return instance;
  }

  dynamic _getFromDisk(String key) {
    final dynamic value = _preferences.get(key);
    return value;
  }

  void _saveToDisk<T>(String key, T content) {
    if (content is String) {
      _preferences.setString(key, content);
    } else if (content is bool) {
      _preferences.setBool(key, content);
    } else if (content is int) {
      _preferences.setInt(key, content);
    } else if (content is double) {
      _preferences.setDouble(key, content);
    } else if (content is List<String>) {
      _preferences.setStringList(key, content);
    }
  }

  // setters
  set isLoggedIn(bool isLoggedIn) {
    _saveToDisk('logged-in', isLoggedIn);
  }

  set isFirstTime(bool isFirstTime) {
    _saveToDisk('first-time', isFirstTime);
  }

  set isUserRegistered(bool isUserDetails) {
    _saveToDisk('user-registered', isUserRegistered);
  }

  // getters
  bool get isLoggedIn => _getFromDisk('logged-in') ?? false;
  bool get isFirstTime => _getFromDisk('first-time') ?? true;
  bool get isUserRegistered => _getFromDisk('user-registered') ?? false;
}
