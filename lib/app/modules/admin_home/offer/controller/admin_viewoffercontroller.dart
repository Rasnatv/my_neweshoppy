import 'dart:convert';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import '../../../../data/models/admin_offerviewmodel.dart';


class AdminViewOfferController extends GetxController {
  final RxList<AdminViewOfferModel> offers = <AdminViewOfferModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool hasError = false.obs;
  final RxString errorMessage = ''.obs;

  // GetStorage instance — same as LoginController
  final GetStorage box = GetStorage();

  static const String _baseUrl =
      'https://rasma.astradevelops.in/e_shoppyy/public/api/offers';

  // ── Auth token helper ───────────────────────────────────────────────────

  /// Reads auth_token saved by LoginController via GetStorage.
  String? get _authToken => box.read('auth_token');

  /// Build request headers with Bearer auth_token.
  Map<String, String> get _headers => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    if (_authToken != null && _authToken!.isNotEmpty)
      'Authorization': 'Bearer $_authToken',
  };

  // ── Lifecycle ───────────────────────────────────────────────────────────

  @override
  void onInit() {
    super.onInit();
    fetchOffers();
  }

  // ── API Call ────────────────────────────────────────────────────────────

  Future<void> fetchOffers() async {
    try {
      isLoading.value = true;
      hasError.value = false;
      errorMessage.value = '';

      final response = await http.get(
        Uri.parse(_baseUrl),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = json.decode(response.body);

        if (jsonData['status'] == 1) {
          final List<dynamic> data = jsonData['data'];
          offers.value =
              data.map((item) => AdminViewOfferModel.fromJson(item)).toList();
        } else {
          hasError.value = true;
          errorMessage.value =
              jsonData['message'] ?? 'Failed to fetch offers.';
        }
      } else if (response.statusCode == 401) {
        hasError.value = true;
        errorMessage.value = 'Unauthorized. Please log in again.';
        _handleUnauthorized();
      } else {
        hasError.value = true;
        errorMessage.value = 'Server error: ${response.statusCode}';
      }
    } catch (e) {
      hasError.value = true;
      errorMessage.value = 'Something went wrong: $e';
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> refreshOffers() async {
    await fetchOffers();
  }

  // ── Unauthorized Handler ────────────────────────────────────────────────

  /// Clears stored session and redirects to login on 401.
  void _handleUnauthorized() {
    box.remove('auth_token');
    box.remove('role');
    box.remove('user_data');
    box.write('is_logged_in', false);
    // Uncomment and set your login route:
    // Get.offAllNamed('/login');
  }

  // ── Computed Getters ────────────────────────────────────────────────────

  /// Group offers by shop name.
  Map<String, List<AdminViewOfferModel>> get groupedOffers {
    final Map<String, List<AdminViewOfferModel>> grouped = {};
    for (final offer in offers) {
      grouped.putIfAbsent(offer.shopName, () => []).add(offer);
    }
    return grouped;
  }

  int get totalOffers => offers.length;

  List<String> get shopNames =>
      offers.map((o) => o.shopName).toSet().toList();
}