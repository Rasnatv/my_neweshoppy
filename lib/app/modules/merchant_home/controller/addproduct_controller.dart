//
// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:image_picker/image_picker.dart';
//
// class ProductController extends GetxController {
//   // ---------------- BASIC FIELDS ----------------
//   final TextEditingController productName = TextEditingController();
//   final TextEditingController price = TextEditingController();
//   final TextEditingController discountPercentage = TextEditingController();
//   final TextEditingController stockQuantity = TextEditingController();
//
//
//   // ---------------- STOCK STATUS ----------------
//   RxString stockStatus = "".obs;
//   void setStockStatus(String? val) => stockStatus.value = val ?? "";
//
//   // ---------------- FEATURES ----------------
//   RxList<TextEditingController> features = <TextEditingController>[].obs;
//
//   void addFeature() {
//     if (features.length >= 5) {
//       Get.snackbar("Limit Reached", "Maximum 5 features allowed");
//       return;
//     }
//     features.add(TextEditingController());
//   }
//
//   void removeFeature(int index) {
//     if (index < 0 || index >= features.length) return;
//     features[index].dispose();
//     features.removeAt(index);
//   }
//
//   // ---------------- CATEGORY ----------------
//   final List<String> productCategories = [
//     "Fashion & Apparel",
//     "Beauty & Personal Care",
//     "Electronics",
//     "Grocery & Essentials",
//     "Bakery & Food",
//     "Home Appliances",
//     "Furniture",
//     "Sports & Fitness",
//     "Kids Products",
//     "Pet Supplies",
//     "Automobile & Accessories",
//     "Medicine & Healthcare",
//     "Home & Kitchen",
//     "Tools & Hardware",
//   ];
//
//   RxString selectedCategory = "".obs;
//
//   final Map<String, List<String>> categoryAttributes = {
//     "Fashion & Apparel": ["Size", "Color", "Material", "Brand", "Fit", "Pattern", "Other"],
//     "Beauty & Personal Care": ["Shade", "Skin Type", "Hair Type", "Ingredients", "Brand", "Volume", "Other"],
//     "Electronics": ["Brand", "Model", "RAM", "Storage", "Battery", "Warranty", "Screen Size", "Other"],
//     "Grocery & Essentials": ["Weight", "Brand", "Expiry Date", "Package Type", "Organic", "Other"],
//     "Bakery & Food": ["Weight / Quantity", "Flavor / Type", "Ingredients", "Expiry Date", "Brand", "Allergen Info", "Packaging Type", "Other"],
//     "Home Appliances": ["Brand", "Model", "Power", "Capacity", "Warranty", "Other"],
//     "Furniture": ["Material", "Color", "Size", "Brand", "Weight", "Style", "Other"],
//     "Sports & Fitness": ["Size", "Material", "Brand", "Weight", "Capacity", "Other"],
//     "Kids Products": ["Age Group", "Material", "Brand", "Safety Info", "Other"],
//     "Pet Supplies": ["Pet Type", "Weight", "Ingredients", "Age Group", "Brand", "Other"],
//     "Automobile & Accessories": ["Vehicle Type", "Model", "Brand", "Year", "Part Type", "Other"],
//     "Medicine & Healthcare": ["Medicine Type", "Dosage", "Expiry Date", "Composition", "Brand", "Other"],
//     "Home & Kitchen": ["Material", "Brand", "Size", "Capacity", "Other"],
//     "Tools & Hardware": ["Material", "Brand", "Size", "Power", "Other"],
//   };
//
//   // ---------------- VARIANT ATTRIBUTES ----------------
//   final Map<String, List<String>> categoryVariantAttributes = {
//     "Fashion & Apparel": ["Size", "Color", "Pattern", "Fit"],
//     "Beauty & Personal Care": ["Shade", "Volume"],
//     "Electronics": ["RAM", "Storage"],
//     "Grocery & Essentials": ["Weight"],
//     "Bakery & Food": ["Weight / Quantity", "Flavor / Type"],
//     "Home Appliances": ["Capacity", "Power"],
//     "Furniture": ["Size", "Color"],
//     "Sports & Fitness": ["Size", "Weight", "Capacity"],
//     "Kids Products": ["Age Group"],
//     "Pet Supplies": ["Weight", "Age Group"],
//     "Automobile & Accessories": [],
//     "Medicine & Healthcare": ["Dosage"],
//     "Home & Kitchen": ["Size", "Capacity"],
//     "Tools & Hardware": ["Size", "Power"],
//   };
//
//   // ---------------- ATTRIBUTE VALUE SUGGESTIONS ----------------
//   final Map<String, List<String>> attributeValueSuggestions = {
//     "Size": ["S", "M", "L", "XL", "XXL"],
//     "Color": ["Red", "Blue", "Green", "Black", "White"],
//     "Weight": ["250g", "500g", "1kg", "2kg"],
//     "Shade": ["Light", "Medium", "Dark"],
//     "Volume": ["50ml", "100ml", "250ml", "500ml"],
//     "Capacity": ["1L", "2L", "5L"],
//     "Fit": ["Regular", "Slim", "Loose"],
//     "Pattern": ["Solid", "Striped", "Floral"],
//     "Age Group": ["0-2", "3-5", "6-9", "10+"],
//     "Power": ["100W", "200W", "500W"],
//     "RAM": ["2GB", "4GB", "6GB", "8GB"],
//   };
//
//   // ---------------- ATTRIBUTE ROWS ----------------
//   RxList<Map<String, dynamic>> attributes = <Map<String, dynamic>>[].obs;
//
//   void addAttributeRow() {
//     if (attributes.length >= 10) {
//       Get.snackbar("Limit Reached", "Maximum 10 attributes allowed");
//       return;
//     }
//
//     attributes.add({
//       "selected": "",
//       "isOther": false,
//       "isVariant": false,
//       "name": TextEditingController(),
//       "value": TextEditingController(),
//       "values": <String>[],
//     });
//   }
//
//   void removeAttributeRow(int index) {
//     if (index < 0 || index >= attributes.length) return;
//     try {
//       (attributes[index]["name"] as TextEditingController).dispose();
//       (attributes[index]["value"] as TextEditingController).dispose();
//     } catch (_) {}
//     attributes.removeAt(index);
//   }
//
//   void onAttributeSelected(int index, String? val) {
//     if (index < 0 || index >= attributes.length) return;
//     final row = attributes[index];
//     row["selected"] = val ?? "";
//     row["isOther"] = (val == "Other");
//     final variants = categoryVariantAttributes[selectedCategory.value] ?? [];
//     row["isVariant"] = variants.contains(val);
//     row["name"] ??= TextEditingController();
//     row["value"] ??= TextEditingController();
//     row["values"] ??= <String>[];
//     attributes.refresh();
//   }
//
//   void addVariantValue(int index, String value) {
//     if (index < 0 || index >= attributes.length) return;
//     final List<String> values = attributes[index]["values"] as List<String>;
//     if (!values.contains(value.trim())) {
//       values.add(value.trim());
//       attributes.refresh();
//     }
//   }
//
//   void removeVariantValue(int index, String value) {
//     if (index < 0 || index >= attributes.length) return;
//     final List<String> values = attributes[index]["values"] as List<String>;
//     values.remove(value);
//     attributes.refresh();
//   }
//
//   // ---------------- IMAGE ----------------
//   final ImagePicker picker = ImagePicker();
//   Rx<File?> productImage = Rx<File?>(null);
//
//   Future<void> pickSingleImage() async {
//     final XFile? picked = await picker.pickImage(source: ImageSource.gallery);
//     if (picked != null) productImage.value = File(picked.path);
//   }
//
//   void removeImage() => productImage.value = null;
//
//   // ---------------- SUBMIT PRODUCT ----------------
//   void addProduct() {
//     if (productName.text.isEmpty ||
//         selectedCategory.value.isEmpty ||
//         price.text.isEmpty ||
//         stockStatus.value.isEmpty ||
//         productImage.value == null) {
//       Get.snackbar("Missing Fields", "Please fill all required fields");
//       return;
//     }
//
//     List<Map<String, dynamic>> finalAttributes = [];
//     for (var attr in attributes) {
//       final isOther = attr["isOther"] as bool;
//       final isVariant = attr["isVariant"] as bool;
//       String title = isOther
//           ? (attr["name"] as TextEditingController).text.trim()
//           : (attr["selected"] as String).trim();
//
//       if (isVariant) {
//         final vals = List<String>.from(attr["values"] as List);
//         if (title.isNotEmpty && vals.isNotEmpty) {
//           finalAttributes.add({"name": title, "values": vals});
//         }
//       } else {
//         final val = (attr["value"] as TextEditingController).text.trim();
//         if (title.isNotEmpty && val.isNotEmpty) {
//           finalAttributes.add({"name": title, "value": val});
//         }
//       }
//     }
//
//     final productData = {
//       "name": productName.text.trim(),
//       "price": price.text.trim(),
//       "discount": discountPercentage.text.trim(),
//       "stockStatus": stockStatus.value,
//       "category": selectedCategory.value,
//       "attributes": finalAttributes,
//       "imagePath": productImage.value?.path,
//     };
//
//     debugPrint("PRODUCT_PAYLOAD: $productData");
//     Get.snackbar("Success", "Product added successfully");
//     _clearForm();
//   }
//
//   void _clearForm() {
//     productName.clear();
//     price.clear();
//     discountPercentage.clear();
//     stockStatus.value = "";
//     selectedCategory.value = "";
//     productImage.value = null;
//
//     for (var f in features) f.dispose();
//     features.clear();
//
//     for (var a in attributes) {
//       try {
//         (a["name"] as TextEditingController).dispose();
//         (a["value"] as TextEditingController).dispose();
//       } catch (_) {}
//     }
//     attributes.clear();
//   }
//
//   @override
//   void onClose() {
//     try {
//       productName.dispose();
//       price.dispose();
//       discountPercentage.dispose();
//       for (var f in features) f.dispose();
//       for (var a in attributes) {
//         try {
//           (a["name"] as TextEditingController).dispose();
//           (a["value"] as TextEditingController).dispose();
//         } catch (_) {}
//       }
//     } catch (_) {}
//     super.onClose();
//   }
// }
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AddProductController extends GetxController {
  // Text controllers
  final productName = TextEditingController();
  final description = TextEditingController();
  final price = TextEditingController();
  final offerPrice = TextEditingController();
  final stock = TextEditingController();

  // Observables
  var categories = [].obs;
  var subcategories = [].obs;
  var selectedCategory = Rxn<int>();
  var selectedSubCategory = Rxn<int>();
  var isVariantProduct = false.obs;
  var selectedImages = <File>[].obs;
  var isLoading = false.obs;

  // Pick images
  Future pickImages() async {
    final ImagePicker picker = ImagePicker();
    final picked = await picker.pickMultiImage();
    if (picked.isNotEmpty) {
      selectedImages.value = picked.map((e) => File(e.path)).toList();
    }
  }

  // Fetch categories from API
  Future fetchCategories() async {
    final url = Uri.parse("https://rasma.astradevelops.in/e_shoppyy/public/api/categories");
    final res = await http.get(url);
    if (res.statusCode == 200) {
      categories.value = json.decode(res.body)['data'];
    }
  }

  // Fetch subcategories based on category
  Future fetchSubCategories(int categoryId) async {
    final url = Uri.parse("https://rasma.astradevelops.in/e_shoppyy/public/api/categories/$categoryId/subcategories");
    final res = await http.get(url);
    if (res.statusCode == 200) {
      subcategories.value = json.decode(res.body)['data'];
    }
  }

  // Submit product (basic/simple version)
  Future submitProduct() async {
    if (productName.text.isEmpty || selectedCategory.value == null) {
      Get.snackbar("Error", "Please fill required fields");
      return;
    }

    isLoading(true);

    final uri = Uri.parse("https://rasma.astradevelops.in/e_shoppyy/public/api/merchant/add-product");
    var request = http.MultipartRequest('POST', uri);

    request.fields.addAll({
      'product_name': productName.text,
      'category_id': selectedCategory.value.toString(),
      'sub_category_id': selectedSubCategory.value?.toString() ?? '',
      'price': price.text,
      'offer_price': offerPrice.text,
      'stock': stock.text,
      'description': description.text,
      'type': isVariantProduct.value ? 'variant' : 'simple'
    });

    // Upload images
    for (var img in selectedImages) {
      request.files.add(await http.MultipartFile.fromPath('images[]', img.path));
    }

    final res = await request.send();
    isLoading(false);

    if (res.statusCode == 200) {
      Get.back();
      Get.snackbar("Success", "Product added successfully!");
    } else {
      Get.snackbar("Error", "Failed to add product (${res.statusCode})");
    }
  }

  @override
  void onInit() {
    super.onInit();
    fetchCategories();
  }
}
