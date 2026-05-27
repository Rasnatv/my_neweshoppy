
import 'dart:convert';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

import '../../../data/errors/api_error.dart';
import '../../../data/models/homedatamodel.dart';
import '../../merchantlogin/widget/successwidget.dart';
import '../widget/guestrole.dart';

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

class HomeDataController extends GetxController {
  final box = GetStorage();

  final String _apiUrl = "https://eshoppy.co.in/api/get-home-data";

  final RxList<HomeEventModel> events = <HomeEventModel>[].obs;
  final RxList<HomeAdModel> advertisements = <HomeAdModel>[].obs;
  final RxBool isLoading = false.obs;

  // ── Auth header — works with or without token ─────────────────────────────
  Map<String, String> _authHeader() {
    final token = box.read<String?>('auth_token');
    return {
      "Accept": "application/json",
      "Content-Type": "application/json",
      if (token != null && token.isNotEmpty) "Authorization": "Bearer $token",
    };
  }

  @override
  void onInit() {
    super.onInit();

  }

  Future<void> fetchHomeData({
    required String state,
    required String district,
    required String mainLocation,
  }) async {
    try {
      isLoading(true);

      final response = await http.post(
        Uri.parse(_apiUrl),
        headers: _authHeader(),
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
          AppSnackbar.error(decoded['message'] ?? 'Failed to load home data');
        }
      } else {
        events.clear();
        advertisements.clear();
        AppSnackbar.error(ApiErrorHandler.handleResponse(response));
      }
    } catch (e) {
      events.clear();
      advertisements.clear();
    } finally {
      isLoading(false);
    }
  }

  void clearHomeData() {
    events.clear();
    advertisements.clear();
  }

  Future<void> refresh() async {
    events.clear();
    advertisements.clear();
    await _fetchFromStorage();
  }

  Future<void> _fetchFromStorage() async {
    // Allow guests to proceed without a token
    if (!GuestService.isGuest) {
      final token = box.read('auth_token');
      if (token == null) return;
    }

    final storageKey = box.read('auth_token') ?? 'guest';
    final state = box.read('state_$storageKey') ?? '';
    final district = box.read('district_$storageKey') ?? '';
    final mainLocation = box.read('main_location_$storageKey') ?? '';

    await fetchHomeData(
      state: state,
      district: district,
      mainLocation: mainLocation,
    );
  }

  bool _hasSavedLocation() {
    final storageKey = box.read('auth_token') ??
        (GuestService.isGuest ? 'guest' : null);
    if (storageKey == null) return false;

    final state = box.read('state_$storageKey') ?? '';
    final district = box.read('district_$storageKey') ?? '';
    return state.isNotEmpty && district.isNotEmpty;
  }
}