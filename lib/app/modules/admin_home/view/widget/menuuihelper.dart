import 'package:flutter/material.dart';

import '../../../../common/style/app_colors.dart';

// ─── Design System ────────────────────────────────────────────────────────────
class DS {
  static const bg           = Color(0xFFF5F6FA);
  static const textPrimary  = Color(0xFF1A1D2E);
  static const textSub      = Color(0xFF5C6080);
  static const success      = Color(0xFF1DA87A);
  static const mealBreakfast = Color(0xFFE07B00);
  static const mealLunch     = Color(0xFF0AA0A0);
  static const mealDinner    = Color(0xFF7B4FA6);
}

Color mealColor(String m) {
  switch (m) {
    case 'breakfast': return DS.mealBreakfast;
    case 'lunch':     return DS.mealLunch;
    case 'dinner':    return DS.mealDinner;
    default:          return AppColors.kPrimary;
  }
}

IconData mealIcon(String m) {
  switch (m) {
    case 'breakfast': return Icons.free_breakfast_outlined;
    case 'lunch':     return Icons.lunch_dining_outlined;
    case 'dinner':    return Icons.dinner_dining_outlined;
    default:          return Icons.restaurant_outlined;
  }
}

// ─── Gradient Strip ───────────────────────────────────────────────────────────
Widget gradientStrip() => Container(
  height: 8,
  decoration: BoxDecoration(
    gradient: LinearGradient(
      colors: [AppColors.kPrimary, AppColors.kPrimary.withOpacity(0.6)],
    ),
  ),
);

// ─── Card Container ───────────────────────────────────────────────────────────
Widget buildCard({required Widget child}) => Container(
  width: double.infinity,
  padding: const EdgeInsets.all(20),
  margin: const EdgeInsets.only(bottom: 20),
  decoration: BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(16),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.04),
        blurRadius: 10,
        offset: const Offset(0, 2),
      ),
    ],
  ),
  child: child,
);

// ─── Section Header ───────────────────────────────────────────────────────────
Widget sectionHeader({
  required IconData icon,
  required String title,
  String? subtitle,
  Color? iconColor,
}) =>
    Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: (iconColor ?? AppColors.kPrimary).withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: iconColor ?? AppColors.kPrimary, size: 20),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(title,
              style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: Colors.black87)),
        ),
      ]),
      if (subtitle != null) ...[
        const SizedBox(height: 6),
        Padding(
          padding: const EdgeInsets.only(left: 44),
          child: Text(subtitle,
              style: TextStyle(fontSize: 13, color: Colors.grey.shade500)),
        ),
      ],
    ]);

// ─── Text Field ───────────────────────────────────────────────────────────────
Widget modernTextField({
  required TextEditingController controller,
  required String label,
  required String hint,
  required IconData icon,
  TextInputType? keyboardType,
  int maxLines = 1,
  Color? accentColor,
}) =>
    TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      style: const TextStyle(fontSize: 15),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon, size: 22),
        filled: true,
        fillColor: Colors.grey.shade50,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
              color: accentColor ?? AppColors.kPrimary, width: 2),
        ),
        contentPadding:
        const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
    );

// ─── Dropdown ─────────────────────────────────────────────────────────────────
Widget modernDropdown<T>({
  required String label,
  required IconData icon,
  required T value,
  required List<T> items,
  required String Function(T) itemLabel,
  required ValueChanged<T?> onChanged,
}) =>
    DropdownButtonFormField<T>(
      value: value,
      dropdownColor: Colors.white,
      style: const TextStyle(color: DS.textPrimary, fontSize: 15),
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, size: 22),
        filled: true,
        fillColor: Colors.grey.shade50,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.kPrimary, width: 2),
        ),
        contentPadding:
        const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
      items: items
          .map((e) => DropdownMenuItem(value: e, child: Text(itemLabel(e))))
          .toList(),
      onChanged: onChanged,
    );

// ─── Time Picker Field ────────────────────────────────────────────────────────
Widget pickerField({
  required String label,
  required TextEditingController controller,
  required IconData icon,
  required VoidCallback onTap,
  Color? accentColor,
}) =>
    ValueListenableBuilder<TextEditingValue>(
      valueListenable: controller,
      builder: (_, value, __) => InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: InputDecorator(
          decoration: InputDecoration(
            labelText: label,
            prefixIcon: Icon(icon,
                size: 22, color: accentColor ?? AppColors.kPrimary),
            suffixIcon: Icon(Icons.arrow_drop_down,
                size: 28, color: accentColor ?? AppColors.kPrimary),
            filled: true,
            fillColor: Colors.grey.shade50,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          ),
          child: Text(
            value.text.isEmpty ? 'Select $label' : value.text,
            style: TextStyle(
              fontSize: 15,
              color: value.text.isEmpty ? Colors.grey.shade500 : Colors.black87,
              fontWeight:
              value.text.isEmpty ? FontWeight.w400 : FontWeight.w500,
            ),
          ),
        ),
      ),
    );

// ─── Primary Button ───────────────────────────────────────────────────────────
Widget primaryBtn({
  required String label,
  required IconData icon,
  required bool loading,
  VoidCallback? onPressed,
  Color? color,
}) {
  final c = color ?? AppColors.kPrimary;
  return Container(
    width: double.infinity,
    height: 54,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(12),
      gradient: LinearGradient(
        colors: onPressed == null
            ? [Colors.grey.shade400, Colors.grey.shade300]
            : [c, c.withOpacity(0.8)],
      ),
      boxShadow: onPressed != null
          ? [
        BoxShadow(
            color: c.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 6))
      ]
          : [],
    ),
    child: ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      icon: loading
          ? const SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(
              color: Colors.white, strokeWidth: 2.5))
          : Icon(icon, size: 20),
      label: Text(loading ? 'Saving…' : label,
          style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.5)),
      onPressed: onPressed,
    ),
  );
}

// ─── Outlined Button ──────────────────────────────────────────────────────────
Widget outlinedBtn({
  required String label,
  required IconData icon,
  required VoidCallback onPressed,
}) =>
    OutlinedButton.icon(
      style: OutlinedButton.styleFrom(
        foregroundColor: Colors.grey.shade600,
        side: BorderSide(color: Colors.grey.shade300, width: 1.5),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        padding: const EdgeInsets.symmetric(vertical: 14),
      ),
      icon: Icon(icon, size: 18),
      label: Text(label,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
      onPressed: onPressed,
    );

// ─── Loading Indicator ────────────────────────────────────────────────────────
Widget loadingIndicator() => const Center(
  child: Padding(
    padding: EdgeInsets.all(32),
    child: CircularProgressIndicator(color: AppColors.kPrimary),
  ),
);

// ─── Empty State ──────────────────────────────────────────────────────────────
Widget emptyState({
  required IconData icon,
  required String message,
  String? sub,
}) =>
    Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 32),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 32, color: Colors.grey.shade400),
          ),
          const SizedBox(height: 16),
          Text(message,
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey.shade500)),
          if (sub != null) ...[
            const SizedBox(height: 4),
            Text(sub,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12, color: Colors.grey.shade400)),
          ],
        ]),
      ),
    );

// ─── Mode Toggle ──────────────────────────────────────────────────────────────
Widget modeToggle({
  required String leftLabel,
  required String rightLabel,
  required IconData leftIcon,
  required IconData rightIcon,
  required bool isAddMode,
  required ValueChanged<bool> onToggle,
}) =>
    Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 2)),
        ],
      ),
      padding: const EdgeInsets.all(6),
      child: Row(children: [
        Expanded(
          child: _toggleBtn(
            label: leftLabel, icon: leftIcon,
            active: !isAddMode, color: AppColors.kPrimary,
            onTap: () => onToggle(false),
          ),
        ),
        const SizedBox(width: 6),
        Expanded(
          child: _toggleBtn(
            label: rightLabel, icon: rightIcon,
            active: isAddMode, color: const Color(0xFF1DA87A),
            onTap: () => onToggle(true),
          ),
        ),
      ]),
    );

Widget _toggleBtn({
  required String label,
  required IconData icon,
  required bool active,
  required Color color,
  required VoidCallback onTap,
}) =>
    GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        padding: const EdgeInsets.symmetric(vertical: 11),
        decoration: BoxDecoration(
          color: active ? color : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Icon(icon,
              size: 16,
              color: active ? Colors.white : Colors.grey.shade500),
          const SizedBox(width: 6),
          Text(label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: active ? Colors.white : Colors.grey.shade600,
              )),
        ]),
      ),
    );