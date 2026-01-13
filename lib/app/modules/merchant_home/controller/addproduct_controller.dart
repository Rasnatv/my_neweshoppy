
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../../data/models/produuct_variantmodel.dart';

class ProductController extends GetxController {
  // ---------------- BASIC FIELDS ----------------
  var productName = ''.obs;
  var selectedCategory = ''.obs;
  var productDescription = ''.obs;
  var isPublished = false.obs;
  var isFeatured = false.obs;

  // ---------------- CATEGORY MAPPINGS ----------------
  final Map<String, List<String>> categoryAttributes = {
    "Fashion & Apparel": ["Size", "Color", "Material", "Brand", "Fit", "Pattern", ],
    "Beauty & Personal Care": ["Shade", "Skin Type", "Hair Type", "Ingredients", "Brand", "Volume", ],
    "Electronics": ["Brand", "Model", "RAM", "Storage", "Battery", "Warranty", "Screen Size", ],
    "Grocery & Essentials": ["Weight", "Brand", "Expiry Date", "Package Type", "Organic",],
    "Bakery & Food": ["Weight / Quantity", "Flavor / Type", "Ingredients", "Expiry Date", "Brand", "Allergen Info", "Packaging Type", ],
    "Home Appliances": ["Brand", "Model", "Power", "Capacity", "Warranty", ],
    "Furniture": ["Material", "Color", "Size", "Brand", "Weight", "Style",],
    "Sports & Fitness": ["Size", "Material", "Brand", "Weight", "Capacity", ],
    "Kids Products": ["Age Group", "Material", "Brand", "Safety Info",],
    "Pet Supplies": ["Pet Type", "Weight", "Ingredients", "Age Group", "Brand",],
    "Automobile & Accessories": ["Vehicle Type", "Model", "Brand", "Year", "Part Type",],
    "Medicine & Healthcare": ["Medicine Type", "Dosage", "Expiry Date", "Composition", "Brand",],
    "Home & Kitchen": ["Material", "Brand", "Size", "Capacity", ],
    "Tools & Hardware": ["Material", "Brand", "Size", "Power", ],
  };

  // ---------------- VARIANTS ----------------
  var variants = <ProductVariant>[].obs;

  // ---------------- IMAGE PICKER ----------------
  final ImagePicker picker = ImagePicker();

  // ---------------- DRAFT MANAGEMENT ----------------
  var isDraft = false.obs;
  var lastSavedTime = Rx<DateTime?>(null);

  // ---------------- TAGS ----------------
  var tags = <String>[].obs;

  void addTag(String tag) {
    if (tag.trim().isNotEmpty && !tags.contains(tag.trim())) {
      tags.add(tag.trim());
    }
  }

  void removeTag(String tag) {
    tags.remove(tag);
  }

  // ---------------- VARIANT OPERATIONS ----------------
  void addVariant() {
    if (selectedCategory.value.isEmpty) {
      Get.snackbar(
        "Category Required",
        "Please select a category first",
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    List<String> featureKeys = categoryAttributes[selectedCategory.value] ?? [];
    variants.add(ProductVariant(features: {for (var key in featureKeys) key: ''}));
  }

  void removeVariant(int index) {
    if (index >= 0 && index < variants.length) {
      variants.removeAt(index);
    }
  }

  void duplicateVariant(int index) {
    if (index >= 0 && index < variants.length) {
      final original = variants[index];
      final duplicate = ProductVariant(
        title: "${original.title} (Copy)",
        price: original.price,
        stock: original.stock,
        imagePath: original.imagePath,
        features: Map<String, dynamic>.from(original.features),
      );
      variants.insert(index + 1, duplicate);
      Get.snackbar(
        "Variant Duplicated",
        "A copy has been created",
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  // ---------------- IMAGE OPERATIONS ----------------
  Future<void> pickImage(int index) async {
    if (index < 0 || index >= variants.length) return;

    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 1920,
      maxHeight: 1920,
      imageQuality: 85,
    );

    if (pickedFile != null) {
      variants[index].imagePath = pickedFile.path;
      variants.refresh();
    }
  }
  Future<void> pickMultipleImages(int index) async {
    if (index < 0 || index >= variants.length) return;

    final List<XFile> pickedFiles = await picker.pickMultiImage(
      maxWidth: 1920,
      maxHeight: 1920,
      imageQuality: 85,
    );

    if (pickedFiles.isNotEmpty) {
      // Use first image as main image
      variants[index].imagePath = pickedFiles.first.path;
      variants.refresh();

      if (pickedFiles.length > 1) {
        Get.snackbar(
          "Multiple Images",
          "${pickedFiles.length} images selected. First image set as main.",
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    }
  }


  Future<void> captureImage(int index) async {
    if (index < 0 || index >= variants.length) return;

    final pickedFile = await picker.pickImage(
      source: ImageSource.camera,
      maxWidth: 1920,
      maxHeight: 1920,
      imageQuality: 85,
    );

    if (pickedFile != null) {
      variants[index].imagePath = pickedFile.path;
      variants.refresh();
    }
  }

  void removeImage(int index) {
    if (index >= 0 && index < variants.length) {
      variants[index].imagePath = null;
      variants.refresh();
    }
  }

  // ---------------- VALIDATION ----------------
  String? validateProductName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Product name is required";
    }
    if (value.length < 3) {
      return "Product name must be at least 3 characters";
    }
    if (value.length > 100) {
      return "Product name must be less than 100 characters";
    }
    return null;
  }

  String? validatePrice(double? value) {
    if (value == null || value <= 0) {
      return "Price must be greater than 0";
    }
    return null;
  }

  String? validateStock(int? value) {
    if (value == null || value < 0) {
      return "Stock cannot be negative";
    }
    return null;
  }

  bool validateForm() {
    if (productName.value.trim().isEmpty) {
      Get.snackbar("Validation Error", "Product name is required");
      return false;
    }

    if (selectedCategory.value.isEmpty) {
      Get.snackbar("Validation Error", "Category is required");
      return false;
    }

    if (variants.isEmpty) {
      Get.snackbar("Validation Error", "At least one variant is required");
      return false;
    }

    // Validate each variant
    for (int i = 0; i < variants.length; i++) {
      final variant = variants[i];

      if (variant.title == null || variant.title!.trim().isEmpty) {
        Get.snackbar(
          "Validation Error",
          "Variant ${i + 1}: Title is required",
        );
        return false;
      }

      if (variant.price == null || variant.price! <= 0) {
        Get.snackbar(
          "Validation Error",
          "Variant ${i + 1}: Valid price is required",
        );
        return false;
      }

      if (variant.stock == null || variant.stock! < 0) {
        Get.snackbar(
          "Validation Error",
          "Variant ${i + 1}: Valid stock quantity is required",
        );
        return false;
      }

      if (variant.imagePath == null) {
        Get.snackbar(
          "Validation Error",
          "Variant ${i + 1}: Product image is required",
        );
        return false;
      }
    }

    return true;
  }

  // ---------------- DRAFT OPERATIONS ----------------
  void saveDraft() {
    isDraft.value = true;
    lastSavedTime.value = DateTime.now();

    final draftData = _buildProductData();
    // Here you would save to local storage or database
    print("DRAFT_SAVED: $draftData");

    Get.snackbar(
      "Draft Saved",
      "Your changes have been saved",
      snackPosition: SnackPosition.BOTTOM,
      duration: Duration(seconds: 2),
    );
  }

  void loadDraft() {
    // Here you would load from local storage or database
    Get.snackbar(
      "Draft Loaded",
      "Previous draft has been restored",
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  // ---------------- PRODUCT SUBMISSION ----------------
  void saveProduct() {
    if (!validateForm()) return;

    final productData = _buildProductData();

    // Here you would send to API or database
    print("PRODUCT_SAVED: $productData");

    Get.snackbar(
      "Success",
      "Product has been saved successfully",
      snackPosition: SnackPosition.BOTTOM,
      duration: Duration(seconds: 3),
    );

    // Clear form after successful save
    if (Get.dialog != null) {
      _clearForm();
    }
  }

  Map<String, dynamic> _buildProductData() {
    return {
      "name": productName.value.trim(),
      "category": selectedCategory.value,
      "description": productDescription.value.trim(),
      "isPublished": isPublished.value,
      "isFeatured": isFeatured.value,
      "tags": tags.toList(),
      "variants": variants.map((variant) {
        return {
          "title": variant.title,
          "price": variant.price,
          "stock": variant.stock,
          "imagePath": variant.imagePath,
          "features": variant.features,
        };
      }).toList(),
      "createdAt": DateTime.now().toIso8601String(),
      "isDraft": isDraft.value,
    };
  }

  // ---------------- BULK OPERATIONS ----------------
  void applyPriceToAll(double price) {
    for (var variant in variants) {
      variant.price = price;
    }
    variants.refresh();
    Get.snackbar(
      "Price Updated",
      "Price applied to all variants",
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void applyStockToAll(int stock) {
    for (var variant in variants) {
      variant.stock = stock;
    }
    variants.refresh();
    Get.snackbar(
      "Stock Updated",
      "Stock applied to all variants",
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  // ---------------- CLEAR & RESET ----------------
  void _clearForm() {
    productName.value = '';
    selectedCategory.value = '';
    productDescription.value = '';
    isPublished.value = false;
    isFeatured.value = false;
    variants.clear();
    tags.clear();
    isDraft.value = false;
    lastSavedTime.value = null;
  }

  void resetForm() {
    Get.dialog(
      AlertDialog(
        title: Text("Reset Form"),
        content: Text("Are you sure you want to reset? All unsaved changes will be lost."),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              _clearForm();
              Get.back();
              Get.snackbar(
                "Form Reset",
                "All fields have been cleared",
                snackPosition: SnackPosition.BOTTOM,
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: Text("Reset"),
          ),
        ],
      ),
    );
  }

  // ---------------- IMPORT/EXPORT ----------------
  Future<void> importFromCSV() async {
    // Implement CSV import functionality
    Get.snackbar(
      "Import",
      "CSV import feature coming soon",
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  Future<void> exportToCSV() async {
    // Implement CSV export functionality
    Get.snackbar(
      "Export",
      "CSV export feature coming soon",
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  @override
  void onClose() {
    // Clean up resources
    super.onClose();
  }
 }