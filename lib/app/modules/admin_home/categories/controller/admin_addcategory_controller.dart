//
// import 'dart:convert';
// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:get_storage/get_storage.dart';
// import 'package:http/http.dart' as http;
// import 'package:image_picker/image_picker.dart';
//
// class AdminCategoryController extends GetxController {
//   final titleCtrl = TextEditingController();
//
//   final imageFile = Rx<File?>(null);
//   final attributes = <String>[].obs;
//
//   final isLoading = false.obs;
//   final box = GetStorage();
//
//   final String apiUrl =
//       "https://rasma.astradevelops.in/e_shoppyy/public/api/addcategories";
//
//   /// IMAGE PICK
//   Future<void> pickImage() async {
//     final picked =
//     await ImagePicker().pickImage(source: ImageSource.gallery);
//     if (picked != null) {
//       imageFile.value = File(picked.path);
//     }
//   }
//
//   /// ADD ATTRIBUTE
//   void addAttribute(String value) {
//     if (value.isEmpty) return;
//     if (!attributes.contains(value)) {
//       attributes.add(value);
//     }
//   }
//
//   void removeAttribute(String value) {
//     attributes.remove(value);
//   }
//
//   /// BASE64 WITH PREFIX (BACKEND NEEDS THIS)
//   String _toBase64(File file) {
//     final bytes = file.readAsBytesSync();
//     return "data:image/jpeg;base64,${base64Encode(bytes)}";
//   }
//
//   /// SUBMIT CATEGORY
//   Future<void> submit() async {
//     if (titleCtrl.text.trim().isEmpty) {
//       _error("Category name required");
//       return;
//     }
//
//     if (imageFile.value == null) {
//       _error("Category image required");
//       return;
//     }
//
//     if (attributes.isEmpty) {
//       _error("Add at least one attribute");
//       return;
//     }
//
//     final token = box.read("auth_token");
//
//     isLoading.value = true;
//
//     try {
//       final response = await http.post(
//         Uri.parse(apiUrl),
//         headers: {
//           "Authorization": "Bearer $token",
//           "Accept": "application/json",
//           "Content-Type": "application/json",
//         },
//         body: jsonEncode({
//           "name": titleCtrl.text.trim(),
//           "image": _toBase64(imageFile.value!),
//           "category_attributes": attributes,
//         }),
//       );
//
//       final body = jsonDecode(response.body);
//
//       /// 🔴 VALIDATION ERROR
//       if (response.statusCode == 422) {
//         final errors = body["errors"];
//         _error(errors.values.first[0]);
//         return;
//       }
//
//       if (response.statusCode == 201 && body["status"] == true) {
//         Get.snackbar("Success", body["message"]);
//         clearForm();
//       } else {
//         _error(body["message"] ?? "Failed");
//       }
//     } catch (e) {
//       _error("Server error");
//     } finally {
//       isLoading.value = false;
//     }
//   }
//
//   void clearForm() {
//     titleCtrl.clear();
//     imageFile.value = null;
//     attributes.clear();
//   }
//
//   void _error(String msg) {
//     Get.snackbar(
//       "Error",
//       msg,
//       backgroundColor: Colors.red,
//       colorText: Colors.white,
//     );
//   }
//
//   @override
//   void onClose() {
//     titleCtrl.dispose();
//     super.onClose();
//   }
// }
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class AdminCategoryController extends GetxController {
  final titleCtrl = TextEditingController();

  final imageFile = Rx<File?>(null);

  // 🔥 Separate attributes
  final commonAttributes = <String>[].obs;
  final variantAttributes = <String>[].obs;

  final isLoading = false.obs;
  final box = GetStorage();

  final String apiUrl =
      "https://rasma.astradevelops.in/e_shoppyy/public/api/addcategories";

  /// PICK IMAGE
  Future<void> pickImage() async {
    final picked =
    await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) {
      imageFile.value = File(picked.path);
    }
  }

  /// ADD ATTRIBUTES
  void addCommon(String value) {
    if (value.isNotEmpty && !commonAttributes.contains(value)) {
      commonAttributes.add(value);
    }
  }

  void addVariant(String value) {
    if (value.isNotEmpty && !variantAttributes.contains(value)) {
      variantAttributes.add(value);
    }
  }

  void removeCommon(String value) => commonAttributes.remove(value);
  void removeVariant(String value) => variantAttributes.remove(value);

  /// BASE64 IMAGE
  String _toBase64(File file) {
    final bytes = file.readAsBytesSync();
    return "data:image/jpeg;base64,${base64Encode(bytes)}";
  }

  /// SUBMIT CATEGORY
  Future<void> submit() async {
    if (titleCtrl.text.trim().isEmpty) {
      _error("Category name required");
      return;
    }

    if (imageFile.value == null) {
      _error("Category image required");
      return;
    }

    if (commonAttributes.isEmpty && variantAttributes.isEmpty) {
      _error("Add at least one attribute");
      return;
    }

    final token = box.read("auth_token");

    isLoading.value = true;

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          "Authorization": "Bearer $token",
          "Accept": "application/json",
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "name": titleCtrl.text.trim(),
          "image": _toBase64(imageFile.value!),
          "common_attributes": commonAttributes,
          "variant_attributes": variantAttributes,
        }),
      );

      final body = jsonDecode(response.body);

      if (response.statusCode == 201 && body["status"] == true) {
        Get.snackbar("Success", body["message"]);
        clearForm();
      } else {
        _error(body["message"] ?? "Something went wrong");
      }
    } catch (e) {
      _error("Server error");
    } finally {
      isLoading.value = false;
    }
  }

  void clearForm() {
    titleCtrl.clear();
    imageFile.value = null;
    commonAttributes.clear();
    variantAttributes.clear();
  }

  void _error(String msg) {
    Get.snackbar(
      "Error",
      msg,
      backgroundColor: Colors.red,
      colorText: Colors.white,
    );
  }

  @override
  void onClose() {
    titleCtrl.dispose();
    super.onClose();
  }
}
