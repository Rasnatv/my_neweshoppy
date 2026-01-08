
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../common/style/app_colors.dart';
import '../../../common/style/app_text_style.dart';
import '../../merchant_home/views/shopedit.dart';
import '../../myoders/myoders/myodersview.dart';
import '../../userlogin/view/useredit_profile.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      appBar: AppBar(
        backgroundColor: AppColors.kPrimary,
        elevation: 0,
        title: Text(
          "Profile",style:AppTextStyle.rTextNunitoWhite17w700)
        ),


      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [

            // ------------------ PROFILE HEADER ------------------
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.blueGrey,
                    backgroundImage: AssetImage("assets/images/namsthe.png"),
                  ),
                  const SizedBox(width: 18),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        "Rosna",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(height: 6),
                      Text(
                        "rosna123@example.com",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),

            const SizedBox(height: 25),

            // ------------------ ACCOUNT OPTIONS ------------------
            _sectionTitle("Account Settings"),

            _settingTile(
              icon: Icons.person_outline,
              title: "Edit Profile",
              onTap: ()=>Get.to(()=>EditProfilePage()),
            ),
            _settingTile(
              icon: Icons.shopping_bag_outlined,
              title: "My Orders",
              onTap: () =>Get.to(()=>Myodersview()),
            ),
            _settingTile(
              icon: Icons.lock_outline,
              title: "Change Password",
            onTap: (){}
            //  onTap: () =>Get.to(()=>ChangePasswordPage()),
            ),

            // ------------------ LOGOUT BUTTON ------------------
            SizedBox(width: MediaQuery.sizeOf(context).width,child:
            ElevatedButton(
              onPressed: () {},
              child: const Text(
                "Logout",
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
            )],
        ),
      ),
    );
  }

  // ---------- section title ----------
  Widget _sectionTitle(String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Text(
          title,
          style: const TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }

  // ---------- settings tiles ----------
  Widget _settingTile({
    required IconData icon,
    required String title,
    required Function() onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        leading: Icon(icon, color: Colors.black87, size: 26),
        title: Text(
          title,
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
        ),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
        onTap: onTap,
      ),
    );
  }
}
