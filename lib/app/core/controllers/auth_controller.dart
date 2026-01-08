// //
// // import 'dart:convert';
// // import 'package:get/get.dart';
// // import 'package:http/http.dart' as http;
// // import 'package:get_storage/get_storage.dart';
// //
// // import '../../data/models/loginresponsemodel.dart';
// // import '../../routes/app_pages.dart';
// //
// // class AuthController extends GetxController {
// //   static AuthController get to => Get.find();
// //   final box = GetStorage();
// //   var isLoading = false.obs;
// //   var isProfileLoading = true.obs;
// //
// //   var token = ''.obs;
// //   var firstName = ''.obs;
// //   var lastName = ''.obs;
// //   var phoneNumber = ''.obs;
// //   var address = ''.obs;
// //   var email = ''.obs;
// //
// //   @override
// //   void onInit() {
// //     super.onInit();
// //     token.value = box.read('token') ?? '';
// //
// //     final savedProfile = box.read('userProfile');
// //     if (savedProfile != null) {
// //       _loadProfileFromStorage(savedProfile);
// //     }
// //
// //     if (token.value.isNotEmpty) {
// //       fetchUserProfile(); // Fetch latest userlogin data from API
// //     } else {
// //       isProfileLoading.value = false; // Not logged in
// //     }
// //   }
// //
// //   Future<void> login(String username, String password) async {
// //     isLoading.value = true;
// //
// //     try {
// //       final response = await http.post(
// //         Uri.parse('https://dummyjson.com/auth/login'),
// //         headers: {'Content-Type': 'application/json'},
// //         body: jsonEncode({'username': username, 'password': password}),
// //       );
// //
// //       if (response.statusCode == 200) {
// //         final data = jsonDecode(response.body);
// //         final loginResponse = LoginResponse.fromJson(data);
// //         token.value = loginResponse.accessToken;
// //
// //         if (token.value.isNotEmpty) {
// //           box.write('token', token.value);
// //           box.write('isFirstTime', false);
// //           await fetchUserProfile(); // Load userlogin profile
// //           Get.offNamed(Routes.LANDING);
// //         } else {
// //           Get.snackbar('Login Error', 'Access token not found in response');
// //         }
// //       } else {
// //         Get.snackbar('Login Failed', 'Invalid username or password');
// //       }
// //     } catch (e) {
// //       Get.snackbar('Error', 'Something went wrong: $e');
// //     }
// //
// //     isLoading.value = false;
// //   }
// //
// //   Future<void> fetchUserProfile() async {
// //     isProfileLoading.value = true;
// //
// //     try {
// //       final response = await http.get(
// //         Uri.parse('https://dummyjson.com/auth/me'),
// //         headers: {
// //           'Content-Type': 'application/json',
// //           'Authorization': 'Bearer ${token.value}',
// //         },
// //       );
// //
// //       if (response.statusCode == 200) {
// //         final data = jsonDecode(response.body);
// //
// //         firstName.value = data['firstName'] ?? '';
// //         lastName.value = data['lastName'] ?? '';
// //         phoneNumber.value = data['phone'] ?? '';
// //         email.value = data['email'] ?? '';
// //
// //         final userAddress = data['address'];
// //         if (userAddress != null) {
// //           address.value =
// //           '${userAddress['address']}, ${userAddress['city']}, ${userAddress['state']} ${userAddress['postalCode']}';
// //         } else {
// //           address.value = '';
// //         }
// //
// //         // Save profile data locally
// //         box.write('userProfile', data);
// //       } else {
// //         Get.snackbar('Error', 'Failed to fetch userlogin profile');
// //       }
// //     } catch (e) {
// //       Get.snackbar('Error', 'Error fetching profile: $e');
// //     }
// //
// //     isProfileLoading.value = false;
// //   }
// //
// //   void _loadProfileFromStorage(Map<String, dynamic> data) {
// //     firstName.value = data['firstName'] ?? '';
// //     lastName.value = data['lastName'] ?? '';
// //     phoneNumber.value = data['phone'] ?? '';
// //     email.value = data['email'] ?? '';
// //
// //     final userAddress = data['address'];
// //     if (userAddress != null) {
// //       address.value =
// //       '${userAddress['address']}, ${userAddress['city']}, ${userAddress['state']} ${userAddress['postalCode']}';
// //     } else {
// //       address.value = '';
// //     }
// //   }
// //
// //   void logout() {
// //     token.value = '';
// //     box.remove('token');
// //     box.remove('userProfile');
// //     box.write('isFirstTime', true);
// //
// //     firstName.value = '';
// //     lastName.value = '';
// //     phoneNumber.value = '';
// //     address.value = '';
// //     email.value = '';
// //     isProfileLoading.value = false;
// //
// //     Get.offAllNamed(Routes.LOGIN);
// //   }
// //
// //   bool get isLoggedIn => token.value.isNotEmpty;
// // }
// import 'dart:convert';
// import 'package:get/get.dart';
// import 'package:http/http.dart' as http;
// import '../../common/storage/storage.dart';
// import '../../data/models/loginresponsemodel.dart';
// import '../../routes/app_pages.dart';
//
// class AuthController extends GetxController {
//   static AuthController get to => Get.find();
//
//   var isLoading = false.obs;
//   var isProfileLoading = true.obs;
//   var token = ''.obs;
//   var firstName = ''.obs;
//   var lastName = ''.obs;
//   var phoneNumber = ''.obs;
//   var address = ''.obs;
//   var email = ''.obs;
//
//   @override
//   void onInit() {
//     super.onInit();
//     token.value = Storage.getValue<String>('token') ?? '';
//
//     final savedProfile = Storage.getValue<Map<String, dynamic>>('userProfile');
//     if (savedProfile != null) {
//       _loadProfileFromStorage(savedProfile);
//
//     }
//
//     if (token.value.isNotEmpty) {
//       fetchUserProfile(); // Fetch latest userlogin data from API
//     } else {
//       isProfileLoading.value = false; // Not logged in
//     }
//   }
//
//   Future<void> login(String username, String password) async {
//     isLoading.value = true;
//
//     try {
//       final response = await http.post(
//         Uri.parse('https://dummyjson.com/auth/login'),
//         headers: {'Content-Type': 'application/json'},
//         body: jsonEncode({'username': username, 'password': password}),
//       );
//
//       if (response.statusCode == 200) {
//         final data = jsonDecode(response.body);
//         final loginResponse = LoginResponse.fromJson(data);
//         token.value = loginResponse.accessToken;
//
//         if (token.value.isNotEmpty) {
//           await Storage.saveValueForce('token', token.value);
//           await Storage.saveValueForce('isFirstTime', false);
//
//           await fetchUserProfile(); // Load userlogin profile
//           Get.offNamed(Routes.LANDING);
//         } else {
//           Get.snackbar('Login Error', 'Access token not found in response');
//         }
//       } else {
//         Get.snackbar('Login Failed', 'Invalid username or password');
//       }
//     } catch (e) {
//       Get.snackbar('Error', 'Something went wrong: $e');
//     }
//
//     isLoading.value = false;
//   }
//
//   Future<void> fetchUserProfile() async {
//     isProfileLoading.value = true;
//
//     try {
//       final response = await http.get(
//         Uri.parse('https://dummyjson.com/auth/me'),
//         headers: {
//           'Content-Type': 'application/json',
//           'Authorization': 'Bearer ${token.value}',
//         },
//       );
//
//       if (response.statusCode == 200) {
//         final data = jsonDecode(response.body);
//
//         firstName.value = data['firstName'] ?? '';
//         lastName.value = data['lastName'] ?? '';
//         phoneNumber.value = data['phone'] ?? '';
//         email.value = data['email'] ?? '';
//
//         final userAddress = data['address'];
//         if (userAddress != null) {
//           address.value =
//           '${userAddress['address']}, ${userAddress['city']}, ${userAddress['state']} ${userAddress['postalCode']}';
//         } else {
//           address.value = '';
//         }
//
//         await Storage.saveValueForce('userProfile', data);
//       } else {
//         Get.snackbar('Error', 'Failed to fetch userlogin profile');
//       }
//     } catch (e) {
//       Get.snackbar('Error', 'Error fetching profile: $e');
//     }
//
//     isProfileLoading.value = false;
//   }
//
//   void _loadProfileFromStorage(Map<String, dynamic> data) {
//     firstName.value = data['firstName'] ?? '';
//     lastName.value = data['lastName'] ?? '';
//     phoneNumber.value = data['phone'] ?? '';
//     email.value = data['email'] ?? '';
//
//     final userAddress = data['address'];
//     if (userAddress != null) {
//       address.value =
//       '${userAddress['address']}, ${userAddress['city']}, ${userAddress['state']} ${userAddress['postalCode']}';
//     } else {
//       address.value = '';
//     }
//   }
//
//   void logout() async {
//     token.value = '';
//     await Storage.removeValue('token');
//     await Storage.removeValue('userProfile');
//     await Storage.saveValueForce('isFirstTime', true);
//
//     firstName.value = '';
//     lastName.value = '';
//     phoneNumber.value = '';
//     address.value = '';
//     email.value = '';
//     isProfileLoading.value = false;
//
//     Get.offAllNamed(Routes.LOGIN);
//   }
//
//   bool get isLoggedIn => token.value.isNotEmpty;
// }
