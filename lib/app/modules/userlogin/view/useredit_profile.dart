//
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:get/get.dart';
// import '../../../common/style/app_colors.dart';
// import '../../profile/controller/editprofile_controller.dart';
//
//
// class EditProfilePage extends StatelessWidget {
//   EditProfilePage({super.key});
//
//   final EditProfileController controller = Get.find<EditProfileController>();
//
//   @override
//   Widget build(BuildContext context) {
//     return AnnotatedRegion<SystemUiOverlayStyle>(
//       value: const SystemUiOverlayStyle(
//         statusBarColor: Colors.transparent,
//         statusBarIconBrightness: Brightness.dark,
//       ),
//       child: Scaffold(
//         backgroundColor: const Color(0xFFF4F6FB),
//         appBar: AppBar(
//           backgroundColor: AppColors.kPrimary,
//           elevation: 0,
//           scrolledUnderElevation: 0.5,
//           shadowColor: const Color(0x0F000000),
//           systemOverlayStyle: const SystemUiOverlayStyle(
//             statusBarColor: Colors.transparent,
//             statusBarIconBrightness: Brightness.dark,
//           ),
//           leading: GestureDetector(
//             onTap: () => Get.back(),
//             child: const Icon(Icons.arrow_back_ios_new_rounded,
//                 color: Colors.white, size: 20),
//           ),
//           titleSpacing: 0,
//           title: const Text(
//             'Edit Profile',
//             style: TextStyle(
//               fontSize: 20,
//               fontWeight: FontWeight.w800,
//               color: Colors.white,
//               letterSpacing: -0.5,
//             ),
//           ),
//           bottom: PreferredSize(
//             preferredSize: const Size.fromHeight(1),
//             child: Container(height: 1, color: const Color(0xFFF1F5F9)),
//           ),
//         ),
//         body: SingleChildScrollView(
//           physics: const BouncingScrollPhysics(),
//           padding: const EdgeInsets.symmetric(horizontal: 16),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               const SizedBox(height: 24),
//
//               /// ─── AVATAR ───────────────────────────────────────────────
//               _avatarSection(),
//
//               const SizedBox(height: 24),
//
//               /// ─── PERSONAL INFO ────────────────────────────────────────
//               _sectionLabel('PERSONAL INFO'),
//               const SizedBox(height: 8),
//               _cardGroup([
//                 _fieldTile(
//                   ctrl: controller.nameCtrl,
//                   label: 'Full Name',
//                   hint: 'Enter your full name',
//                   icon: Icons.person_outline_rounded,
//                   iconColor: const Color(0xFF6366F1),
//                   iconBg: const Color(0xFFEEF2FF),
//                 ),
//                 _fieldTile(
//                   ctrl: controller.phoneCtrl,
//                   label: 'Phone',
//                   hint: 'Enter your phone number',
//                   icon: Icons.phone_outlined,
//                   iconColor: const Color(0xFF3B82F6),
//                   iconBg: const Color(0xFFEFF6FF),
//                   keyboardType: TextInputType.phone,
//                 ),
//                 _fieldTile(
//                   ctrl: controller.addressCtrl,
//                   label: 'Address',
//                   hint: 'Enter your address',
//                   icon: Icons.location_on_outlined,
//                   iconColor: const Color(0xFF10B981),
//                   iconBg: const Color(0xFFF0FDF4),
//                   maxLines: 2,
//                 ),
//               ]),
//
//               const SizedBox(height: 16),
//
//               /// ─── ACCOUNT INFO ─────────────────────────────────────────
//               _sectionLabel('ACCOUNT'),
//               const SizedBox(height: 8),
//               _cardGroup([
//                 _fieldTile(
//                   ctrl: controller.emailCtrl,
//                   label: 'Email',
//                   hint: 'Your email address',
//                   icon: Icons.email_outlined,
//                   iconColor: const Color(0xFFF59E0B),
//                   iconBg: const Color(0xFFFFFBEB),
//                   enabled: false,
//                 ),
//               ]),
//
//               const SizedBox(height: 28),
//
//               /// ─── SAVE BUTTON ──────────────────────────────────────────
//               _saveButton(),
//
//               const SizedBox(height: 36),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _avatarSection() {
//     return Obx(() {
//       final apiImage = controller.profile.value?.profileImage ?? '';
//       final picked = controller.selectedImage.value;
//
//       ImageProvider imageProvider;
//       if (picked != null) {
//         imageProvider = FileImage(picked);
//       } else if (apiImage.isNotEmpty) {
//         imageProvider = NetworkImage(apiImage);
//       } else {
//         imageProvider = const AssetImage('assets/images/namsthe.png');
//       }
//
//       return Container(
//         width: double.infinity,
//         padding: const EdgeInsets.symmetric(vertical: 24),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(20),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black.withOpacity(0.05),
//               blurRadius: 16,
//               offset: const Offset(0, 4),
//             ),
//           ],
//         ),
//         child: Column(
//           children: [
//             Stack(
//               alignment: Alignment.bottomRight,
//               children: [
//                 // Gradient ring (matches ProfileView)
//                 Container(
//                   width: 88,
//                   height: 88,
//                   decoration: const BoxDecoration(
//                     shape: BoxShape.circle,
//                     gradient: LinearGradient(
//                       colors: [
//                         Color(0xFF6366F1),
//                         Color(0xFF8B5CF6),
//                         Color(0xFFEC4899),
//                       ],
//                       begin: Alignment.topLeft,
//                       end: Alignment.bottomRight,
//                     ),
//                   ),
//                   padding: const EdgeInsets.all(2.5),
//                   child: Container(
//                     decoration: const BoxDecoration(
//                       shape: BoxShape.circle,
//                       color: Colors.white,
//                     ),
//                     padding: const EdgeInsets.all(2),
//                     child: CircleAvatar(
//                       radius: 39,
//                       backgroundImage: imageProvider,
//                     ),
//                   ),
//                 ),
//                 // Camera button
//                 GestureDetector(
//                   onTap: controller.pickImage,
//                   child: Container(
//                     width: 30,
//                     height: 30,
//                     decoration: BoxDecoration(
//                       gradient: const LinearGradient(
//                         colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
//                         begin: Alignment.topLeft,
//                         end: Alignment.bottomRight,
//                       ),
//                       shape: BoxShape.circle,
//                       border: Border.all(color: Colors.white, width: 2),
//                       boxShadow: [
//                         BoxShadow(
//                           color: const Color(0xFF6366F1).withOpacity(0.35),
//                           blurRadius: 8,
//                           offset: const Offset(0, 3),
//                         ),
//                       ],
//                     ),
//                     child: const Icon(Icons.camera_alt_rounded,
//                         size: 14, color: Colors.white),
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 12),
//             const Text(
//               'Tap the camera to change photo',
//               style: TextStyle(
//                 fontSize: 11.5,
//                 color: Color(0xFFB0BEC5),
//                 fontWeight: FontWeight.w400,
//               ),
//             ),
//           ],
//         ),
//       );
//     });
//   }
//
//   Widget _sectionLabel(String label) {
//     return Padding(
//       padding: const EdgeInsets.fromLTRB(4, 0, 0, 0),
//       child: Text(
//         label,
//         style: const TextStyle(
//           fontSize: 10,
//           fontWeight: FontWeight.w800,
//           color: Color(0xFFB0BFCF),
//           letterSpacing: 1.5,
//         ),
//       ),
//     );
//   }
//
//   Widget _cardGroup(List<Widget> tiles) {
//     return Container(
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(20),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.04),
//             blurRadius: 12,
//             offset: const Offset(0, 2),
//           ),
//         ],
//       ),
//       child: Column(
//         children: List.generate(tiles.length, (i) {
//           final isFirst = i == 0;
//           final isLast = i == tiles.length - 1;
//           return Column(
//             children: [
//               ClipRRect(
//                 borderRadius: BorderRadius.vertical(
//                   top: isFirst ? const Radius.circular(20) : Radius.zero,
//                   bottom: isLast ? const Radius.circular(20) : Radius.zero,
//                 ),
//                 child: tiles[i],
//               ),
//               if (!isLast)
//                 const Padding(
//                   padding: EdgeInsets.symmetric(horizontal: 16),
//                   child: Divider(
//                       height: 1, thickness: 0.8, color: Color(0xFFF1F5F9)),
//                 ),
//             ],
//           );
//         }),
//       ),
//     );
//   }
//
//   Widget _fieldTile({
//     required TextEditingController ctrl,
//     required String label,
//     required String hint,
//     required IconData icon,
//     required Color iconColor,
//     required Color iconBg,
//     bool enabled = true,
//     int maxLines = 1,
//     TextInputType keyboardType = TextInputType.text,
//   }) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
//       child: Row(
//         crossAxisAlignment:
//         maxLines > 1 ? CrossAxisAlignment.start : CrossAxisAlignment.center,
//         children: [
//           Container(
//             width: 40,
//             height: 40,
//             decoration: BoxDecoration(
//               color: enabled ? iconBg : const Color(0xFFF8FAFC),
//               borderRadius: BorderRadius.circular(12),
//             ),
//             child: Icon(icon,
//                 color: enabled ? iconColor : const Color(0xFFCBD5E1),
//                 size: 19),
//           ),
//           const SizedBox(width: 14),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   label,
//                   style: TextStyle(
//                     fontSize: 10.5,
//                     fontWeight: FontWeight.w700,
//                     color: enabled
//                         ? const Color(0xFF94A3B8)
//                         : const Color(0xFFCBD5E1),
//                     letterSpacing: 0.6,
//                   ),
//                 ),
//                 const SizedBox(height: 4),
//                 TextField(
//                   controller: ctrl,
//                   enabled: enabled,
//                   maxLines: maxLines,
//                   keyboardType: keyboardType,
//                   style: TextStyle(
//                     fontSize: 14.5,
//                     fontWeight: FontWeight.w600,
//                     color: enabled
//                         ? const Color(0xFF0F172A)
//                         : const Color(0xFFB0BEC5),
//                     letterSpacing: -0.2,
//                   ),
//                   decoration: InputDecoration(
//                     hintText: hint,
//                     hintStyle: const TextStyle(
//                       fontSize: 14,
//                       color: Color(0xFFCBD5E1),
//                       fontWeight: FontWeight.w400,
//                     ),
//                     isDense: true,
//                     contentPadding: EdgeInsets.zero,
//                     border: InputBorder.none,
//                     focusedBorder: InputBorder.none,
//                     enabledBorder: InputBorder.none,
//                     disabledBorder: InputBorder.none,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           if (enabled)
//             const Icon(Icons.edit_outlined,
//                 size: 15, color: Color(0xFFCBD5E1)),
//         ],
//       ),
//     );
//   }
//
//   Widget _saveButton() {
//     return Obx(() {
//       return GestureDetector(
//         onTap:
//         controller.isLoading.value ? null : controller.updateProfile,
//         child: AnimatedContainer(
//           duration: const Duration(milliseconds: 200),
//           width: double.infinity,
//           padding: const EdgeInsets.symmetric(vertical: 16),
//           decoration: BoxDecoration(
//             gradient: controller.isLoading.value
//                 ? const LinearGradient(
//                 colors: [Color(0xFFB0BEC5), Color(0xFFB0BEC5)])
//                 : const LinearGradient(
//               colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
//               begin: Alignment.centerLeft,
//               end: Alignment.centerRight,
//             ),
//             borderRadius: BorderRadius.circular(16),
//             boxShadow: controller.isLoading.value
//                 ? []
//                 : [
//               BoxShadow(
//                 color: const Color(0xFF6366F1).withOpacity(0.35),
//                 blurRadius: 16,
//                 offset: const Offset(0, 6),
//               ),
//             ],
//           ),
//           child: Center(
//             child: controller.isLoading.value
//                 ? const SizedBox(
//               width: 22,
//               height: 22,
//               child: CircularProgressIndicator(
//                   color: Colors.white, strokeWidth: 2.5),
//             )
//                 : const Text(
//               'Save Changes',
//               style: TextStyle(
//                 fontSize: 15,
//                 fontWeight: FontWeight.w700,
//                 color: Colors.white,
//                 letterSpacing: -0.2,
//               ),
//             ),
//           ),
//         ),
//       );
//     });
//   }
// }
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
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: Colors.grey[50],
        appBar: AppBar(
          elevation: 0,
          backgroundColor: AppColors.kPrimary,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded,
                color: Colors.white, size: 20),
            onPressed: () => Get.back(),
          ),
          title: const Text(
            'Edit Profile',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ─── AVATAR CARD ──────────────────────────────────────
              _buildAvatarCard(),

              const SizedBox(height: 24),

              // ─── PERSONAL INFO ────────────────────────────────────
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

              // ─── ACCOUNT ──────────────────────────────────────────
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

              const SizedBox(height: 10),

              // Info note
              _buildInfoNote(),

              const SizedBox(height: 28),

              // ─── SAVE BUTTON ──────────────────────────────────────
              _saveButton(),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  // ─── AVATAR CARD ───────────────────────────────────────────────────────────
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
            // Decorative circle
            Positioned(
              top: -20,
              right: -20,
              child: Container(
                width: 110,
                height: 110,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.07),
                ),
              ),
            ),
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
                    fontSize: 11.5,
                    color: Colors.white.withOpacity(0.75),
                    fontWeight: FontWeight.w400,
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
        fontSize: 16,
        fontWeight: FontWeight.w700,
        color: Color(0xFF2D3748),
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
                    fontSize: 10.5,
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
                  style: TextStyle(
                    fontSize: 14.5,
                    fontWeight: FontWeight.w600,
                    color: enabled
                        ? const Color(0xFF2D3748)
                        : Colors.grey[400],
                    letterSpacing: -0.2,
                  ),
                  decoration: InputDecoration(
                    hintText: hint,
                    hintStyle: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[300],
                      fontWeight: FontWeight.w400,
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
                fontSize: 11.5,
                color: Color(0xFF92400E),
                fontWeight: FontWeight.w500,
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
      return ElevatedButton(
        onPressed: controller.isLoading.value ? null : controller.updateProfile,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        child: Ink(
          decoration: BoxDecoration(
            gradient: controller.isLoading.value
                ? LinearGradient(
                colors: [Colors.grey[400]!, Colors.grey[400]!])
                : LinearGradient(
              colors: [
                AppColors.kPrimary,
                AppColors.kPrimary.withOpacity(0.8),
              ],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
            borderRadius: BorderRadius.circular(14),
            boxShadow: controller.isLoading.value
                ? []
                : [
              BoxShadow(
                color: AppColors.kPrimary.withOpacity(0.35),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Center(
              child: controller.isLoading.value
                  ? const SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(
                    color: Colors.white, strokeWidth: 2.5),
              )
                  : const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.check_rounded,
                      color: Colors.white, size: 20),
                  SizedBox(width: 8),
                  Text(
                    'Save Changes',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}