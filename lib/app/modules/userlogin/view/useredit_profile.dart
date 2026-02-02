
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../common/style/app_colors.dart';
import '../../../common/style/app_text_style.dart';
import '../../profile/controller/editprofile_controller.dart';


class EditProfilePage extends StatelessWidget {
  EditProfilePage({super.key});

  final EditProfileController controller =
  Get.put(EditProfileController());

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
        elevation: 0,
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

  // ---------------- PROFILE AVATAR ----------------
  Widget _profileAvatar() {
    return Obx(() {
      final image = controller.profile.value?.profileImage ?? '';

      return Stack(
        alignment: Alignment.bottomRight,
        children: [
          CircleAvatar(
            radius: 55,
            backgroundColor: AppColors.kPrimary.withOpacity(0.2),
            backgroundImage:
            image.isNotEmpty ? NetworkImage(image) : null,
            child: image.isEmpty
                ? const Icon(
              Icons.person,
              size: 60,
              color: AppColors.kPrimary,
            )
                : null,
          ),
          CircleAvatar(
            radius: 18,
            backgroundColor: AppColors.kPrimary,
            child: const Icon(Icons.edit, size: 18, color: Colors.white),
          ),
        ],
      );
    });
  }

  // ---------------- PROFILE CARD ----------------
  Widget _profileCard() {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          children: [
            _title("Personal Information"),
            const SizedBox(height: 20),

            _textField(
              controller: controller.nameCtrl,
              label: "Full Name",
              icon: Icons.person,
            ),
            const SizedBox(height: 16),

            _textField(
              controller: controller.emailCtrl,
              label: "Email Address",
              icon: Icons.email,
              keyboardType: TextInputType.emailAddress,
              enabled: false, // 🔒 email not editable
            ),
            const SizedBox(height: 16),

            _textField(
              controller: controller.phoneCtrl,
              label: "Mobile Number",
              icon: Icons.phone,
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 16),

            _textField(
              controller: controller.addressCtrl,
              label: "Address",
              icon: Icons.location_on,
              maxLines: 2,
            ),
          ],
        ),
      ),
    );
  }

  // ---------------- SAVE BUTTON ----------------
  Widget _saveButton() {
    return Obx(() {
      return SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.kPrimary,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 3,
          ),
          onPressed: controller.isLoading.value
              ? null
              : () {
            controller.updateProfile();
          },
          child: controller.isLoading.value
              ? const SizedBox(
            height: 22,
            width: 22,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: Colors.white,
            ),
          )
              : const Text(
            "Save Changes",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ),
      );
    });
  }

  // ---------------- TITLE ----------------
  Widget _title(String text) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  // ---------------- CUSTOM TEXTFIELD ----------------
  Widget _textField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
    bool enabled = true,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      enabled: enabled,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: AppColors.kPrimary),
        filled: true,
        fillColor: Colors.grey.shade50,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(
            color: AppColors.kPrimary,
            width: 1.5,
          ),
        ),
      ),
    );
  }
}
