import 'dart:convert';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

import '../../../data/errors/api_error.dart';
import '../../../data/models/homedatamodel.dart';
import '../../../widgets/network_trihgiger.dart';
import '../../merchantlogin/widget/successwidget.dart';


class HomeAdModel {
  final String id;
  final String advertisement;
  final String bannerImage;
  final String mainLocation;
  final String district;

  HomeAdModel({
    required this.id,
    required this.advertisement,
    required this.bannerImage,
    required this.mainLocation,
    required this.district,
  });

  factory HomeAdModel.fromJson(Map<String, dynamic> j) => HomeAdModel(
    id: j['id']?.toString() ?? '',
    advertisement: j['advertisement'] ?? '',
    bannerImage: j['banner_image'] ?? '',
    mainLocation: j['main_location'] ?? '',
    district: j['district'] ?? '',
  );
}

// ── Controller ────────────────────────────────────────────────────────────────

class HomeDataController extends GetxController {
  final box = GetStorage();

  final String _apiUrl =
      "https://rasma.astradevelops.in/e_shoppyy/public/api/get-home-data";

  final RxList<HomeEventModel> events = <HomeEventModel>[].obs;
  final RxList<HomeAdModel> advertisements = <HomeAdModel>[].obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    // ever(Get.find<NetworkService>().reconnectTrigger, (_) {
    //   if (_hasSavedLocation()) refresh();
    // });

    if (_hasSavedLocation()) {
      _fetchFromStorage();
    }
  }

  // ── Called by UserLocationController.saveLocation() after confirm ─────────
  Future<void> fetchHomeData({
    required String state,
    required String district,
    required String mainLocation,
  }) async {
    final token = box.read("auth_token");
    if (token == null || token.toString().isEmpty) return;

    try {
      isLoading(true);

      final response = await http.post(
        Uri.parse(_apiUrl),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode({
          "state": state,
          "district": district,
          "main_location": mainLocation,
        }),
      );

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);

        if (decoded['status'] == true || decoded['status_code'] == 200) {
          final data = decoded['data'] ?? {};

          events.value = (data['events'] as List? ?? [])
              .map((e) => HomeEventModel.fromJson(e))
              .toList();

          advertisements.value = (data['advertisements'] as List? ?? [])
              .map((e) => HomeAdModel.fromJson(e))
              .toList();
        } else {
          events.clear();
          advertisements.clear();
          AppSnackbar.error(
              decoded['message'] ?? 'Failed to load home data');
        }
      } else {
        events.clear();
        advertisements.clear();
        AppSnackbar.error(ApiErrorHandler.handleResponse(response));
      }
    } catch (e) {
      events.clear();
      advertisements.clear();
      // AppSnackbar.error(ApiErrorHandler.handleException(e));
      // Get.log("HomeDataController error: $e");
    } finally {
      isLoading(false);
    }
  }

  // ── Called by UserLocationController.skipLocation() ──────────────────────
  void clearHomeData() {
    events.clear();
    advertisements.clear();
  }

  // ── Called by reconnect trigger ───────────────────────────────────────────
  Future<void> refresh() async {
    events.clear();
    advertisements.clear();
    await _fetchFromStorage();
  }

  // ── Reads saved location from storage and fetches ─────────────────────────
  Future<void> _fetchFromStorage() async {
    final token = box.read('auth_token');
    if (token == null) return;

    final state = box.read('state_$token') ?? '';
    final district = box.read('district_$token') ?? '';
    final mainLocation = box.read('main_location_$token') ?? '';

    // Only fetch if at least one field is saved
    if (state.isEmpty && district.isEmpty && mainLocation.isEmpty) return;

    await fetchHomeData(
      state: state,
      district: district,
      mainLocation: mainLocation,
    );
  }

  // ── True if user has any saved location in storage ────────────────────────
  bool _hasSavedLocation() {
    final token = box.read('auth_token');
    if (token == null) return false;

    final state = box.read('state_$token') ?? '';
    final district = box.read('district_$token') ?? '';
    final mainLocation = box.read('main_location_$token') ?? '';

    return state.isNotEmpty || district.isNotEmpty || mainLocation.isNotEmpty;
  }
}
