
import 'package:get_storage/get_storage.dart';

class GuestService {
  static final _box = GetStorage();

  static void enterGuestMode() {
    // Always clear stale guest location from previous sessions
    _box.remove('state_guest');
    _box.remove('district_guest');
    _box.remove('main_location_guest');

    _box.write('is_guest', true);
    _box.remove('auth_token');
    _box.write('is_logged_in', false);
  }

  static void exitGuestMode() {
    _box.remove('is_guest');
    _box.write('is_logged_in', false);
  }

  static void clearGuestData() {
    _box.remove('state_guest');
    _box.remove('district_guest');
    _box.remove('main_location_guest');
    exitGuestMode();
  }

  static void onLoginSuccess(String token) {
    // Migrate guest location to token key before clearing guest
    final guestState    = _box.read('state_guest') ?? '';
    final guestDistrict = _box.read('district_guest') ?? '';
    final guestMain     = _box.read('main_location_guest') ?? '';

    if (guestState.isNotEmpty && guestDistrict.isNotEmpty) {
      _box.write('state_$token',         guestState);
      _box.write('district_$token',      guestDistrict);
      _box.write('main_location_$token', guestMain);
    }

    _box.write('auth_token', token);
    _box.remove('is_guest');
    _box.write('is_logged_in', true);
  }

  static void onLogout() {
    // Clear token location too
    final token = _box.read<String?>('auth_token');
    if (token != null) {
      _box.remove('state_$token');
      _box.remove('district_$token');
      _box.remove('main_location_$token');
    }

    _box.remove('auth_token');
    _box.remove('is_guest');
    _box.write('is_logged_in', false);
  }

  static bool get isGuest => _box.read<bool>('is_guest') ?? false;

  static bool get isLoggedIn {
    final token = _box.read<String?>('auth_token');
    return !isGuest && token != null && token.isNotEmpty;
  }
}