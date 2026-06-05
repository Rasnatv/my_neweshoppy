
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../common/style/app_colors.dart';
import '../../../core/utils/auth_service.dart';
import '../../../widgets/networkconnection_checkpage.dart';

import '../../myoders/myoders/myodersview.dart';
import '../../userhome/controller/user_deleteaccountcontroller.dart';
import '../../userlogin/view/useredit_profile.dart';
import '../../userrestaurantreservationview/userview_restaurantreservations.dart';
import '../../whishlist/view/whishlist_view.dart';

import '../controller/editprofile_controller.dart';
import 'user_changepswd.dart';

class ProfileView extends StatelessWidget {
  ProfileView({super.key});

  final EditProfileController controller =
  Get.put(EditProfileController());

  // ── Palette ───────────────────────────────────────────
  static const Color _bg = Color(0xFFF5F6FA);
  static const Color _line = Color(0xFFF0F1F5);

  static const Color _violet = Color(0xFF6C5CE7);
  static const Color _blue = Color(0xFF0EA5E9);
  static const Color _green = Color(0xFF10B981);
  static const Color _rose = Color(0xFFEF4444);

  @override
  Widget build(BuildContext context) {
    // ✅ Fetch profile only once
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (controller.profile.value == null &&
          !controller.isLoading.value) {
        controller.fetchProfile();
      }
    });

    // ✅ Check auth token
    final bool hasToken =
        AuthService.box.read('auth_token') != null;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
      child: NetworkAwareWrapper(
        child: Scaffold(
          backgroundColor: _bg,
          appBar: _buildAppBar(),
          body: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                // ── Profile ─────────────────────────────
                Obx(() {
                  if (controller.isLoading.value) {
                    return const SizedBox(
                      height: 100,
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }

                  if (controller.profile.value == null) {
                    return const SizedBox(
                      height: 100,
                      child: Center(
                        child: Text("No profile data"),
                      ),
                    );
                  }

                  return _ProfileCard(
                    user: controller.profile.value,
                  );
                }),

                const SizedBox(height: 8),

                // ── My Account ─────────────────────────
                _SectionLabel(label: 'My Account'),

                _MenuCard(
                  tiles: [
                    _Tile(
                      icon: Icons.person_outline_rounded,
                      label: 'Edit Profile',
                      sub: 'Name, phone & photo',
                      color: _violet,
                      onTap: () =>
                          Get.to(() => EditProfilePage()),
                    ),

                    _Tile(
                      icon: Icons.shopping_bag_outlined,
                      label: 'My Orders',
                      sub: 'View orders',
                      color: _blue,
                      onTap: () =>
                          Get.to(() => MyOrdersView()),
                    ),

                    _Tile(
                      icon: Icons.favorite_border_rounded,
                      label: 'Wishlist',
                      sub: 'Items you saved',
                      color: _rose,
                      onTap: () =>
                          Get.to(() => WishlistScreen()),
                    ),

                    _Tile(
                      icon: Icons.shopping_bag_outlined,
                      label: 'Restaurant Bookings',
                      sub:
                      'View & manage restaurant reservations',
                      color: _blue,
                      onTap: () =>
                          Get.to(() => BookedOrdersPage()),
                    ),

                  ],
                ),

                const SizedBox(height: 20),

                // ── Settings (Only if token exists) ───
                if (hasToken) ...[
                  _SectionLabel(label: 'Settings'),

                  _MenuCard(
                    tiles: [
                      _Tile(
                        icon: Icons.lock_outline_rounded,
                        label: 'Change Password',
                        sub: 'Update your credentials',
                        color: _green,
                        onTap: () => Get.to(
                              () => ChangePasswordPage(),
                        ),

                      ),
                      _Tile(
                        icon: Icons.delete_outline_rounded,
                        label: 'Delete Account',
                        sub: 'Permanently remove your account and all data',
                        color: Colors.red,
                        onTap: () => _showDeleteConfirmDialog(),
                      ),
                        ],
                  ),

                  const SizedBox(height: 20),


                ],

                // ── Logout (Only if token exists) ──────
                  _LogoutTile(
                    onTap: AuthService.showLogoutDialog,
                  ),

                const SizedBox(height: 200),
              ],
            ),
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: AppColors.kPrimary,
      automaticallyImplyLeading: false,
      systemOverlayStyle: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
      titleSpacing: 20,
      centerTitle: false,
      title: const Text(
        'My Profile',
        style: TextStyle(
          color: Colors.white,
          fontSize: 17,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.1,
        ),
      ),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Container(
          height: 1,
          color: _line,
        ),
      ),
    );
  }
}

// ── Profile Card ───────────────────────────────────────
class _ProfileCard extends StatelessWidget {
  final dynamic user;

  const _ProfileCard({
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [

          // ── Avatar ────────────────────────────────
          Stack(
            children: [
              Container(
                width: 70,
                height: 70,
                padding: const EdgeInsets.all(2.5),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [
                      AppColors.kPrimary,
                      AppColors.kPrimary.withOpacity(0.5),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: CircleAvatar(
                  radius: 32,
                  backgroundImage:
                  user.profileImage.isNotEmpty
                      ? NetworkImage(user.profileImage)
                      : const AssetImage(
                      'assets/images/namsthe.png')
                  as ImageProvider,
                ),
              ),

              Positioned(
                bottom: 0,
                right: 0,
                child: GestureDetector(
                  onTap: () =>
                      Get.to(() => EditProfilePage()),
                  child: Container(
                    width: 22,
                    height: 22,
                    decoration: BoxDecoration(
                      color: AppColors.kPrimary,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white,
                        width: 2,
                      ),
                    ),
                    child: const Icon(
                      Icons.edit,
                      size: 11,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(width: 16),

          // ── User Info ─────────────────────────────
          Expanded(
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [

                Text(
                  user.fullName,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF1A202C),
                    letterSpacing: -0.4,
                  ),
                ),

                const SizedBox(height: 3),

                Row(
                  children: [

                    const SizedBox(width: 4),

                    Expanded(
                      child: Text(
                        user.email,
                        overflow:
                        TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight:
                          FontWeight.w500,
                          color: Color(0xFF6B7280),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Section Label ──────────────────────────────────────
class _SectionLabel extends StatelessWidget {
  final String label;

  const _SectionLabel({
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
      const EdgeInsets.fromLTRB(20, 0, 20, 8),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w800,
          color: Color(0xFF1A202C),
          letterSpacing: 0.1,
        ),
      ),
    );
  }
}

// ── Menu Card ──────────────────────────────────────────
class _MenuCard extends StatelessWidget {
  final List<_Tile> tiles;

  const _MenuCard({
    required this.tiles,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin:
      const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 16,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: Column(
          children: List.generate(
            tiles.length,
                (i) {
              final isLast =
                  i == tiles.length - 1;

              return Column(
                children: [

                  _TileRow(tile: tiles[i]),

                  if (!isLast)
                    const Padding(
                      padding:
                      EdgeInsets.only(left: 72),
                      child: Divider(
                        height: 1,
                        thickness: 0.8,
                        color:
                        Color(0xFFF0F1F5),
                      ),
                    ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

// ── Tile Row ───────────────────────────────────────────
class _TileRow extends StatelessWidget {
  final _Tile tile;

  const _TileRow({
    required this.tile,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: tile.onTap,
        splashColor:
        tile.color.withOpacity(0.05),
        highlightColor:
        tile.color.withOpacity(0.03),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 13,
          ),
          child: Row(
            children: [

              // Icon
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color:
                  tile.color.withOpacity(0.1),
                  borderRadius:
                  BorderRadius.circular(13),
                ),
                child: Icon(
                  tile.icon,
                  color: tile.color,
                  size: 20,
                ),
              ),

              const SizedBox(width: 14),

              // Texts
              Expanded(
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [

                    Text(
                      tile.label,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight:
                        FontWeight.w800,
                        color:
                        Color(0xFF1A202C),
                        letterSpacing: -0.2,
                      ),
                    ),

                    if (tile.sub != null) ...[
                      const SizedBox(height: 1.5),

                      Text(
                        tile.sub!,
                        style: const TextStyle(
                          fontSize: 12,
                          color:
                          Color(0xFF6B7280),
                          fontWeight:
                          FontWeight.w500,
                        ),
                      ),
                    ],
                  ],
                ),
              ),

              // Arrow
              const Icon(
                Icons.chevron_right_rounded,
                size: 20,
                color: Color(0xFFB0B7C3),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Logout Tile ────────────────────────────────────────
class _LogoutTile extends StatelessWidget {
  final VoidCallback onTap;

  const _LogoutTile({
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin:
      const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: const Color(0xFFEF4444)
              .withOpacity(0.18),
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            child: Padding(
              padding:
              const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
              child: Row(
                children: [

                  Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: const Color(
                          0xFFEF4444)
                          .withOpacity(0.09),
                      borderRadius:
                      BorderRadius.circular(13),
                    ),
                    child: const Icon(
                      Icons.logout_rounded,
                      color: Color(0xFFEF4444),
                      size: 20,
                    ),
                  ),

                  const SizedBox(width: 14),

                  const Expanded(
                    child: Column(
                      crossAxisAlignment:
                      CrossAxisAlignment.start,
                      children: [

                        Text(
                          'Log Out',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight:
                            FontWeight.w800,
                            color:
                            Color(0xFFEF4444),
                            letterSpacing: -0.2,
                          ),
                        ),

                        SizedBox(height: 1.5),

                        Text(
                          'Sign out of your account',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight:
                            FontWeight.w500,
                            color:
                            Color(0xFF6B7280),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const Icon(
                    Icons.chevron_right_rounded,
                    size: 20,
                    color: Color(0xFFEF4444),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
void _showDeleteConfirmDialog() {
  final controller = Get.put(DeleteUserAccountController());

  Get.dialog(
    PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) Get.back();
      },
      child: Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: Colors.white,
        insetPadding: const EdgeInsets.symmetric(horizontal: 40),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 28, 24, 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.delete_outline_rounded,
                  color: Colors.red.shade400,
                  size: 30,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Delete Account?',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              Text(
                'This will permanently remove your account and all associated data. This action cannot be undone.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey.shade600,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Get.back(),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        side: BorderSide(color: Colors.grey.shade300),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        'Cancel',
                        style: TextStyle(color: Colors.black87),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Obx(
                          () => ElevatedButton(
                        onPressed: controller.isLoading.value
                            ? null
                            : () => controller.deleteAccount(),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red.shade400,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: controller.isLoading.value
                            ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                            : const Text('Delete'),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    ),
    barrierDismissible: true, // ✅ also change this to true
    barrierColor: Colors.black54,

  );
}
// ── Tile Model ─────────────────────────────────────────
class _Tile {
  final IconData icon;
  final String label;
  final String? sub;
  final Color color;
  final VoidCallback onTap;

  const _Tile({
    required this.icon,
    required this.label,
    this.sub,
    required this.color,
    required this.onTap,
  });
}