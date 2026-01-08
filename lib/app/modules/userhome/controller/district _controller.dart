// import 'package:get/get.dart';
//
// class DistrictController extends GetxController {
//   final List<String> districtList = [
//     "Thiruvananthapuram",
//     "Kollam",
//     "Pathanamthitta",
//     "Alappuzha",
//     "Kottayam",
//     "Idukki",
//     "Ernakulam",
//     "Thrissur",
//     "Palakkad",
//     "Malappuram",
//     "Kozhikode",
//     "Wayanad",
//     "Kannur",
//     "Kasaragod",
//   ];
//
//   // DEFAULT selected district
//   RxString selectedDistrict = "Kasaragod".obs;
//
//   void updateDistrict(String value) {
//     selectedDistrict.value = value;
//   }
// }
import 'package:get/get.dart';

class DistrictController extends GetxController {
  RxString selectedDistrict = "Kasargod".obs;

  RxString selectedState = "Kerala".obs;
  RxString userLocation = "".obs;

  final List<String> stateList = ["Kerala"];
  final List<String> districtList = [
    "Kasargod",
    "Kannur",
    "Kozhikode",
    "Thrissur",
    "Ernakulam",
    "Trivandrum"
  ];

  void updateState(String value) {
    selectedState.value = value;
  }

  void updateDistrict(String value) {
    selectedDistrict.value = value;
  }

  void updateUserLocation(String location) {
    userLocation.value = location;
  }
}
