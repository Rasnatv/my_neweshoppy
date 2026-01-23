
import 'dart:io';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class ShopDetailController extends GetxController {
  /// --------------------- MERCHANT LOCATION ---------------------
  /// Set your shop latitude & longitude here
  RxDouble latitude = 12.9716.obs;   // example latitude
  RxDouble longitude = 77.5946.obs;  // example longitude

  /// --------------------- GALLERY ---------------------
  RxList<File> galleryImages = <File>[].obs;
  final ImagePicker picker = ImagePicker();

  /// Pick image from gallery
  Future<void> pickFromGallery() async {
    try {
      final pickedFile = await picker.pickImage(source: ImageSource.gallery, imageQuality: 80);
      if (pickedFile != null) {
        galleryImages.add(File(pickedFile.path));
      }
    } catch (e) {
      print("Error picking image: $e");
    }
  }

  /// Capture image from camera
  Future<void> captureImage() async {
    try {
      final pickedFile = await picker.pickImage(source: ImageSource.camera, imageQuality: 80);
      if (pickedFile != null) {
        galleryImages.add(File(pickedFile.path));
      }
    } catch (e) {
      print("Error capturing image: $e");
    }
  }

  /// --------------------- PRODUCTS ---------------------
  /// Example product list (replace with API data)
  RxList<Map<String, dynamic>> products = <Map<String, dynamic>>[
    {
      'name': 'Chocolate Cake',
      'price': '₹350',
      'image': 'assets/images/products/cake.jpg'
    },
    {
      'name': 'Cup Cake',
      'price': '₹40',
      'image': 'assets/images/products/cupcake.jpg'
    },
    {
      'name': 'Bread Loaf',
      'price': '₹120',
      'image': 'assets/images/products/bread.jpg'
    },
    {
      'name': 'Cookies',
      'price': '₹25',
      'image': 'assets/images/products/cookies.jpg'
    },
  ].obs;

  /// Add a new product
  void addProduct(String name, String price, String imagePath) {
    products.add({'name': name, 'price': price, 'image': imagePath});
  }

  /// Remove product by index
  void removeProduct(int index) {
    if (index < products.length) products.removeAt(index);
  }
}
