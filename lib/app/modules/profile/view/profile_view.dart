
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../../common/style/app_colors.dart';
import '../../myoders/myoders/myodersview.dart';
import '../../userlogin/view/useredit_profile.dart';
import '../controller/editprofile_controller.dart';
import 'user_changepswd.dart';
import '../../../core/utils/auth_service.dart';

class ProfileView extends StatelessWidget {
  ProfileView({super.key});

  final EditProfileController controller = Get.put(EditProfileController());

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
          automaticallyImplyLeading: false,
          title: const Text(
            'My Profile',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.notifications_outlined, color: Colors.white),
              onPressed: () {},
            ),
            const SizedBox(width: 4),
          ],
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ─── PROFILE HERO CARD ──────────────────────────────────
              Obx(() {
                final user = controller.profile.value;
                if (user == null) {
                  return const SizedBox(
                    height: 120,
                    child: Center(child: CircularProgressIndicator()),
                  );
                }
                return _buildProfileHeroCard(user);
              }),

              const SizedBox(height: 16),

              // ─── STATS ROW ──────────────────────────────────────────
              _buildStatsRow(),

              const SizedBox(height: 24),

              // ─── ACCOUNT SECTION ────────────────────────────────────
              _sectionHeader('Account'),
              const SizedBox(height: 12),
              _buildMenuGroup([
                _MenuTile(
                  icon: Icons.person_outline_rounded,
                  title: 'Edit Profile',
                  subtitle: 'Update your personal info',
                  color: const Color(0xFF6366F1),
                  onTap: () => Get.to(() => EditProfilePage()),
                ),
                _MenuTile(
                  icon: Icons.shopping_bag_outlined,
                  title: 'My Orders',
                  subtitle: 'Track & view your orders',
                  color: const Color(0xFF3B82F6),
                  onTap: () => Get.to(() => Myodersview()),
                ),
                _MenuTile(
                  icon: Icons.lock_outline_rounded,
                  title: 'Change Password',
                  subtitle: 'Keep your account secure',
                  color: const Color(0xFF10B981),
                  onTap: () => Get.to(() => ChangePasswordPage()),
                ),
              ]),

              const SizedBox(height: 20),

              // ─── SESSION SECTION ────────────────────────────────────
              _sectionHeader('Session'),
              const SizedBox(height: 12),
              _buildMenuGroup([
                _MenuTile(
                  icon: Icons.logout_rounded,
                  title: 'Log Out',
                  subtitle: 'Sign out of your account',
                  color: const Color(0xFFEF4444),
                  titleColor: const Color(0xFFEF4444),
                  onTap: AuthService.showLogoutDialog,
                ),
              ]),

              const SizedBox(height: 40),


            ],
          ),
        ),
      ),
    );
  }

  // ─── PROFILE HERO CARD ─────────────────────────────────────────────────────
  Widget _buildProfileHeroCard(dynamic user) {
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
              // Avatar
              Container(
                width: 74,
                height: 74,
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
                  radius: 35,
                  backgroundImage: user.profileImage.isNotEmpty
                      ? NetworkImage(user.profileImage)
                      : const AssetImage('assets/images/namsthe.png')
                  as ImageProvider,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user.fullName,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                        letterSpacing: -0.3,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      user.email,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white.withOpacity(0.75),
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.18),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text(
                        '✦  Member',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          letterSpacing: 0.4,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Edit button
              GestureDetector(
                onTap: () => Get.to(() => EditProfilePage()),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 14, vertical: 9),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Text(
                    'Edit',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: AppColors.kPrimary,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ─── STATS ROW ─────────────────────────────────────────────────────────────
  Widget _buildStatsRow() {
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
      child: Row(
        children: [
          _statItem('12', 'Orders', const Color(0xFF6366F1)),
          Container(width: 1, height: 36, color: Colors.grey[100]),
          _statItem('3', 'Wishlist', const Color(0xFFEC4899)),
          Container(width: 1, height: 36, color: Colors.grey[100]),
          _statItem('5', 'Reviews', const Color(0xFF10B981)),
        ],
      ),
    );
  }

  Widget _statItem(String value, String label, Color color) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 18),
        child: Column(
          children: [
            Text(
              value,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: color,
              ),
            ),
            const SizedBox(height: 3),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                color: Colors.grey[500],
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
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

  // ─── MENU GROUP ────────────────────────────────────────────────────────────
  Widget _buildMenuGroup(List<_MenuTile> tiles) {
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
              _buildMenuRow(tiles[i]),
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

  Widget _buildMenuRow(_MenuTile tile) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: tile.onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: tile.color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(tile.icon, color: tile.color, size: 22),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      tile.title,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: tile.titleColor,
                      ),
                    ),
                    if (tile.subtitle != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        tile.subtitle!,
                        style: TextStyle(
                            fontSize: 11.5, color: Colors.grey[500]),
                      ),
                    ],
                  ],
                ),
              ),
              Icon(Icons.chevron_right_rounded,
                  color: Colors.grey[300], size: 22),
            ],
          ),
        ),
      ),
    );
  }
}

class _MenuTile {
  final IconData icon;
  final String title;
  final String? subtitle;
  final Color color;
  final Color titleColor;
  final VoidCallback onTap;

  const _MenuTile({
    required this.icon,
    required this.title,
    this.subtitle,
    required this.color,
    this.titleColor = const Color(0xFF2D3748),
    required this.onTap,
  });
}