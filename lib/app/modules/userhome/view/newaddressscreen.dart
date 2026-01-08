
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../common/style/app_colors.dart';
import '../../../common/style/app_text_style.dart';

class AddAddressPage extends StatelessWidget {
  AddAddressPage({super.key});

  final TextEditingController nameCtrl = TextEditingController();
  final TextEditingController phoneCtrl = TextEditingController();
  final TextEditingController pincodeCtrl = TextEditingController();
  final TextEditingController stateCtrl = TextEditingController();
  final TextEditingController districtCtrl = TextEditingController();
  final TextEditingController cityCtrl = TextEditingController();
  final TextEditingController houseCtrl = TextEditingController();
  final TextEditingController roadCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.kPrimary,
        title:  Text("Add New Address",style:AppTextStyle.rTextNunitoWhite17w700),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _tf("Full Name", nameCtrl),
            _tf("Phone Number", phoneCtrl,
                keyboard: TextInputType.phone),
            _tf("Pincode", pincodeCtrl,
                keyboard: TextInputType.number),
            _tf("State", stateCtrl),
            _tf("District", districtCtrl),
            _tf("City", cityCtrl),
            _tf("House No / Building Name", houseCtrl),
            _tf("Road / Area / Colony", roadCtrl, maxLines: 2),

            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Dummy save
                  Get.back();
                  Get.snackbar(
                    "Success",
                    "Address saved successfully",
                    backgroundColor: Colors.green,
                    colorText: Colors.white,
                  );
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: const Text(
                  "Save Address",
                  style: TextStyle(fontSize: 16),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  // TEXT FIELD WIDGET
  Widget _tf(
      String label,
      TextEditingController controller, {
        int maxLines = 1,
        TextInputType keyboard = TextInputType.text,
      }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: TextField(
        controller: controller,
        keyboardType: keyboard,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}
