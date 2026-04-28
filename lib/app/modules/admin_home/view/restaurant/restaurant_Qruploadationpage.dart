import 'dart:io';
import 'package:eshoppy/app/widgets/networkconnection_checkpage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class RestaurantRegisterPage extends StatefulWidget {
  const RestaurantRegisterPage({super.key});

  @override
  State<RestaurantRegisterPage> createState() =>
      _RestaurantRegisterPageState();
}

class _RestaurantRegisterPageState extends State<RestaurantRegisterPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController upiController = TextEditingController();

  File? qrImage;

  Future<void> pickImage() async {
    final picked =
    await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        qrImage = File(picked.path);
      });
    }
  }

  void submit() {
    String name = nameController.text.trim();
    String upi = upiController.text.trim();

    if (name.isEmpty || upi.isEmpty || qrImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill all fields")),
      );
      return;
    }

    // 👉 API call here
    print("Name: $name");
    print("UPI: $upi");
    print("QR: ${qrImage!.path}");
  }

  @override
  Widget build(BuildContext context) {
    return NetworkAwareWrapper(child: Scaffold(
      appBar: AppBar(
        title: const Text("Register Restaurant"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🏷️ Title
            const Text(
              "Restaurant Details",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 20),

            // 🍽️ Restaurant Name
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: "Restaurant Name",
                prefixIcon: const Icon(Icons.restaurant),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // 💳 UPI ID
            TextField(
              controller: upiController,
              decoration: InputDecoration(
                labelText: "UPI ID",
                hintText: "example@upi",
                prefixIcon: const Icon(Icons.account_balance_wallet),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // 📷 QR Upload
            const Text(
              "Upload QR Code",
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 10),

            GestureDetector(
              onTap: pickImage,
              child: Container(
                height: 150,
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: qrImage == null
                    ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.upload, size: 40, color: Colors.grey),
                    SizedBox(height: 8),
                    Text("Tap to upload QR code"),
                  ],
                )
                    : ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.file(qrImage!, fit: BoxFit.cover),
                ),
              ),
            ),

            const SizedBox(height: 30),

            // 🚀 Submit Button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: submit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  "Register",
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    ));
  }
}