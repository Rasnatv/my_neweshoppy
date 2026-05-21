
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../widgets/backarrowwidget.dart';
import '../controller/admin_logincontroller.dart';

// ─── Design tokens ────────────────────────────────────────────────────────────
class _T {
  static const surface = Color(0xFFFFFFFF);
  static const bg      = Color(0xFFF5F7F9);
  static const divider = Color(0xFFEAEDF1);

  static const ink900 = Color(0xFF0D1117);
  static const ink600 = Color(0xFF4B5563);
  static const ink400 = Color(0xFF9CA3AF);

  static const adminColor    = Color(0xFF084E43);
  static const districtColor = Color(0xFF084E43);
  static const areaColor     = Color(0xFF084E43);

  static List<BoxShadow> cardShadow = [
    BoxShadow(
      color: Colors.black.withOpacity(0.06),
      blurRadius: 24,
      offset: const Offset(0, 8),
      spreadRadius: -4,
    ),
    BoxShadow(
      color: Colors.black.withOpacity(0.03),
      blurRadius: 8,
      offset: const Offset(0, 2),
    ),
  ];

  static List<BoxShadow> accentShadow(Color c) => [
    BoxShadow(
      color: c.withOpacity(0.32),
      blurRadius: 18,
      offset: const Offset(0, 6),
      spreadRadius: -3,
    ),
  ];
}

// ─── Admin role model ─────────────────────────────────────────────────────────
class _AdminRole {
  final int      id;
  final String   name;
  final String   shortName; // abbreviated label for small screens
  final IconData icon;
  final Color    color;
  const _AdminRole({
    required this.id,
    required this.name,
    required this.shortName,
    required this.icon,
    required this.color,
  });
}

const _adminRoles = [
  _AdminRole(
    id: 3,
    name: 'Admin',
    shortName: 'Admin',
    icon: Icons.admin_panel_settings_outlined,
    color: _T.adminColor,
  ),
  _AdminRole(
    id: 4,
    name: 'District Admin',
    shortName: 'District',
    icon: Icons.account_balance_outlined,
    color: _T.districtColor,
  ),
  _AdminRole(
    id: 5,
    name: 'Area Admin',
    shortName: 'Area',
    icon: Icons.map_outlined,
    color: _T.areaColor,
  ),
];

// ─── Screen ───────────────────────────────────────────────────────────────────
class AdminLoginScreen extends StatefulWidget {
  const AdminLoginScreen({super.key});

  @override
  State<AdminLoginScreen> createState() => _AdminLoginScreenState();
}

class _AdminLoginScreenState extends State<AdminLoginScreen>
    with TickerProviderStateMixin {

  final AdminLoginController _ctrl = Get.put(AdminLoginController());
  final _formKey = GlobalKey<FormState>();

  late final AnimationController _enter;
  late final List<Animation<double>> _fades;
  late final List<Animation<Offset>>  _slides;

  static const _count  = 5;
  static const _delays = [0.00, 0.12, 0.28, 0.42, 0.58];
  static const _ends   = [0.30, 0.40, 0.56, 0.72, 0.90];

  @override
  void initState() {
    super.initState();
    _enter = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    _fades = List.generate(
      _count,
          (i) => Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(
          parent: _enter,
          curve: Interval(_delays[i], _ends[i], curve: Curves.easeOut),
        ),
      ),
    );

    final offsets = [
      const Offset(0, -0.4),
      const Offset(0,  0.3),
      const Offset(-0.2, 0),
      const Offset(0,  0.35),
      const Offset(0,  0.2),
    ];
    _slides = List.generate(
      _count,
          (i) => Tween<Offset>(begin: offsets[i], end: Offset.zero).animate(
        CurvedAnimation(
          parent: _enter,
          curve: Interval(_delays[i], _ends[i], curve: Curves.easeOutCubic),
        ),
      ),
    );

    _enter.forward();
  }

  @override
  void dispose() {
    _enter.dispose();
    super.dispose();
  }

  Widget _reveal(int i, Widget child) => FadeTransition(
    opacity: _fades[i],
    child: SlideTransition(position: _slides[i], child: child),
  );

  _AdminRole _activeRole(int id) =>
      _adminRoles.firstWhere((r) => r.id == id, orElse: () => _adminRoles.first);

  @override
  Widget build(BuildContext context) {
    // ── MediaQuery values ────────────────────────────────────────────────────
    final mq         = MediaQuery.of(context);
    final screenW    = mq.size.width;
    final screenH    = mq.size.height;
    final isSmall    = screenH < 680;   // very compact phones (SE, etc.)
    final isMedium   = screenH < 780;   // normal phones
    // large = 780+         (tall phones)

    // Responsive spacing
    final vPadding   = isSmall ? 16.0  : isMedium ? 28.0  : 40.0;
    final hPadding   = screenW < 360   ? 16.0  : 24.0;
    final badgeSize  = isSmall ? 68.0  : isMedium ? 78.0  : 88.0;
    final badgeRadius= isSmall ? 20.0  : isMedium ? 24.0  : 28.0;
    final badgeIcon  = isSmall ? 28.0  : isMedium ? 33.0  : 38.0;
    final titleSize  = isSmall ? 26.0  : isMedium ? 30.0  : 34.0;
    final gap1       = isSmall ? 20.0  : isMedium ? 26.0  : 32.0;
    final gap2       = isSmall ? 28.0  : isMedium ? 34.0  : 40.0;
    final gap3       = isSmall ? 16.0  : isMedium ? 20.0  : 24.0;

    return Obx(() {
      final role = _activeRole(_ctrl.selectedRole.value);
      return
  //       Scaffold(
  //       body: AnimatedContainer(
  //         duration: const Duration(milliseconds: 380),
  //         color: role.color.withOpacity(0.04),
  //         child: SafeArea(
  //           child: Center(
  //             child: SingleChildScrollView(
  //               physics: const BouncingScrollPhysics(),
  //               padding: EdgeInsets.symmetric(
  //                 horizontal: hPadding,
  //                 vertical: vPadding,
  //               ),
  //               child: Column(
  //                 mainAxisAlignment: MainAxisAlignment.center,
  //                 children: [
  //                   _reveal(0, _buildBadge(role,
  //                       size: badgeSize,
  //                       radius: badgeRadius,
  //                       iconSize: badgeIcon)),
  //                   SizedBox(height: gap1),
  //                   _reveal(1, _buildTitleBlock(role, titleSize: titleSize, isSmall: isSmall)),
  //                   SizedBox(height: gap2),
  //                   _reveal(2, _buildRoleSelector(role, screenW: screenW, isSmall: isSmall)),
  //                   SizedBox(height: gap3),
  //                   _reveal(3, _buildLoginCard(role, isSmall: isSmall)),
  //                   const SizedBox(height: 16),
  //                 ],
  //               ),
  //             ),
  //           ),
  //         ),
  //       ),
  //     );
  //   });
  // }
      Scaffold(
        body: Stack(
          children: [
            // ── Main UI ─────────────────────────────────────────────
            AnimatedContainer(
              duration: const Duration(milliseconds: 380),
              color: role.color.withOpacity(0.04),
              child: SafeArea(
                child: Center(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: EdgeInsets.symmetric(
                      horizontal: hPadding,
                      vertical: vPadding,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _reveal(0, _buildBadge(role,
                            size: badgeSize,
                            radius: badgeRadius,
                            iconSize: badgeIcon)),

                        SizedBox(height: gap1),

                        _reveal(1, _buildTitleBlock(
                          role,
                          titleSize: titleSize,
                          isSmall: isSmall,
                        )),

                        SizedBox(height: gap2),

                        _reveal(2, _buildRoleSelector(
                          role,
                          screenW: screenW,
                          isSmall: isSmall,
                        )),

                        SizedBox(height: gap3),

                        _reveal(3, _buildLoginCard(
                          role,
                          isSmall: isSmall,
                        )),

                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // ── Use Your BackArrow Widget ───────────────────────────
            Positioned(
              top: MediaQuery.of(context).padding.top + 8,
              left: 12,
              child: const BackArrow(),
            ),
          ],
        ),
      );
    });
     }

  // ─── Badge ────────────────────────────────────────────────────────────────
  Widget _buildBadge(_AdminRole role, {
    required double size,
    required double radius,
    required double iconSize,
  }) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 320),
      curve: Curves.easeOutCubic,
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: role.color,
        borderRadius: BorderRadius.circular(radius),
        boxShadow: _T.accentShadow(role.color),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned.fill(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(radius),
              child: CustomPaint(painter: _RingPainter(role.color)),
            ),
          ),
          Icon(role.icon, color: Colors.white, size: iconSize),
        ],
      ),
    );
  }

  // ─── Title block ──────────────────────────────────────────────────────────
  Widget _buildTitleBlock(_AdminRole role, {
    required double titleSize,
    required bool isSmall,
  }) {
    return Column(
      children: [
        Text(
          "eShoppy Admin",
          style: TextStyle(
            fontSize: titleSize,
            fontWeight: FontWeight.w800,
            color: _T.ink900,
            letterSpacing: -1.2,
            height: 1.1,
          ),
        ),
        SizedBox(height: isSmall ? 4 : 8),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 260),
          child: Text(
            "Sign in as ${role.name}",
            key: ValueKey(role.id),
            style: TextStyle(
              fontSize: isSmall ? 13 : 15,
              fontWeight: FontWeight.w400,
              color: _T.ink400,
              letterSpacing: 0.1,
            ),
          ),
        ),
      ],
    );
  }

  // ─── Role selector ────────────────────────────────────────────────────────
  Widget _buildRoleSelector(_AdminRole activeRole, {
    required double screenW,
    required bool isSmall,
  }) {
    // On very narrow screens (< 360) we hide text labels inside the chips
    final hideLabel = screenW < 340;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 2, bottom: 10),
          child: Text(
            "ADMIN TYPE",
            style: TextStyle(
              fontSize: isSmall ? 11 : 12,
              fontWeight: FontWeight.w600,
              color: _T.ink400,
              letterSpacing: 0.8,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: _T.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: _T.divider, width: 1),
            boxShadow: _T.cardShadow,
          ),
          padding: const EdgeInsets.all(4),
          child: Row(
            children: _adminRoles.map((role) {
              final isSelected = _ctrl.selectedRole.value == role.id;
              final isLast     = role == _adminRoles.last;
              // Use shortName to save space
              final label = role.shortName;

              return Expanded(
                child: GestureDetector(
                  onTap: () => _ctrl.setRole(role.id),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 280),
                    curve: Curves.easeOutCubic,
                    margin: EdgeInsets.only(right: isLast ? 0 : 3),
                    padding: EdgeInsets.symmetric(
                      vertical: isSmall ? 10 : 13,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected ? role.color : Colors.transparent,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: isSelected
                          ? [
                        BoxShadow(
                          color: role.color.withOpacity(0.30),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ]
                          : null,
                    ),
                    child: hideLabel
                    // Icon-only on tiny screens
                        ? Center(
                      child: Icon(
                        role.icon,
                        size: 18,
                        color: isSelected ? Colors.white : _T.ink400,
                      ),
                    )
                        : Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          role.icon,
                          size: isSmall ? 15 : 17,
                          color: isSelected ? Colors.white : _T.ink400,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          label,
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: isSmall ? 10 : 11,
                            fontWeight: isSelected
                                ? FontWeight.w700
                                : FontWeight.w500,
                            color: isSelected ? Colors.white : _T.ink400,
                            letterSpacing: isSelected ? 0.1 : 0,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  // ─── Login card ───────────────────────────────────────────────────────────
  Widget _buildLoginCard(_AdminRole activeRole, {required bool isSmall}) {
    final cardPadH = isSmall ? 18.0 : 24.0;
    final cardPadV = isSmall ? 20.0 : 28.0;
    final fieldGap = isSmall ? 14.0 : 20.0;

    return Container(
      decoration: BoxDecoration(
        color: _T.surface,
        borderRadius: BorderRadius.circular(24),
        boxShadow: _T.cardShadow,
      ),
      padding: EdgeInsets.fromLTRB(cardPadH, cardPadV, cardPadH, cardPadV),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildLabel("Email address", isSmall: isSmall),
            const SizedBox(height: 8),
            _buildTextField(
              controller: _ctrl.emailCtrl,
              icon: Icons.email,
              keyboardType: TextInputType.emailAddress,
              activeColor: activeRole.color,
              isSmall: isSmall,
              validator: (v) {
                if (v == null || v.isEmpty) return "Email is required";
                if (!GetUtils.isEmail(v)) return "Enter a valid email";
                return null;
              },
            ),
            SizedBox(height: fieldGap),
            _buildLabel("Password", isSmall: isSmall),
            const SizedBox(height: 8),
            Obx(() => _buildTextField(
              controller: _ctrl.passwordCtrl,
              icon: Icons.lock_outline_rounded,
              obscure: !_ctrl.isPasswordVisible.value,
              activeColor: activeRole.color,
              isSmall: isSmall,
              suffix: IconButton(
                onPressed: _ctrl.togglePasswordVisibility,
                icon: Icon(
                  _ctrl.isPasswordVisible.value
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                  size: 18,
                  color: _T.ink400,
                ),
              ),
              validator: (v) {
                if (v == null || v.isEmpty) return "Password is required";
                if (v.length < 6) return "Minimum 6 characters";
                return null;
              },
            )),
            SizedBox(height: isSmall ? 20 : 28),
            _buildSubmitButton(activeRole, isSmall: isSmall),
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String text, {required bool isSmall}) => Text(
    text,
    style: TextStyle(
      fontSize: isSmall ? 12 : 13,
      fontWeight: FontWeight.w600,
      color: _T.ink600,
      letterSpacing: 0.1,
    ),
  );

  Widget _buildTextField({
    required TextEditingController controller,
    required IconData icon,
    required Color activeColor,
    required bool isSmall,
    TextInputType keyboardType = TextInputType.text,
    bool obscure = false,
    Widget? suffix,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscure,
      keyboardType: keyboardType,
      style: TextStyle(
        fontSize: isSmall ? 14 : 15,
        fontWeight: FontWeight.w500,
        color: _T.ink900,
      ),
      validator: validator,
      decoration: InputDecoration(
        hintStyle: TextStyle(
          color: _T.ink400,
          fontSize: isSmall ? 13 : 14,
          fontWeight: FontWeight.w400,
        ),
        prefixIcon: Icon(icon, size: 18, color: _T.ink400),
        suffixIcon: suffix,
        filled: true,
        fillColor: _T.bg,
        contentPadding: EdgeInsets.symmetric(vertical: isSmall ? 13 : 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: _T.divider, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: activeColor, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFEF4444), width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFEF4444), width: 1.5),
        ),
      ),
    );
  }

  Widget _buildSubmitButton(_AdminRole activeRole, {required bool isSmall}) {
    return Obx(() {
      final loading = _ctrl.isLoading.value;
      return AnimatedContainer(
        duration: const Duration(milliseconds: 280),
        width: double.infinity,
        height: isSmall ? 46 : 52,
        decoration: BoxDecoration(
          color: activeRole.color,
          borderRadius: BorderRadius.circular(14),
          boxShadow: _T.accentShadow(activeRole.color),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(14),
            splashColor: Colors.white.withOpacity(0.12),
            onTap: loading ? null : _handleLogin,
            child: Center(
              child: loading
                  ? const SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(
                    color: Colors.white, strokeWidth: 2.2),
              )
                  : Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Sign in as ${activeRole.name}",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: isSmall ? 14 : 15,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.2,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Icon(Icons.arrow_forward_rounded,
                      color: Colors.white, size: 18),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
  Widget _buildBackButton() {
    return Positioned(
      top: MediaQuery.of(context).padding.top + 8,
      left: 8,
      child: GestureDetector(
        onTap: () => Get.back(), // or Navigator.pop(context)
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: _T.cardShadow,
          ),
          child: const Icon(
            Icons.arrow_back_ios_new_rounded,
            size: 18,
            color: _T.ink900,
          ),
        ),
      ),
    );
  }

  void _handleLogin() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    _ctrl.submit();
  }
}

// ─── Ring painter ─────────────────────────────────────────────────────────────
class _RingPainter extends CustomPainter {
  final Color color;
  const _RingPainter(this.color);
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color       = Colors.white.withOpacity(0.10)
      ..style       = PaintingStyle.stroke
      ..strokeWidth = 1.2;
    final cx = size.width / 2;
    final cy = size.height / 2;
    for (final r in [
      size.width * 0.55,
      size.width * 0.75,
      size.width * 0.95,
    ]) {
      canvas.drawCircle(Offset(cx, cy), r, paint);
    }
  }
  @override
  bool shouldRepaint(_RingPainter old) => old.color != color;
}