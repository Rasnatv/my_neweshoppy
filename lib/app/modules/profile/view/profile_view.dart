
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

  // ── Palette ──────────────────────────────────────────────────────────────
  static const Color _bg      = Color(0xFFF5F6FA);
  static const Color _white   = Colors.white;
  static const Color _ink     = Color(0xFF0D0F14);
  static const Color _sub     = Color(0xFF6B7280);
  static const Color _muted   = Color(0xFFB0B7C3);
  static const Color _line    = Color(0xFFF0F1F5);
  static const Color _violet  = Color(0xFF6C5CE7);
  static const Color _blue    = Color(0xFF0EA5E9);
  static const Color _green   = Color(0xFF10B981);
  static const Color _rose    = Color(0xFFEF4444);
  static const Color _amber   = Color(0xFFF59E0B);

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: _bg,
        appBar: _buildAppBar(),
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Profile Card ────────────────────────────────────────
              Obx(() {
                final user = controller.profile.value;
                if (user == null) {
                  return const SizedBox(
                    height: 100,
                    child: Center(child: CircularProgressIndicator()),
                  );
                }
                return _ProfileCard(user: user);
              }),

              const SizedBox(height: 8),

              // ── Stats Bar ───────────────────────────────────────────
              _StatsBar(),

              const SizedBox(height: 20),

              // ── My Account ──────────────────────────────────────────
              _SectionLabel(label: 'My Account'),
              _MenuCard(tiles: [
                _Tile(
                  icon: Icons.person_outline_rounded,
                  label: 'Edit Profile',
                  sub: 'Name, phone & photo',
                  color: _violet,
                  onTap: () => Get.to(() => EditProfilePage()),
                ),
                _Tile(
                  icon: Icons.shopping_bag_outlined,
                  label: 'My Orders',
                  sub: 'Track & manage orders',
                  color: _blue,
                  onTap: () => Get.to(() => Myodersview()),
                ),
                _Tile(
                  icon: Icons.favorite_border_rounded,
                  label: 'Wishlist',
                  sub: 'Items you saved',
                  color: _rose,
                  onTap: () {},
                ),
              ]),

              const SizedBox(height: 20),

              // ── Settings ────────────────────────────────────────────
              _SectionLabel(label: 'Settings'),
              _MenuCard(tiles: [
                _Tile(
                  icon: Icons.lock_outline_rounded,
                  label: 'Change Password',
                  sub: 'Update your credentials',
                  color: _green,
                  onTap: () => Get.to(() => ChangePasswordPage()),
                ),
              ]),

              const SizedBox(height: 20),

              // ── Logout ──────────────────────────────────────────────
              _LogoutTile(onTap: AuthService.showLogoutDialog),

              const SizedBox(height: 36),
              const SizedBox(height: 20),
            ],
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
      title: const Text(
        'My Profile',
          style: TextStyle(
            color: Colors.white,
            fontSize: 17,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.1,
          )
      ),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Container(height: 1, color: _line),
      ),
    );
  }
}

// ── AppBar Icon ──────────────────────────────────────────────────────────────
class _AppBarIcon extends StatelessWidget {
  final IconData icon;
  final bool badge;
  final VoidCallback onTap;

  const _AppBarIcon({
    required this.icon,
    required this.onTap,
    this.badge = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: 40,
            height: 40,
            margin: const EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFFF5F6FA),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, size: 21, color: const Color(0xFF0D0F14)),
          ),
          if (badge)
            Positioned(
              top: 7,
              right: -1,
              child: Container(
                width: 9,
                height: 9,
                decoration: BoxDecoration(
                  color: const Color(0xFFEF4444),
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 1.5),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

// ── Profile Card ─────────────────────────────────────────────────────────────
class _ProfileCard extends StatelessWidget {
  final dynamic user;
  const _ProfileCard({required this.user});

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
          // ── Avatar ──────────────────────────────────────────────────
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
                  backgroundImage: user.profileImage.isNotEmpty
                      ? NetworkImage(user.profileImage)
                      : const AssetImage('assets/images/namsthe.png')
                  as ImageProvider,
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: GestureDetector(
                  onTap: () => Get.to(() => EditProfilePage()),
                  child: Container(
                    width: 22,
                    height: 22,
                    decoration: BoxDecoration(
                      color: AppColors.kPrimary,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    child: const Icon(
                        Icons.edit, size: 11, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(width: 16),

          // ── Info ────────────────────────────────────────────────────
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user.fullName,
                  style: const TextStyle(
                    fontSize: 18,              // was 16
                    fontWeight: FontWeight.w900, // was w800
                    color: Color(0xFF1A202C),   // was 0xFF0D0F14
                    letterSpacing: -0.4,        // was -0.3
                  ),
                ),
                const SizedBox(height: 3),
                Row(
                  children: [
                    Icon(Icons.mail_outline,
                        size: 12, color: Colors.grey[400]),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        user.email,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500, // was w400 (default)
                          color: Color(0xFF6B7280),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    _badge(
                      icon: Icons.verified_rounded,
                      label: 'Verified',
                      bg: const Color(0xFFEEFDF5),
                      fg: const Color(0xFF10B981),
                    ),
                    const SizedBox(width: 8),
                    _badge(
                      icon: Icons.workspace_premium_rounded,
                      label: 'Member',
                      bg: const Color(0xFFF3F0FF),
                      fg: const Color(0xFF6C5CE7),
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

  Widget _badge({
    required IconData icon,
    required String label,
    required Color bg,
    required Color fg,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 11, color: fg),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w800, // was w700
              color: fg,
              letterSpacing: 0.2,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Stats Bar ────────────────────────────────────────────────────────────────
class _StatsBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 16,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          _statCell('12', 'Orders', const Color(0xFF0EA5E9)),
          _vline(),
          _statCell('3', 'Wishlist', const Color(0xFFEF4444)),
          _vline(),
          _statCell('3', 'Cart Items', const Color(0xFFEF4444)),
        ],
      ),
    );
  }

  Widget _vline() => Container(
    width: 1,
    height: 32,
    color: const Color(0xFFF0F1F5),
  );

  Widget _statCell(String value, String label, Color color) {
    return Expanded(
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 22,              // was 20
              fontWeight: FontWeight.w900, // was w800
              color: color,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            label,
            style: const TextStyle(
              fontSize: 11,              // was 10.5
              color: Color(0xFF6B7280),
              fontWeight: FontWeight.w600, // was w500
            ),
          ),
        ],
      ),
    );
  }
}

// ── Section Label ─────────────────────────────────────────────────────────────
class _SectionLabel extends StatelessWidget {
  final String label;
  const _SectionLabel({required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 8),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 14,              // was 13
          fontWeight: FontWeight.w800,
          color: Color(0xFF1A202C),  // was 0xFF0D0F14
          letterSpacing: 0.1,
        ),
      ),
    );
  }
}

// ── Menu Card ─────────────────────────────────────────────────────────────────
class _MenuCard extends StatelessWidget {
  final List<_Tile> tiles;
  const _MenuCard({required this.tiles});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
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
          children: List.generate(tiles.length, (i) {
            final isLast = i == tiles.length - 1;
            return Column(
              children: [
                _TileRow(tile: tiles[i]),
                if (!isLast)
                  const Padding(
                    padding: EdgeInsets.only(left: 72),
                    child: Divider(
                      height: 1,
                      thickness: 0.8,
                      color: Color(0xFFF0F1F5),
                    ),
                  ),
              ],
            );
          }),
        ),
      ),
    );
  }
}

class _TileRow extends StatelessWidget {
  final _Tile tile;
  const _TileRow({required this.tile});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: tile.onTap,
        splashColor: tile.color.withOpacity(0.05),
        highlightColor: tile.color.withOpacity(0.03),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
          child: Row(
            children: [
              // Icon box
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: tile.color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(13),
                ),
                child: Icon(tile.icon, color: tile.color, size: 20),
              ),
              const SizedBox(width: 14),
              // Labels
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      tile.label,
                      style: const TextStyle(
                        fontSize: 14,              // was 13.5
                        fontWeight: FontWeight.w800, // was w700
                        color: Color(0xFF1A202C),   // was 0xFF0D0F14
                        letterSpacing: -0.2,        // was -0.1
                      ),
                    ),
                    if (tile.sub != null) ...[
                      const SizedBox(height: 1.5),
                      Text(
                        tile.sub!,
                        style: const TextStyle(
                          fontSize: 12,              // was 11.5
                          color: Color(0xFF6B7280),
                          fontWeight: FontWeight.w500, // was w400
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              // Chevron
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

// ── Logout Tile ───────────────────────────────────────────────────────────────
class _LogoutTile extends StatelessWidget {
  final VoidCallback onTap;
  const _LogoutTile({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
            color: const Color(0xFFEF4444).withOpacity(0.18)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFEF4444).withOpacity(0.04),
            blurRadius: 16,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            splashColor: const Color(0xFFEF4444).withOpacity(0.06),
            highlightColor: const Color(0xFFEF4444).withOpacity(0.03),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: 16, vertical: 14),
              child: Row(
                children: [
                  Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: const Color(0xFFEF4444).withOpacity(0.09),
                      borderRadius: BorderRadius.circular(13),
                    ),
                    child: const Icon(Icons.logout_rounded,
                        color: Color(0xFFEF4444), size: 20),
                  ),
                  const SizedBox(width: 14),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Log Out',
                          style: TextStyle(
                            fontSize: 14,              // was 13.5
                            fontWeight: FontWeight.w800, // was w700
                            color: Color(0xFFEF4444),
                            letterSpacing: -0.2,        // was -0.1
                          ),
                        ),
                        SizedBox(height: 1.5),
                        Text(
                          'Sign out of your account',
                          style: TextStyle(
                            fontSize: 12,              // was 11.5
                            fontWeight: FontWeight.w500, // was default w400
                            color: Color(0xFF6B7280),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.chevron_right_rounded,
                      size: 20, color: Color(0xFFEF4444)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ── Data Models ───────────────────────────────────────────────────────────────
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