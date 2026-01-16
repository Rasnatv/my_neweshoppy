import 'package:get_storage/get_storage.dart';

class StorageHelper {
  static final box = GetStorage();

  static void clearLocation() {
    box.remove("state");
    box.remove("district");
    box.remove("main_location");
  }

  static void clearAuth() {
    box.remove("auth_token");
  }
}
