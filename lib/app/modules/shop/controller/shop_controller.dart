// // bakery_detail_controller.dart
// import 'dart:io';
// import 'package:get/get.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:url_launcher/url_launcher.dart';
//
// class Product {
//   final String id;
//   final String name;
//   final String image; // file path or network URL
//   final double price;
//
//   Product({required this.id, required this.name, required this.image, required this.price});
// }
//
// class BakeryDetailController extends GetxController {
//   // Shop basic info (can be updated from API)
//   RxString title = 'City Bakery'.obs;
//   RxString address = 'Test address'.obs;
//   RxString phone1 = '9207255558'.obs;
//   RxString phone2 = '9656325896'.obs;
//   RxString website = 'www.example.com'.obs;
//   RxString email = 'dch@example.com'.obs;
//   RxString headerImage = 'assets/images/products/citybakers.jpg'.obs; // keep as asset or url
//
//   // Gallery images (merchant uploaded). Use absolute file paths or network URLs.
//   // By default we include some sample asset/image paths. Replace with your real data.
//   RxList<String> galleryImages = <String>[
//     'assets/images/products/bread.jpg',
//     'assets/images/products/cake.jpg',
//     'assets/images/products/donut.jpg',
//   ].obs;
//
//   // Products list (sample data)
//   RxList<Product> products = <Product>[
//     Product(id: 'p1', name: 'Bread', image: 'assets/images/products/bread.jpg', price: 35.0),
//     Product(id: 'p2', name: 'Chocolate Cake', image: 'assets/images/products/cake.jpg', price: 450.0),
//     Product(id: 'p3', name: 'Donut', image: 'assets/images/products/donut.jpg', price: 25.0),
//     Product(id: 'p4', name: 'Biscuit', image: 'assets/images/products/biscuit.jpg', price: 20.0),
//   ].obs;
//
//   // Shop location (latitude & longitude)
//   RxDouble latitude = 0.0.obs;
//   RxDouble longitude = 0.0.obs;
//
//   // Set location (merchant uses location picker to set this)
//   void setLocation(double lat, double lng) {
//     latitude.value = lat;
//     longitude.value = lng;
//   }
//
//   // Open Google Maps navigation for customers
//   Future<void> openInMaps() async {
//     if (latitude.value == 0.0 && longitude.value == 0.0) {
//       Get.snackbar('Location', 'Shop location not provided.');
//       return;
//     }
//
//     final url = Uri.parse('https://www.google.com/maps/dir/?api=1&destination=${latitude.value},${longitude.value}&travelmode=driving');
//     if (await canLaunchUrl(url)) {
//       await launchUrl(url);
//     } else {
//       Get.snackbar('Error', 'Could not open Google Maps.');
//     }
//   }
//
//   // Convenience: open phone/app/email/website
//   Future<void> callPhone(String number) async {
//     final uri = Uri.parse('tel:$number');
//     if (await canLaunchUrl(uri)) await launchUrl(uri);
//   }
//
//   Future<void> openWebsite(String url) async {
//     final uri = Uri.parse(url.startsWith('http') ? url : 'https://$url');
//     if (await canLaunchUrl(uri)) await launchUrl(uri);
//   }
//
//   Future<void> sendEmail(String to) async {
//     final uri = Uri.parse('mailto:$to');
//     if (await canLaunchUrl(uri)) await launchUrl(uri);
//   }
//
//   // Optional helper: replace galleryImages (for merchant upload flow)
//   void replaceGallery(List<String> newImages) {
//     galleryImages.assignAll(newImages);
//   }
//
//   // Optional helper: add a single image path
//   void addGalleryImage(String path) {
//     galleryImages.add(path);
//   }
//
//   // Optional helper: remove image by index
//   void removeGalleryImageAt(int index) {
//     if (index >= 0 && index < galleryImages.length) galleryImages.removeAt(index);
//   }
// }
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
