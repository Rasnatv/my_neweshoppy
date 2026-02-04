
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../common/style/app_colors.dart';
import '../../../common/style/app_text_style.dart';
import '../../profile/controller/editprofile_controller.dart';


class EditProfilePage extends StatelessWidget {
  EditProfilePage({super.key});

  final EditProfileController controller =
  Get.find<EditProfileController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: Text(
          "Edit Profile",
          style: AppTextStyle.rTextNunitoWhite17w700,
        ),
        backgroundColor: AppColors.kPrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _profileAvatar(),
            const SizedBox(height: 24),
            _profileCard(),
            const SizedBox(height: 30),
            _saveButton(),
          ],
        ),
      ),
    );
  }

  Widget _profileAvatar() {
    return Obx(() {
      final apiImage = controller.profile.value?.profileImage ?? '';
      final picked = controller.selectedImage.value;

      ImageProvider imageProvider;

      if (picked != null) {
        imageProvider = FileImage(picked);
      } else if (apiImage.isNotEmpty) {
        imageProvider = NetworkImage(apiImage);
      } else {
        imageProvider = const AssetImage("assets/images/namsthe.png");
      }

      return Stack(
        alignment: Alignment.bottomRight,
        children: [
          CircleAvatar(
            radius: 55,
            backgroundImage: imageProvider,
          ),
          InkWell(
            onTap: controller.pickImage,
            child: CircleAvatar(
              radius: 18,
              backgroundColor: AppColors.kPrimary,
              child: const Icon(Icons.camera_alt,
                  size: 18, color: Colors.white),
            ),
          )
        ],
      );
    });
  }

  Widget _profileCard() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          children: [
            _field(controller.nameCtrl, "Full Name", Icons.person),
            const SizedBox(height: 16),
            _field(
              controller.emailCtrl,
              "Email",
              Icons.email,
              enabled: false,
            ),
            const SizedBox(height: 16),
            _field(controller.phoneCtrl, "Phone", Icons.phone),
            const SizedBox(height: 16),
            _field(
              controller.addressCtrl,
              "Address",
              Icons.location_on,
              maxLines: 2,
            ),
          ],
        ),
      ),
    );
  }

  Widget _saveButton() {
    return Obx(() {
      return SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.kPrimary,
            padding: const EdgeInsets.symmetric(vertical: 16),
          ),
          onPressed:
          controller.isLoading.value ? null : controller.updateProfile,
          child: controller.isLoading.value
              ? const CircularProgressIndicator(color: Colors.white)
              : const Text("Save Changes"),
        ),
      );
    });
  }

  Widget _field(
      TextEditingController ctrl,
      String label,
      IconData icon, {
        bool enabled = true,
        int maxLines = 1,
      }) {
    return TextField(
      controller: ctrl,
      enabled: enabled,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
      ),
    );
  }
}
