import 'package:get_storage/get_storage.dart';

class PreferenceManager {
  static GetStorage getStorage = GetStorage();

  static Future setUid(String value) async {
    await getStorage.write('uid', value);
  }

  static getUid() {
    return getStorage.read('uid');
  }

  static Future setEmail(String value) async {
    await getStorage.write('email', value);
  }

  static getEmail() {
    return getStorage.read('email');
  }

  static Future setName(String value) async {
    await getStorage.write('name', value);
  }

  static getName() {
    return getStorage.read('name');
  }

  static Future setImage(String value) async {
    await getStorage.write('image', value);
  }

  static getImage() {
    return getStorage.read('image');
  }

  static Future<void> clearData() async {
    // await getStorage.erase();
    await getStorage.remove('uid');
    await getStorage.remove('email');
    await getStorage.remove('image');
    await getStorage.remove('name');
  }
}
