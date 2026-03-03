
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../common/style/app_colors.dart';
import '../../../common/style/app_text_style.dart';
import '../controller/restaurantbooking_controller.dart';


class RestaurantBookingPage extends StatelessWidget {
  RestaurantBookingPage({super.key});

  final RestaurantBookingController controller = Get.put(RestaurantBookingController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        title:  Text("Book Your Table",style:AppTextStyle.rTextNunitoWhite17w700),
        backgroundColor: AppColors.kPrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// ---------------- Seating Selection ----------------
            const Text("Seating", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Obx(() => Row(
              children: ["Indoor", "Outdoor"].map((type) {
                bool isSelected = controller.seating.value == type;
                return Expanded(
                  child: GestureDetector(
                    onTap: () => controller.seating.value = type,
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: isSelected ? AppColors.kPrimary : Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      alignment: Alignment.center,
                      child: Text(type,
                          style: TextStyle(
                              color: isSelected ? Colors.white : Colors.black,
                              fontWeight: FontWeight.bold)),
                    ),
                  ),
                );
              }).toList(),
            )),
            const SizedBox(height: 16),

            const Text("Number of Guests", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Obx(() => Row(
              children: [
                IconButton(
                  onPressed: () {
                    if (controller.guests.value > 1) controller.guests.value--;
                  },
                  icon: const Icon(Icons.remove),
                ),
                Text(controller.guests.value.toString(), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                IconButton(
                  onPressed: () {
                    if (controller.guests.value < 6) controller.guests.value++;
                  },
                  icon: const Icon(Icons.add),
                ),
              ],
            )),
            const SizedBox(height: 16),

            /// ---------------- Date Selection ----------------
            const Text("Select Date", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Obx(() => GestureDetector(
              onTap: () async {
                DateTime? picked = await showDatePicker(
                  context: context,
                  initialDate: controller.selectedDate.value,
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now().add(const Duration(days: 365)),
                );
                if (picked != null) controller.selectedDate.value = picked;
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("${controller.selectedDate.value.toLocal()}".split(' ')[0]),
                    const Icon(Icons.calendar_today, size: 18),
                  ],
                ),
              ),
            )),
            const SizedBox(height: 16),

            /// ---------------- Time Slot ----------------
            const Text("Select Time Slot", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Obx(() => Wrap(
              spacing: 8,
              runSpacing: 8,
              children: controller.timeSlots.map((slot) {
                bool isSelected = controller.selectedTimeSlot.value == slot;
                return GestureDetector(
                  onTap: () => controller.selectedTimeSlot.value = slot,
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.teal : Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(slot,
                        style: TextStyle(color: isSelected ? Colors.white : Colors.black)),
                  ),
                );
              }).toList(),
            )),
            const SizedBox(height: 16),

            /// ---------------- Table Selection ----------------
            const Text("Select Table", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Obx(() {
              int g = controller.guests.value;
              List<String> tables = controller.tableNumbers[g] ?? [];
              return Wrap(
                spacing: 8,
                runSpacing: 8,
                children: tables.map((t) {
                  bool isSelected = controller.selectedTable.value == t;
                  return GestureDetector(
                    onTap: () => controller.selectedTable.value = t,
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                      decoration: BoxDecoration(
                        color: isSelected ? Colors.teal : Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(t, style: TextStyle(color: isSelected ? Colors.white : Colors.black)),
                    ),
                  );
                }).toList(),
              );
            }),
            const SizedBox(height: 24),
          ],
        ),
      ),
      bottomNavigationBar: Padding(padding: EdgeInsets.all(20),
        child:SizedBox(width: double.infinity,child:
        ElevatedButton(
          onPressed: () {
            if (controller.selectedTimeSlot.value.isEmpty || controller.selectedTable.value.isEmpty) {
              Get.snackbar("Error", "Please select time slot and table",
                  backgroundColor: Colors.red, colorText: Colors.white);
              return;
            }
            Get.snackbar("Booked",
                "Table ${controller.selectedTable.value} booked for ${controller.guests.value} guests on ${controller.selectedDate.value.toLocal().toString().split(' ')[0]} at ${controller.selectedTimeSlot.value}",
                backgroundColor: Colors.teal, colorText: Colors.white);
          },
          child: const Text("Confirm Booking", style: TextStyle(color: Colors.white, fontSize: 16)),
        ),),
      ),

    );
  }
}
