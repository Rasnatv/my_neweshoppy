import 'package:get/get.dart';

class RestaurantBookingController extends GetxController {
  var seating = "Indoor".obs; // Indoor/Outdoor
  var guests = 1.obs;          // Number of guests
  var selectedDate = DateTime.now().obs;
  var selectedTimeSlot = "".obs; // Time slot string
  var selectedTable = "".obs;    // Table number or name

  // Sample time slots
  List<String> timeSlots = [
    "10:00 AM", "11:00 AM", "12:00 PM",
    "01:00 PM", "02:00 PM", "03:00 PM",
    "07:00 PM", "08:00 PM", "09:00 PM"
  ];

  // Tables per guests (example)
  Map<int, List<String>> tableNumbers = {
    1: ["T1", "T2", "T3"],
    2: ["T4", "T5", "T6"],
    3: ["T7", "T8", "T9"],
    4: ["T10", "T11", "T12"],
    5: ["T13", "T14"],
    6: ["T15", "T16"]
  };
}
