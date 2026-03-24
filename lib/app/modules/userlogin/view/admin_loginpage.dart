
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/admin_logincontroller.dart';

// ─── Design tokens ────────────────────────────────────────────────────────────
class _T {
  static const surface = Color(0xFFFFFFFF);
  static const bg      = Color(0xFFF5F7F9);
  static const divider = Color(0xFFEAEDF1);

  static const ink900 = Color(0xFF0D1117);
  static const ink600 = Color(0xFF4B5563);
  static const ink400 = Color(0xFF9CA3AF);

  static const adminColor    = Color(0xFF084E43); // Admin      – deep blue
  static const districtColor = Color(0xFF084E43); // District   – dark teal
  static const areaColor     = Color(0xFF084E43); // Area Admin – medium teal

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
  final IconData icon;
  final Color    color;
  const _AdminRole({
    required this.id,
    required this.name,
    required this.icon,
    required this.color,
  });
}

// role 3 = Admin | role 4 = District Admin | role 5 = Area Admin
const _adminRoles = [
  _AdminRole(
    id: 3,
    name: 'Admin',
    icon: Icons.admin_panel_settings_outlined,
    color: _T.adminColor,
  ),
  _AdminRole(
    id: 4,
    name: 'District Admin',
    icon: Icons.account_balance_outlined,
    color: _T.districtColor,
  ),
  _AdminRole(
    id: 5,
    name: 'Area Admin',
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

  // ── Controller ───────────────────────────────────────────────────────────
  final AdminLoginController _ctrl = Get.put(AdminLoginController());

  // ── Form key ─────────────────────────────────────────────────────────────
  final _formKey = GlobalKey<FormState>();

  // ── Stagger animation ─────────────────────────────────────────────────────
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
      const Offset(0, -0.4),  // badge   – drops from top
      const Offset(0,  0.3),  // title   – rises from below
      const Offset(-0.2, 0),  // selector – slides from left
      const Offset(0,  0.35), // card    – rises from below
      const Offset(0,  0.2),  // bottom  – gentle rise
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
      _adminRoles.firstWhere((r) => r.id == id,
          orElse: () => _adminRoles.first);

  // ─── Build ────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final role = _activeRole(_ctrl.selectedRole.value);
      return Scaffold(
        body: AnimatedContainer(
          duration: const Duration(milliseconds: 380),
          color: role.color.withOpacity(0.04),
          child: SafeArea(
            child: Center(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(
                    horizontal: 24, vertical: 40),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _reveal(0, _buildBadge(role)),
                    const SizedBox(height: 32),
                    _reveal(1, _buildTitleBlock(role)),
                    const SizedBox(height: 40),
                    _reveal(2, _buildRoleSelector(role)),
                    const SizedBox(height: 24),
                    _reveal(3, _buildLoginCard(role)),
                    const SizedBox(height: 16),

                  ],
                ),
              ),
            ),
          ),
        ),
      );
    });
  }

  // ─── Badge ────────────────────────────────────────────────────────────────
  Widget _buildBadge(_AdminRole role) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 320),
      curve: Curves.easeOutCubic,
      width: 88,
      height: 88,
      decoration: BoxDecoration(
        color: role.color,
        borderRadius: BorderRadius.circular(28),
        boxShadow: _T.accentShadow(role.color),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned.fill(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(28),
              child: CustomPaint(painter: _RingPainter(role.color)),
            ),
          ),
          Icon(role.icon, color: Colors.white, size: 38),
        ],
      ),
    );
  }

  // ─── Title block ──────────────────────────────────────────────────────────
  Widget _buildTitleBlock(_AdminRole role) {
    return Column(
      children: [
        const Text(
          "eShoppy Admin",
          style: TextStyle(
            fontSize: 34,
            fontWeight: FontWeight.w800,
            color: _T.ink900,
            letterSpacing: -1.5,
            height: 1.1,
          ),
        ),
        const SizedBox(height: 8),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 260),
          child: Text(
            "Sign in as ${role.name}",
            key: ValueKey(role.id),
            style: const TextStyle(
              fontSize: 15,
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
  Widget _buildRoleSelector(_AdminRole activeRole) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 2, bottom: 12),
          child: Text(
            "ADMIN TYPE",
            style: TextStyle(
              fontSize: 12,
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
              return Expanded(
                child: GestureDetector(
                  onTap: () => _ctrl.setRole(role.id), // ← controller call
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 280),
                    curve: Curves.easeOutCubic,
                    margin: EdgeInsets.only(right: isLast ? 0 : 4),
                    padding: const EdgeInsets.symmetric(vertical: 13),
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
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          role.icon,
                          size: 17,
                          color: isSelected ? Colors.white : _T.ink400,
                        ),
                        const SizedBox(width: 7),
                        Text(
                          role.name,
                          style: TextStyle(
                            fontSize: 13,
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
        const SizedBox(height: 8),

       ],
    );
  }

  // ─── Login card ───────────────────────────────────────────────────────────
  Widget _buildLoginCard(_AdminRole activeRole) {
    return Container(
      decoration: BoxDecoration(
        color: _T.surface,
        borderRadius: BorderRadius.circular(24),
        boxShadow: _T.cardShadow,
      ),
      padding: const EdgeInsets.fromLTRB(24, 28, 24, 28),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Email ──────────────────────────────────────────────────────
            _buildLabel("Email address"),
            const SizedBox(height: 8),
            _buildTextField(
              controller: _ctrl.emailCtrl,
              icon: Icons.alternate_email_rounded,
              keyboardType: TextInputType.emailAddress,
              activeColor: activeRole.color,
              validator: (v) {
                if (v == null || v.isEmpty) return "Email is required";
                if (!GetUtils.isEmail(v)) return "Enter a valid email";
                return null;
              },
            ),
            const SizedBox(height: 20),

            // ── Password ───────────────────────────────────────────────────
            _buildLabel("Password"),
            const SizedBox(height: 8),
            Obx(() => _buildTextField(
              controller: _ctrl.passwordCtrl,
              icon: Icons.lock_outline_rounded,
              obscure: !_ctrl.isPasswordVisible.value,
              activeColor: activeRole.color,
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
            const SizedBox(height: 28),

            // ── Submit ─────────────────────────────────────────────────────
            _buildSubmitButton(activeRole),
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String text) => Text(
    text,
    style: const TextStyle(
      fontSize: 13,
      fontWeight: FontWeight.w600,
      color: _T.ink600,
      letterSpacing: 0.1,
    ),
  );

  Widget _buildTextField({
    required TextEditingController controller,
    required IconData icon,
    required Color activeColor,
    TextInputType keyboardType = TextInputType.text,
    bool obscure = false,
    Widget? suffix,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscure,
      keyboardType: keyboardType,
      style: const TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w500,
        color: _T.ink900,
      ),
      validator: validator,
      decoration: InputDecoration(
        hintStyle: const TextStyle(
            color: _T.ink400, fontSize: 14, fontWeight: FontWeight.w400),
        prefixIcon: Icon(icon, size: 18, color: _T.ink400),
        suffixIcon: suffix,
        filled: true,
        fillColor: _T.bg,
        contentPadding: const EdgeInsets.symmetric(vertical: 16),
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
          borderSide:
          const BorderSide(color: Color(0xFFEF4444), width: 1.5),
        ),
      ),
    );
  }

  Widget _buildSubmitButton(_AdminRole activeRole) {
    return Obx(() {
      final loading = _ctrl.isLoading.value;
      return AnimatedContainer(
        duration: const Duration(milliseconds: 280),
        width: double.infinity,
        height: 52,
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
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 15,
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



  // ─── Logic ────────────────────────────────────────────────────────────────
  void _handleLogin() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    _ctrl.submit(); // ← controller handles API + navigation
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