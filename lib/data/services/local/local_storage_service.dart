import 'package:hive_flutter/hive_flutter.dart';

class StorageService {
  static late StorageService instance;
  static Future<StorageService> getInstance() async {
    instance = StorageService();
    await Hive.initFlutter();
    return instance;
  }

  dynamic getLocalStorageData(String boxName, String keyName) async {
    await Hive.openBox(boxName);
    final box = Hive.box(boxName);
    final data = box.get(keyName);
    return data;
  }

  void saveLocalStorageData(
      String boxName, String keyName, dynamic data) async {
    final box = Hive.box(boxName);
    await box.put(keyName, data);
  }
}
