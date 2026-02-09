
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../common/style/app_colors.dart';
import '../../../common/style/app_text_style.dart';
import '../../myoders/myoders/myodersview.dart';
import '../../userlogin/view/useredit_profile.dart';
import '../controller/editprofile_controller.dart';
import 'user_changepswd.dart';
import '../../../core/utils/auth_service.dart';

class ProfileView extends StatelessWidget {
  ProfileView({super.key});

  final EditProfileController controller =
  Get.put(EditProfileController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      appBar: AppBar(
        backgroundColor: AppColors.kPrimary,
        title: Text("Profile",
            style: AppTextStyle.rTextNunitoWhite17w700),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            /// 🔥 PROFILE HEADER
            Obx(() {
              final user = controller.profile.value;

              if (user == null) {
                return const CircularProgressIndicator();
              }

              return Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundImage: user.profileImage.isNotEmpty
                          ? NetworkImage(user.profileImage)
                          : const AssetImage(
                          "assets/images/namsthe.png")
                      as ImageProvider,
                    ),
                    const SizedBox(width: 18),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(user.fullName,
                            style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w700)),
                        const SizedBox(height: 6),
                        Text(user.email,
                            style: const TextStyle(color: Colors.grey)),
                      ],
                    )
                  ],
                ),
              );
            }),

            const SizedBox(height: 25),

            _tile("Edit Profile", Icons.person,
                    () => Get.to(() => EditProfilePage())),
            _tile("My Orders", Icons.shopping_bag,
                    () => Get.to(() => Myodersview())),
            _tile("Change Password", Icons.lock,
                    () => Get.to(() => ChangePasswordPage())),

            const SizedBox(height: 20),

           SizedBox(width: double.infinity,child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.kPrimary,
              ),
              onPressed: AuthService.showLogoutDialog,
              child: const Text("Logout"),
            ),
           ) ],
        ),
      ),
    );
  }

  Widget _tile(String title, IconData icon, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    );
  }
}
