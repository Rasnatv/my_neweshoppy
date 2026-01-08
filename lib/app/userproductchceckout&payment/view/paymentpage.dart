import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PaymentController extends GetxController {
  var selectedPayment = ''.obs;

  void selectPayment(String method) {
    selectedPayment.value = method;
  }
}

class PaymentPage extends StatelessWidget {
  final PaymentController controller = Get.put(PaymentController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Payment Options'), backgroundColor: Colors.teal),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Text('Select Payment Method', style: TextStyle(fontSize: 22)),
            SizedBox(height: 20),

            // Cash on Delivery Option
            Obx(() => Card(
              color: controller.selectedPayment.value == 'COD'
                  ? Colors.teal[100]
                  : Colors.white,
              child: ListTile(
                leading: Icon(Icons.money),
                title: Text('Cash on Delivery'),
                trailing: Radio<String>(
                  value: 'COD',
                  groupValue: controller.selectedPayment.value,
                  onChanged: (value) => controller.selectPayment(value!),
                ),
                onTap: () => controller.selectPayment('COD'),
              ),
            )),
            SizedBox(height: 10),

            // UPI Payment Option
            Obx(() => Card(
              color: controller.selectedPayment.value == 'UPI'
                  ? Colors.teal[100]
                  : Colors.white,
              child: ListTile(
                leading: Icon(Icons.payment),
                title: Text('UPI Payment'),
                trailing: Radio<String>(
                  value: 'UPI',
                  groupValue: controller.selectedPayment.value,
                  onChanged: (value) => controller.selectPayment(value!),
                ),
                onTap: () => controller.selectPayment('UPI'),
              ),
            )),
            SizedBox(height: 30),

            // Pay / Confirm Button
            Obx(() => ElevatedButton(
              onPressed: controller.selectedPayment.value.isNotEmpty
                  ? () {
                if (controller.selectedPayment.value == 'COD') {
                  Get.snackbar('Success', 'Order placed with Cash on Delivery',
                      snackPosition: SnackPosition.BOTTOM);
                } else {
                  Get.snackbar('Success', 'Payment completed via UPI',
                      snackPosition: SnackPosition.BOTTOM);
                }
              }
                  : null,
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  padding: EdgeInsets.symmetric(vertical: 16, horizontal: 40)),
              child: Text(
                'Confirm Payment',
                style: TextStyle(fontSize: 18),
              ),
            )),
          ],
        ),
      ),
    );
  }
}
