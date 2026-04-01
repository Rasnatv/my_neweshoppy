
import 'dart:io';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:get_storage/get_storage.dart';
import 'dart:convert';

import '../banners/views/adminadvertisment.dart';

class AdminAdvertisementController extends GetxController {
  // ── Add form fields ──
  final adName = TextEditingController();
  var bannerImage = Rx<File?>(null);
  var advertisements = <Map<String, dynamic>>[].obs;
  var isLoading = false.obs;
  var isTitleEmpty = false.obs;

  // ── Filter ──
  var selectedFilter = 'all'.obs;
  var expandedId = ''.obs;

  // ── Edit / Update state ──
  var editAdId = ''.obs;
  var isEditLoading = false.obs;
  var isFetchingAd = false.obs;

  // Edit form controllers
  final editAdName = TextEditingController();
  var editBannerImage = Rx<File?>(null);

  // Locked / read-only fields loaded from GET single
  var editMainLocation = ''.obs;
  var editDistrict = ''.obs;
  var editEventLocation = ''.obs;
  var editCreatedByType = ''.obs;
  var editCreatedById = ''.obs;
  var editCreatedAt = ''.obs;
  var editNetworkBannerUrl = ''.obs;
  var editIsTitleEmpty = false.obs;

  final ImagePicker picker = ImagePicker();
  final box = GetStorage();

  String get authToken => box.read('auth_token') ?? '';

  @override
  void onInit() {
    super.onInit();
    fetchAdvertisements();
  }

  // ─────────────────────────────────────────────
  //  Filter helpers
  // ─────────────────────────────────────────────
  List<Map<String, dynamic>> get filteredAdvertisements {
    if (selectedFilter.value == 'all') return advertisements;
    return advertisements
        .where((ad) => ad['created_by_type'] == selectedFilter.value)
        .toList();
  }

  void setFilter(String filter) {
    selectedFilter.value = filter;
    expandedId.value = '';
  }

  void toggleExpand(String id) {
    expandedId.value = (expandedId.value == id) ? '' : id;
  }

  // ─────────────────────────────────────────────
  //  Add advertisement
  // ─────────────────────────────────────────────
  Future<void> pickBannerImage() async {
    try {
      final img = await picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1200,
        maxHeight: 800,
        imageQuality: 85,
      );
      if (img != null) bannerImage.value = File(img.path);
    } catch (e) {
      Get.snackbar("Error", "Failed to pick image");
    }
  }

  void removeBannerImage() => bannerImage.value = null;

  Future<String> imageToBase64WithDataUri(File imageFile) async {
    List<int> imageBytes = await imageFile.readAsBytes();
    String base64Image = base64Encode(imageBytes);
    String ext = imageFile.path.split('.').last.toLowerCase();
    String mime = 'image/jpeg';
    if (ext == 'png') mime = 'image/png';
    if (ext == 'gif') mime = 'image/gif';
    if (ext == 'webp') mime = 'image/webp';
    return 'data:$mime;base64,$base64Image';
  }

  Future<void> addAdvertisement() async {
    if (adName.text.trim().isEmpty) {
      isTitleEmpty.value = true;
      Get.snackbar("Error", "Please enter advertisement title");
      return;
    } else {
      isTitleEmpty.value = false;
    }
    if (bannerImage.value == null) {
      Get.snackbar("Error", "Please select banner image");
      return;
    }
    if (authToken.isEmpty) {
      Get.snackbar("Auth Error", "Please login again");
      return;
    }

    try {
      isLoading.value = true;
      String base64Image = await imageToBase64WithDataUri(bannerImage.value!);

      final response = await http.post(
        Uri.parse(
            'https://rasma.astradevelops.in/e_shoppyy/public/api/advertisement'),
        headers: {
          'Authorization': 'Bearer $authToken',
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'advertisement': adName.text.trim(),
          'banner_image': base64Image,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final jsonResponse = json.decode(response.body);
        if (jsonResponse['status'] == "1" ||
            jsonResponse['status'] == true) {
          adName.clear();
          bannerImage.value = null;
          fetchAdvertisements();
          Get.snackbar("Success", jsonResponse['message'] ?? "Ad added");
          Get.offAll(() => AdminAdvertisementPage());
        } else {
          Get.snackbar(
              "Failed", jsonResponse['message'] ?? "Error adding ad");
        }
      } else if (response.statusCode == 401) {
        Get.snackbar("Auth Error", "Session expired, please login again");
      } else {
        Get.snackbar("Error", "Server error ${response.statusCode}");
      }
    } catch (e) {
      Get.snackbar("Error", "Something went wrong");
    } finally {
      isLoading.value = false;
    }
  }

  // ─────────────────────────────────────────────
  //  Fetch all advertisements
  // ─────────────────────────────────────────────
  Future<void> fetchAdvertisements() async {
    try {
      isLoading.value = true;
      final response = await http.get(
        Uri.parse(
            'https://rasma.astradevelops.in/e_shoppyy/public/api/admin/advertisements'),
        headers: {
          'Authorization': 'Bearer $authToken',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        final status = jsonResponse['status'];
        final isSuccess = status == true || status == "1" || status == 1;

        if (isSuccess) {
          advertisements.value = List<Map<String, dynamic>>.from(
            jsonResponse['data'].map((ad) => {
              "id": ad['id'].toString(),
              "name": ad['advertisement'] ?? '',
              "banner": ad['banner_image'] ?? '',
              "main_location": ad['main_location'] ?? '',
              "district": ad['district'] ?? '',
              "event_location": ad['event_location'] ?? '',
              "created_by_type": ad['created_by_type'] ?? '',
              "created_by_id": ad['created_by_id']?.toString() ?? '',
              "created_at": ad['created_at'] ?? '',
            }),
          );
        }
      } else if (response.statusCode == 401) {
        Get.snackbar("Auth Error", "Session expired, please login again");
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to fetch advertisements");
    } finally {
      isLoading.value = false;
    }
  }

  // ─────────────────────────────────────────────
  //  GET single advertisement
  //  POST /api/get-Single-Advertisement-Admin
  //  body: { "advertisement_id": 65 }
  // ─────────────────────────────────────────────
  Future<void> fetchSingleAdvertisement(String adId) async {
    try {
      isFetchingAd.value = true;
      _clearEditState();
      editAdId.value = adId;

      final response = await http.post(
        Uri.parse(
            'https://rasma.astradevelops.in/e_shoppyy/public/api/get-Single-Advertisement-Admin'),
        headers: {
          'Authorization': 'Bearer $authToken',
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
        body: json.encode({'advertisement_id': int.tryParse(adId) ?? adId}),
      );

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        final isSuccess = jsonResponse['status'] == true ||
            jsonResponse['status'] == "1" ||
            jsonResponse['status'] == 1;

        if (isSuccess) {
          final data = jsonResponse['data'];
          editAdName.text = data['advertisement'] ?? '';
          editMainLocation.value = data['main_location'] ?? '';
          editDistrict.value = data['district'] ?? '';
          editEventLocation.value = data['event_location'] ?? '';
          editCreatedByType.value = data['created_by_type'] ?? '';
          editCreatedById.value = data['created_by_id']?.toString() ?? '';
          editCreatedAt.value = data['created_at'] ?? '';
          editNetworkBannerUrl.value = data['banner_image'] ?? '';
          editBannerImage.value = null;
        } else {
          Get.snackbar(
              "Error", jsonResponse['message'] ?? "Failed to load ad");
        }
      } else if (response.statusCode == 401) {
        Get.snackbar("Auth Error", "Session expired");
      } else {
        Get.snackbar("Error", "Server error ${response.statusCode}");
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to fetch advertisement details");
    } finally {
      isFetchingAd.value = false;
    }
  }

  // ─────────────────────────────────────────────
  //  UPDATE advertisement
  //  POST /api/update-Advertisement-Admin
  //  body: { advertisement_id, advertisement, district,
  //          main_location, banner_image (optional) }
  // ─────────────────────────────────────────────
  Future<void> updateAdvertisement() async {
    if (editAdName.text.trim().isEmpty) {
      editIsTitleEmpty.value = true;
      Get.snackbar("Error", "Please enter advertisement title");
      return;
    } else {
      editIsTitleEmpty.value = false;
    }

    if (authToken.isEmpty) {
      Get.snackbar("Auth Error", "Please login again");
      return;
    }

    try {
      isEditLoading.value = true;

      Map<String, dynamic> body = {
        'advertisement_id':
        int.tryParse(editAdId.value) ?? editAdId.value,
        'advertisement': editAdName.text.trim(),
        // send back the locked fields as-is
        'district': editDistrict.value,
        'main_location': editMainLocation.value,
        'event_location': editEventLocation.value,
      };

      // Only include banner_image if user picked a new local file
      if (editBannerImage.value != null) {
        body['banner_image'] =
        await imageToBase64WithDataUri(editBannerImage.value!);
      }

      final response = await http.put(
        Uri.parse(
            'https://rasma.astradevelops.in/e_shoppyy/public/api/update-Advertisement-Admin'),
        headers: {
          'Authorization': 'Bearer $authToken',
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
        body: json.encode(body),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final jsonResponse = json.decode(response.body);
        final isSuccess = jsonResponse['status'] == true ||
            jsonResponse['status'] == "1" ||
            jsonResponse['status'] == 1;

        if (isSuccess) {
          _clearEditState();
          fetchAdvertisements();
          Get.snackbar(
              "Success", jsonResponse['message'] ?? "Ad updated successfully");
          // Pop edit page and go back to list
          Get.toNamed('/adminadvertismentupdation');
        } else {
          Get.snackbar(
              "Failed", jsonResponse['message'] ?? "Error updating ad");
        }
      } else if (response.statusCode == 401) {
        Get.snackbar("Auth Error", "Session expired, please login again");
      } else {
        Get.snackbar("Error", "Server error ${response.statusCode}");
      }
    } catch (e) {
      Get.snackbar("Error", "Something went wrong");
    } finally {
      isEditLoading.value = false;
    }
  }

  // ─────────────────────────────────────────────
  //  Edit image picker (separate from add)
  // ─────────────────────────────────────────────
  Future<void> pickEditBannerImage() async {
    try {
      final img = await picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1200,
        maxHeight: 800,
        imageQuality: 85,
      );
      if (img != null) editBannerImage.value = File(img.path);
    } catch (e) {
      Get.snackbar("Error", "Failed to pick image");
    }
  }

  void removeEditBannerImage() => editBannerImage.value = null;

  void _clearEditState() {
    editAdName.clear();
    editBannerImage.value = null;
    editMainLocation.value = '';
    editDistrict.value = '';
    editEventLocation.value = '';
    editCreatedByType.value = '';
    editCreatedById.value = '';
    editCreatedAt.value = '';
    editNetworkBannerUrl.value = '';
    editIsTitleEmpty.value = false;
  }

  // ─────────────────────────────────────────────
  //  Delete advertisement
  // ─────────────────────────────────────────────
  Future<void> deleteAdvertisement(int index) async {
    if (index >= 0 && index < advertisements.length) {
      final ad = advertisements[index];
      final adId = ad['id'];


      try {
        final response = await http.delete(
          Uri.parse(
            'https://rasma.astradevelops.in/e_shoppyy/public/api/delete-advertisement-admin',
          ),
          headers: {
            'Authorization': 'Bearer $authToken',
            'Accept': 'application/json',
            'Content-Type': 'application/json',
          },
          body: jsonEncode({
            "advertisement_id": adId, // ✅ required field
          }),
        );

        final data = jsonDecode(response.body);

        if (response.statusCode == 200 && data['status'] == true) {
          advertisements.removeAt(index);
          Get.snackbar("Success", data['message']);
        } else {
          Get.snackbar("Error", data['message'] ?? "Delete failed");
        }
      } catch (e) {
        Get.snackbar("Error", "Something went wrong");
      }
    }
  }

  @override
  void onClose() {
    adName.dispose();
    editAdName.dispose();
    super.onClose();
  }
}