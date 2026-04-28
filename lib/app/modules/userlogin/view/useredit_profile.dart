
import 'package:eshoppy/app/widgets/networkconnection_checkpage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../../common/style/app_colors.dart';
import '../../profile/controller/editprofile_controller.dart';

class EditProfilePage extends StatelessWidget {
  EditProfilePage({super.key});

  final EditProfileController controller = Get.find<EditProfileController>();

  @override
  Widget build(BuildContext context) {

    // ✅ Ensure data loads if empty
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (controller.profile.value == null && !controller.isLoading.value) {
        controller.fetchProfile();
      }
    });

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
      child:NetworkAwareWrapper(child: Scaffold(
        backgroundColor: Colors.grey[50],
        appBar: AppBar(
          elevation: 0,
          backgroundColor: AppColors.kPrimary,
          iconTheme: const IconThemeData(color: Colors.white),
          title: const Text(
            'Edit Profile',
            style: TextStyle(
              color: Colors.white,
              fontSize: 17,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),

        // ✅ FULL FIX HERE
        body: Obx(() {
          if (controller.isLoading.value &&
              controller.profile.value == null) {
            return const Center(child: CircularProgressIndicator());
          }

          if (controller.profile.value == null) {
            return const Center(child: Text("No data available"));
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                _buildAvatarCard(),

                const SizedBox(height: 24),

                _sectionHeader('Personal Info'),
                const SizedBox(height: 12),
                _buildCard([
                  _fieldTile(
                    ctrl: controller.nameCtrl,
                    label: 'Full Name',
                    hint: 'Enter your full name',
                    icon: Icons.person_outline_rounded,
                    color: const Color(0xFF6366F1),
                  ),
                  _fieldTile(
                    ctrl: controller.phoneCtrl,
                    label: 'Phone',
                    hint: 'Enter your phone number',
                    icon: Icons.phone_outlined,
                    color: const Color(0xFF3B82F6),
                    keyboardType: TextInputType.phone,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(10),
                    ],
                  ),
                  _fieldTile(
                    ctrl: controller.addressCtrl,
                    label: 'Address',
                    hint: 'Enter your address',
                    icon: Icons.location_on_outlined,
                    color: const Color(0xFF10B981),
                    maxLines: 2,
                  ),
                ]),

                const SizedBox(height: 20),

                _sectionHeader('Account'),
                const SizedBox(height: 12),
                _buildCard([
                  _fieldTile(
                    ctrl: controller.emailCtrl,
                    label: 'Email',
                    hint: 'Your email address',
                    icon: Icons.email_outlined,
                    color: const Color(0xFFF59E0B),
                    enabled: false,
                  ),
                ]),

                const SizedBox(height: 28),

                _saveButton(),

                const SizedBox(height: 40),
              ],
            ),
          );
        }),
      ),
    ));
  }

//   // ─── AVATAR CARD ───────────────────────────────────────────────────────────
  Widget _buildAvatarCard() {
    return Obx(() {
      final apiImage = controller.profile.value?.profileImage ?? '';
      final picked = controller.selectedImage.value;

      ImageProvider imageProvider;
      if (picked != null) {
        imageProvider = FileImage(picked);
      } else if (apiImage.isNotEmpty) {
        imageProvider = NetworkImage(apiImage);
      } else {
        imageProvider = const AssetImage('assets/images/namsthe.png');
      }

      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.kPrimary,
              AppColors.kPrimary.withOpacity(0.82),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: AppColors.kPrimary.withOpacity(0.3),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Stack(
          children: [
            Column(
              children: [
                Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    Container(
                      width: 90,
                      height: 90,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white.withOpacity(0.8),
                          width: 2.5,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: CircleAvatar(
                        radius: 43,
                        backgroundImage: imageProvider,
                      ),
                    ),
                    GestureDetector(
                      onTap: controller.pickImage,
                      child: Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          border: Border.all(
                              color: AppColors.kPrimary.withOpacity(0.2),
                              width: 2),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.15),
                              blurRadius: 8,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Icon(Icons.camera_alt_rounded,
                            size: 15, color: AppColors.kPrimary),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  'Tap to change your profile photo',
                  style: TextStyle(
                    fontSize: 12, // was 11.5
                    color: Colors.white.withOpacity(0.75),
                    fontWeight: FontWeight.w500, // was w400
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    });
  }

  // ─── SECTION HEADER ────────────────────────────────────────────────────────
  Widget _sectionHeader(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,              // was 16
        fontWeight: FontWeight.w800, // was w700
        color: Color(0xFF1A202C),  // was 0xFF2D3748
        letterSpacing: -0.3,       // added
      ),
    );
  }

  // ─── CARD ──────────────────────────────────────────────────────────────────
  Widget _buildCard(List<Widget> tiles) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: List.generate(tiles.length, (i) {
          final isLast = i == tiles.length - 1;
          return Column(
            children: [
              tiles[i],
              if (!isLast)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Divider(
                      height: 1, thickness: 0.8, color: Colors.grey[100]),
                ),
            ],
          );
        }),
      ),
    );
  }

  // ─── FIELD TILE ────────────────────────────────────────────────────────────
  Widget _fieldTile({
    required TextEditingController ctrl,
    required String label,
    required String hint,
    required IconData icon,
    required Color color,
    bool enabled = true,
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
    List<TextInputFormatter>? inputFormatters,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        crossAxisAlignment:
        maxLines > 1 ? CrossAxisAlignment.start : CrossAxisAlignment.center,
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: enabled ? color.withOpacity(0.1) : Colors.grey[100],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon,
                color: enabled ? color : Colors.grey[400], size: 20),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 11,              // was 10.5
                    fontWeight: FontWeight.w700,
                    color: enabled
                        ? const Color(0xFF94A3B8)
                        : Colors.grey[400],
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 4),
                TextField(
                  controller: ctrl,
                  enabled: enabled,
                  maxLines: maxLines,
                  keyboardType: keyboardType,
                  inputFormatters: inputFormatters,
                  style: TextStyle(
                    fontSize: 15,              // was 14.5
                    fontWeight: FontWeight.w700, // was w600
                    color: enabled
                        ? const Color(0xFF1A202C) // was 0xFF2D3748
                        : Colors.grey[400],
                    letterSpacing: -0.2,
                  ),
                  decoration: InputDecoration(
                    hintText: hint,
                    hintStyle: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[300],
                      fontWeight: FontWeight.w500, // was w400
                    ),
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                    border: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                  ),
                ),
              ],
            ),
          ),
          if (enabled)
            Icon(Icons.edit_outlined, size: 16, color: Colors.grey[300]),
        ],
      ),
    );
  }

  // ─── INFO NOTE ─────────────────────────────────────────────────────────────
  Widget _buildInfoNote() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFBEB),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFFDE68A), width: 1),
      ),
      child: Row(
        children: [
          const Icon(Icons.info_outline_rounded,
              size: 17, color: Color(0xFFF59E0B)),
          const SizedBox(width: 10),
          const Expanded(
            child: Text(
              'Email cannot be changed. Contact support if you need to update it.',
              style: TextStyle(
                fontSize: 12,              // was 11.5
                color: Color(0xFF92400E),
                fontWeight: FontWeight.w600, // was w500
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ─── SAVE BUTTON ───────────────────────────────────────────────────────────
  Widget _saveButton() {
    return Obx(() {
      final isLoading = controller.isLoading.value;
      return GestureDetector(
        onTap: isLoading ? null : controller.updateProfile,
        child: Container(
          width: double.infinity,
          height: 54,
          decoration: BoxDecoration(
            gradient: isLoading
                ? LinearGradient(colors: [Colors.grey[400]!, Colors.grey[400]!])
                : LinearGradient(
              colors: [
                AppColors.kPrimary,
                AppColors.kPrimary.withOpacity(0.85),
              ],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
            borderRadius: BorderRadius.circular(14),
            boxShadow: isLoading
                ? []
                : [
              BoxShadow(
                color: AppColors.kPrimary.withOpacity(0.35),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Center(
            child: isLoading
                ? const SizedBox(
              width: 22,
              height: 22,
              child: CircularProgressIndicator(
                  color: Colors.white, strokeWidth: 2.5),
            )
                : const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.check_rounded, color: Colors.white, size: 20),
                SizedBox(width: 8),
                Text(
                  'Save Changes',
                  style: TextStyle(
                    fontSize: 16,              // was 15
                    fontWeight: FontWeight.w800, // was w700
                    color: Colors.white,
                    letterSpacing: -0.2,        // added
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
