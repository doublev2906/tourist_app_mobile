import 'package:hive_flutter/hive_flutter.dart';
// import 'package:pancake_mobile/storage/hive_keys.dart';
// import 'package:pancake_mobile/utils/actions/map_data.dart';
// import 'hive_storage.dart';

const appBoxName = "TOURIST_APP";

const tokenKey = "TOKEN";
const refreshTokenKey = "REFRESH_TOKEN";

const userKey = "USER";

const categoryKey = "CATEGORY";

final appStorage = AppStorage();

class AppStorage {
  late Box box;
  Future<void> openBox() async {
    await Hive.initFlutter();
    box = await Hive.openBox(appBoxName);
    return;
  }

  void putData(key, data) => box.put(key, data);
  void removeData(key) => box.delete(key);
  String getData(key) => box.get(key, defaultValue: "");

  void putToken(key, token) => box.put(key, token);
  void removeToken(key) => box.delete(key);
  String getToken(key) => box.get(key, defaultValue: "");

  String getUser() => box.get(userKey, defaultValue: "");
  void putUser(data) => box.put(userKey, data);
  void removeUser() => box.delete(userKey);

  Box getBox() => box;
}
