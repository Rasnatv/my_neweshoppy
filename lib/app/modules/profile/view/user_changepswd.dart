//
//
//
// import 'package:eshoppy/app/modules/profile/controller/user_chnagepassword_controller.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:get/get.dart';
// import '../../../common/style/app_colors.dart';
//
// class ChangePasswordPage extends StatefulWidget {
//   const ChangePasswordPage({super.key});
//
//   @override
//   State<ChangePasswordPage> createState() => _ChangePasswordPageState();
// }
//
// class _ChangePasswordPageState extends State<ChangePasswordPage> {
//   final _oldCtrl     = TextEditingController();
//   final _newCtrl     = TextEditingController();
//   final _confirmCtrl = TextEditingController();
//   final ChangePasswordController controller = Get.put(ChangePasswordController());
//
//   bool _showOld     = false;
//   bool _showNew     = false;
//   bool _showConfirm = false;
//
//   @override
//   void dispose() {
//     _oldCtrl.dispose();
//     _newCtrl.dispose();
//     _confirmCtrl.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return AnnotatedRegion<SystemUiOverlayStyle>(
//       value: const SystemUiOverlayStyle(
//         statusBarColor: Colors.transparent,
//         statusBarIconBrightness: Brightness.light,
//       ),
//       child: Scaffold(
//         backgroundColor: Colors.grey[50],
//         appBar: AppBar(
//           elevation: 0,
//           backgroundColor: AppColors.kPrimary,
//          automaticallyImplyLeading: true,
//           iconTheme: IconThemeData(color: Colors.white),
//           title: const Text(
//             'Change Password',
//               style: TextStyle(
//                 color: Colors.white,
//                 fontSize: 17,
//                 fontWeight: FontWeight.w600,
//                 letterSpacing: 0.1,
//               )
//           ),
//         ),
//         body: SingleChildScrollView(
//           physics: const BouncingScrollPhysics(),
//           padding: const EdgeInsets.all(16),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//
//               // ── SECURITY BANNER ───────────────────────────────────────
//               _buildSecurityBanner(),
//               const SizedBox(height: 28),
//
//               // ── PASSWORD DETAILS ──────────────────────────────────────
//               _sectionHeader('Password Details'),
//               const SizedBox(height: 14),
//
//               _buildFieldCard(
//                 ctrl: _oldCtrl,
//                 icon: Icons.lock_outline_rounded,
//                 title: 'Current Password',
//                 hint: 'Enter your current password',
//                 color: const Color(0xFF6366F1),
//                 obscure: !_showOld,
//                 onToggle: () => setState(() => _showOld = !_showOld),
//               ),
//               const SizedBox(height: 12),
//               _buildFieldCard(
//                 ctrl: _newCtrl,
//                 icon: Icons.lock_reset_rounded,
//                 title: 'New Password',
//                 hint: 'Enter your new password',
//                 color: const Color(0xFF10B981),
//                 obscure: !_showNew,
//                 onToggle: () => setState(() => _showNew = !_showNew),
//               ),
//               const SizedBox(height: 12),
//               _buildFieldCard(
//                 ctrl: _confirmCtrl,
//                 icon: Icons.check_circle_outline_rounded,
//                 title: 'Confirm New Password',
//                 hint: 'Re-enter your new password',
//                 color: const Color(0xFF3B82F6),
//                 obscure: !_showConfirm,
//                 onToggle: () => setState(() => _showConfirm = !_showConfirm),
//               ),
//
//               const SizedBox(height: 28),
//
//               // ── TIPS ──────────────────────────────────────────────────
//               _sectionHeader('Password Tips'),
//               const SizedBox(height: 14),
//               _buildTipCard(Icons.straighten_rounded,  const Color(0xFF6366F1), 'At least 8 characters long'),
//               const SizedBox(height: 10),
//               _buildTipCard(Icons.text_fields_rounded, const Color(0xFF10B981), 'Mix of uppercase & lowercase'),
//               const SizedBox(height: 10),
//               _buildTipCard(Icons.tag_rounded,          const Color(0xFF3B82F6), 'Include numbers and symbols'),
//               const SizedBox(height: 10),
//               _buildTipCard(Icons.person_off_outlined,  const Color(0xFFF59E0B), 'Avoid personal information'),
//
//               const SizedBox(height: 32),
//
//               _buildUpdateButton(),
//               const SizedBox(height: 12),
//               _buildCancelButton(),
//               const SizedBox(height: 40),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   // ─── SECTION HEADER ────────────────────────────────────────────────────────
//   Widget _sectionHeader(String title) {
//     return Text(
//       title,
//       style: const TextStyle(
//         fontSize: 16,
//         fontWeight: FontWeight.w700,
//         color: Color(0xFF2D3748),
//       ),
//     );
//   }
//
//   // ─── INDIVIDUAL FIELD CARD ─────────────────────────────────────────────────
//   Widget _buildFieldCard({
//     required TextEditingController ctrl,
//     required IconData icon,
//     required String title,
//     required String hint,
//     required Color color,
//     required bool obscure,
//     required VoidCallback onToggle,
//   }) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(16),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.05),
//             blurRadius: 10,
//             offset: const Offset(0, 2),
//           ),
//         ],
//       ),
//       child: Row(
//         children: [
//           Container(
//             width: 46,
//             height: 46,
//             decoration: BoxDecoration(
//               color: color.withOpacity(0.1),
//               borderRadius: BorderRadius.circular(13),
//             ),
//             child: Icon(icon, color: color, size: 22),
//           ),
//           const SizedBox(width: 14),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   title,
//                   style: const TextStyle(
//                     fontSize: 13,
//                     fontWeight: FontWeight.w700,
//                     color: Color(0xFF2D3748),
//                   ),
//                 ),
//                 const SizedBox(height: 5),
//                 TextField(
//                   controller: ctrl,
//                   obscureText: obscure,
//                   style: TextStyle(
//                     fontSize: 13.5,
//                     fontWeight: FontWeight.w500,
//                     color: Colors.grey[700],
//                   ),
//                   decoration: InputDecoration(
//                     hintText: hint,
//                     hintStyle: TextStyle(
//                       fontSize: 13,
//                       color: Colors.grey[300],
//                       fontWeight: FontWeight.w400,
//                     ),
//                     isDense: true,
//                     contentPadding: EdgeInsets.zero,
//                     border: InputBorder.none,
//                     focusedBorder: InputBorder.none,
//                     enabledBorder: InputBorder.none,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           const SizedBox(width: 10),
//           GestureDetector(
//             onTap: onToggle,
//             child: Container(
//               width: 36,
//               height: 36,
//               decoration: BoxDecoration(
//                 color: Colors.grey[100],
//                 borderRadius: BorderRadius.circular(10),
//               ),
//               child: Icon(
//                 obscure ? Icons.visibility_off_outlined : Icons.visibility_outlined,
//                 size: 18,
//                 color: Colors.grey[400],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   // ─── INDIVIDUAL TIP CARD ───────────────────────────────────────────────────
//   Widget _buildTipCard(IconData icon, Color color, String text) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(14),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.04),
//             blurRadius: 8,
//             offset: const Offset(0, 2),
//           ),
//         ],
//       ),
//       child: Row(
//         children: [
//           Container(
//             width: 40,
//             height: 40,
//             decoration: BoxDecoration(
//               color: color.withOpacity(0.1),
//               borderRadius: BorderRadius.circular(11),
//             ),
//             child: Icon(icon, color: color, size: 20),
//           ),
//           const SizedBox(width: 14),
//           Text(
//             text,
//             style: const TextStyle(
//               fontSize: 13.5,
//               fontWeight: FontWeight.w600,
//               color: Color(0xFF2D3748),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   // ─── SECURITY BANNER ───────────────────────────────────────────────────────
//   Widget _buildSecurityBanner() {
//     return Container(
//       width: double.infinity,
//       padding: const EdgeInsets.all(20),
//       decoration: BoxDecoration(
//         gradient: LinearGradient(
//           colors: [AppColors.kPrimary, AppColors.kPrimary.withOpacity(0.82)],
//           begin: Alignment.topLeft,
//           end: Alignment.bottomRight,
//         ),
//         borderRadius: BorderRadius.circular(20),
//         boxShadow: [
//           BoxShadow(
//             color: AppColors.kPrimary.withOpacity(0.3),
//             blurRadius: 16,
//             offset: const Offset(0, 6),
//           ),
//         ],
//       ),
//       child: Stack(
//         children: [
//           Positioned(
//             top: -20,
//             right: -20,
//             child: Container(
//               width: 120,
//               height: 120,
//               decoration: BoxDecoration(
//                 shape: BoxShape.circle,
//                 color: Colors.white.withOpacity(0.07),
//               ),
//             ),
//           ),
//           Row(
//             children: [
//               Container(
//                 width: 54,
//                 height: 54,
//                 decoration: BoxDecoration(
//                   color: Colors.white.withOpacity(0.2),
//                   borderRadius: BorderRadius.circular(14),
//                 ),
//                 child: const Icon(Icons.shield_rounded, color: Colors.white, size: 28),
//               ),
//               const SizedBox(width: 16),
//               const Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       'Secure Your Account',
//                       style: TextStyle(
//                         fontSize: 16,
//                         fontWeight: FontWeight.w800,
//                         color: Colors.white,
//                         letterSpacing: -0.3,
//                       ),
//                     ),
//                     SizedBox(height: 4),
//                     Text(
//                       'Update your password to keep\nyour account protected',
//                       style: TextStyle(
//                         fontSize: 12,
//                         color: Colors.white70,
//                         height: 1.45,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
//
//   // ─── UPDATE BUTTON ─────────────────────────────────────────────────────────
//   Widget _buildUpdateButton() {
//     return GestureDetector(
//       onTap: _handleUpdate,
//       child: Container(
//         width: double.infinity,
//         height: 54,
//         decoration: BoxDecoration(
//           gradient: LinearGradient(
//             colors: [AppColors.kPrimary, AppColors.kPrimary.withOpacity(0.85)],
//             begin: Alignment.centerLeft,
//             end: Alignment.centerRight,
//           ),
//           borderRadius: BorderRadius.circular(14),
//           boxShadow: [
//             BoxShadow(
//               color: AppColors.kPrimary.withOpacity(0.35),
//               blurRadius: 16,
//               offset: const Offset(0, 6),
//             ),
//           ],
//         ),
//         child: const Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Icon(Icons.lock_reset_rounded, color: Colors.white, size: 20),
//             SizedBox(width: 8),
//             Text(
//               'Update Password',
//               style: TextStyle(
//                 fontSize: 15,
//                 fontWeight: FontWeight.w700,
//                 color: Colors.white,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   // ─── CANCEL BUTTON ─────────────────────────────────────────────────────────
//   Widget _buildCancelButton() {
//     return GestureDetector(
//       onTap: () => Get.back(),
//       child: Container(
//         width: double.infinity,
//         height: 50,
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(14),
//           border: Border.all(color: Colors.grey[200]!, width: 1.2),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black.withOpacity(0.03),
//               blurRadius: 8,
//               offset: const Offset(0, 2),
//             ),
//           ],
//         ),
//         child: const Center(
//           child: Text(
//             'Cancel',
//             style: TextStyle(
//               fontSize: 15,
//               fontWeight: FontWeight.w600,
//               color: Color(0xFF64748B),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   // ─── HANDLERS ──────────────────────────────────────────────────────────────
//   void _handleUpdate() {
//     if (_oldCtrl.text.isEmpty || _newCtrl.text.isEmpty || _confirmCtrl.text.isEmpty) {
//       _snack('Missing Fields', 'Please fill in all password fields');
//       return;
//     }
//     if (_newCtrl.text != _confirmCtrl.text) {
//       _snack('Password Mismatch', 'New password and confirm password do not match');
//       return;
//     }
//     controller.changePassword(
//       oldPassword: _oldCtrl.text.trim(),
//       newPassword: _newCtrl.text.trim(),
//       confirmPassword: _confirmCtrl.text.trim(),
//     );
//   }
//
//   void _snack(String title, String msg) {
//     Get.snackbar(
//       title, msg,
//       backgroundColor: const Color(0xFFEF4444),
//       colorText: Colors.white,
//       borderRadius: 14,
//       margin: const EdgeInsets.fromLTRB(16, 12, 16, 0),
//       snackPosition: SnackPosition.TOP,
//       padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
//     );
//   }
// }
import 'package:eshoppy/app/modules/profile/controller/user_chnagepassword_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../../common/style/app_colors.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final _oldCtrl     = TextEditingController();
  final _newCtrl     = TextEditingController();
  final _confirmCtrl = TextEditingController();
  final ChangePasswordController controller = Get.put(ChangePasswordController());

  bool _showOld     = false;
  bool _showNew     = false;
  bool _showConfirm = false;

  @override
  void dispose() {
    _oldCtrl.dispose();
    _newCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

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
          automaticallyImplyLeading: true,
          iconTheme: const IconThemeData(color: Colors.white),
          title: const Text(
            'Change Password',
              style: TextStyle(
                color: Colors.white,
                fontSize: 17,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.1,
              )
          ),
        ),
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // ── SECURITY BANNER ───────────────────────────────────────
              _buildSecurityBanner(),
              const SizedBox(height: 28),

              // ── PASSWORD DETAILS ──────────────────────────────────────
              _sectionHeader('Password Details'),
              const SizedBox(height: 14),

              _buildFieldCard(
                ctrl: _oldCtrl,
                icon: Icons.lock_outline_rounded,
                title: 'Current Password',
                hint: 'Enter your current password',
                color: const Color(0xFF6366F1),
                obscure: !_showOld,
                onToggle: () => setState(() => _showOld = !_showOld),
              ),
              const SizedBox(height: 12),
              _buildFieldCard(
                ctrl: _newCtrl,
                icon: Icons.lock_reset_rounded,
                title: 'New Password',
                hint: 'Enter your new password',
                color: const Color(0xFF10B981),
                obscure: !_showNew,
                onToggle: () => setState(() => _showNew = !_showNew),
              ),
              const SizedBox(height: 12),
              _buildFieldCard(
                ctrl: _confirmCtrl,
                icon: Icons.check_circle_outline_rounded,
                title: 'Confirm New Password',
                hint: 'Re-enter your new password',
                color: const Color(0xFF3B82F6),
                obscure: !_showConfirm,
                onToggle: () => setState(() => _showConfirm = !_showConfirm),
              ),

              const SizedBox(height: 28),

              // ── TIPS ──────────────────────────────────────────────────
              _sectionHeader('Password Tips'),
              const SizedBox(height: 14),
              _buildTipCard(Icons.straighten_rounded,  const Color(0xFF6366F1), 'At least 8 characters long'),
              const SizedBox(height: 10),
              _buildTipCard(Icons.text_fields_rounded, const Color(0xFF10B981), 'Mix of uppercase & lowercase'),
              const SizedBox(height: 10),
              _buildTipCard(Icons.tag_rounded,          const Color(0xFF3B82F6), 'Include numbers and symbols'),
              const SizedBox(height: 10),
              _buildTipCard(Icons.person_off_outlined,  const Color(0xFFF59E0B), 'Avoid personal information'),

              const SizedBox(height: 32),

              _buildUpdateButton(),
              const SizedBox(height: 12),
              _buildCancelButton(),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
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

  // ─── INDIVIDUAL FIELD CARD ─────────────────────────────────────────────────
  Widget _buildFieldCard({
    required TextEditingController ctrl,
    required IconData icon,
    required String title,
    required String hint,
    required Color color,
    required bool obscure,
    required VoidCallback onToggle,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
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
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(13),
            ),
            child: Icon(icon, color: color, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,              // was 13
                    fontWeight: FontWeight.w800, // was w700
                    color: Color(0xFF1A202C),   // was 0xFF2D3748
                    letterSpacing: -0.2,        // added
                  ),
                ),
                const SizedBox(height: 5),
                TextField(
                  controller: ctrl,
                  obscureText: obscure,
                  style: TextStyle(
                    fontSize: 14,              // was 13.5
                    fontWeight: FontWeight.w600, // was w500
                    color: Colors.grey[700],
                  ),
                  decoration: InputDecoration(
                    hintText: hint,
                    hintStyle: TextStyle(
                      fontSize: 13,
                      color: Colors.grey[300],
                      fontWeight: FontWeight.w500, // was w400
                    ),
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                    border: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          GestureDetector(
            onTap: onToggle,
            child: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                obscure ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                size: 18,
                color: Colors.grey[400],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ─── INDIVIDUAL TIP CARD ───────────────────────────────────────────────────
  Widget _buildTipCard(IconData icon, Color color, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(11),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 14),
          Text(
            text,
            style: const TextStyle(
              fontSize: 14,              // was 13.5
              // fontWeight: FontWeight.w700, // was w600
              color: Color(0xFF1A202C),   // was 0xFF2D3748
              letterSpacing: -0.1,        // added
            ),
          ),
        ],
      ),
    );
  }

  // ─── SECURITY BANNER ───────────────────────────────────────────────────────
  Widget _buildSecurityBanner() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.kPrimary, AppColors.kPrimary.withOpacity(0.82)],
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
          Positioned(
            top: -20,
            right: -20,
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.07),
              ),
            ),
          ),
          Row(
            children: [
              Container(
                width: 54,
                height: 54,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(Icons.shield_rounded, color: Colors.white, size: 28),
              ),
              const SizedBox(width: 16),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Secure Your Account',
                      style: TextStyle(
                        fontSize: 18,              // was 16
                        fontWeight: FontWeight.w900, // was w800
                        color: Colors.white,
                        letterSpacing: -0.4,        // was -0.3
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Update your password to keep\nyour account protected',
                      style: TextStyle(
                        fontSize: 13,              // was 12
                        fontWeight: FontWeight.w500, // was default w400
                        color: Colors.white70,
                        height: 1.45,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ─── UPDATE BUTTON ─────────────────────────────────────────────────────────
  Widget _buildUpdateButton() {
    return GestureDetector(
      onTap: _handleUpdate,
      child: Container(
        width: double.infinity,
        height: 54,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.kPrimary, AppColors.kPrimary.withOpacity(0.85)],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: AppColors.kPrimary.withOpacity(0.35),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.lock_reset_rounded, color: Colors.white, size: 20),
            SizedBox(width: 8),
            Text(
              'Update Password',
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
    );
  }

  // ─── CANCEL BUTTON ─────────────────────────────────────────────────────────
  Widget _buildCancelButton() {
    return GestureDetector(
      onTap: () => Get.back(),
      child: Container(
        width: double.infinity,
        height: 50,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.grey[200]!, width: 1.2),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: const Center(
          child: Text(
            'Cancel',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700, // was w600
              color: Color(0xFF64748B),
            ),
          ),
        ),
      ),
    );
  }

  // ─── HANDLERS ──────────────────────────────────────────────────────────────
  void _handleUpdate() {
    if (_oldCtrl.text.isEmpty || _newCtrl.text.isEmpty || _confirmCtrl.text.isEmpty) {
      _snack('Missing Fields', 'Please fill in all password fields');
      return;
    }
    if (_newCtrl.text != _confirmCtrl.text) {
      _snack('Password Mismatch', 'New password and confirm password do not match');
      return;
    }
    controller.changePassword(
      oldPassword: _oldCtrl.text.trim(),
      newPassword: _newCtrl.text.trim(),
      confirmPassword: _confirmCtrl.text.trim(),
    );
  }

  void _snack(String title, String msg) {
    Get.snackbar(
      title, msg,
      backgroundColor: const Color(0xFFEF4444),
      colorText: Colors.white,
      borderRadius: 14,
      margin: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      snackPosition: SnackPosition.TOP,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
    );
  }
}