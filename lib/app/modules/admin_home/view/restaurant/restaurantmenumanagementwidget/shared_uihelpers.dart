import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../../common/style/app_colors.dart';


/// Returns month name from month number
String monthNamezz(int month) {
  const names = [
    '', 'January', 'February', 'March', 'April', 'May', 'June',
    'July', 'August', 'September', 'October', 'November', 'December'
  ];
  return names[month];
}

Widget quickSelectChipzz({
  required String label,
  required Color color,
  required VoidCallback onTap,
}) =>
    GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: color.withOpacity(0.10),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: color.withOpacity(0.25)),
        ),
        child: Text(
          label,
          style: TextStyle(
              fontSize: 11, fontWeight: FontWeight.w600, color: color),
        ),
      ),
    );

Widget gradientStripzz() => Container(
  height: 8,
  decoration: BoxDecoration(
    gradient: LinearGradient(
      colors: [
        AppColors.kPrimary,
        AppColors.kPrimary.withOpacity(0.6),
      ],
    ),
  ),
);

Widget buildCardzz({required Widget child}) => Container(
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

Widget sectionHeaderzz({
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
          child:
          Icon(icon, color: iconColor ?? AppColors.kPrimary, size: 20),
        ),
        const SizedBox(width: 12),
        Text(title,
            style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w700,
                color: Colors.black87)),
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

Widget modernTextFieldzz({
  required TextEditingController controller,
  required String label,
  required String hint,
  required IconData icon,
  TextInputType type = TextInputType.text,
  int maxLines = 1,
  List<TextInputFormatter>? inputFormatters,
}) =>
    TextField(
      controller: controller,
      keyboardType: type,
      maxLines: maxLines,
      inputFormatters: inputFormatters,
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
          borderSide: BorderSide(color: AppColors.kPrimary, width: 2),
        ),
        contentPadding:
        const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
    );

Widget pickerTextFieldzz({
  required TextEditingController controller,
  required String label,
  required IconData icon,
  required VoidCallback? onTap,
  bool showDropdownArrow = false,
}) =>
    TextField(
      controller: controller,
      readOnly: true,
      onTap: onTap,
      style: const TextStyle(fontSize: 15),
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, size: 22, color: AppColors.kPrimary),
        suffixIcon: showDropdownArrow
            ? Icon(Icons.arrow_drop_down, color: AppColors.kPrimary, size: 28)
            : null,
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
    );

Widget modernDropdownzz<T>({
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
      style: const TextStyle(color: Color(0xFF1A1D2E), fontSize: 15),
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
          .map((e) =>
          DropdownMenuItem(value: e, child: Text(itemLabel(e))))
          .toList(),
      onChanged: onChanged,
    );

Widget primaryBtnzz({
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
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12)),
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

Widget emptyStatezz({
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
                style:
                TextStyle(fontSize: 12, color: Colors.grey.shade400)),
          ],
        ]),
      ),
    );

Widget chipzz(String label, IconData icon) => Container(
  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
  decoration: BoxDecoration(
    color: Colors.grey.shade100,
    borderRadius: BorderRadius.circular(6),
    border: Border.all(color: Colors.grey.shade200),
  ),
  child: Row(mainAxisSize: MainAxisSize.min, children: [
    Icon(icon, size: 11, color: Colors.grey.shade500),
    const SizedBox(width: 4),
    Text(label,
        style: TextStyle(fontSize: 11, color: Colors.grey.shade600)),
  ]),
);

Widget previewSectionzz({
  required IconData icon,
  required String title,
  required Widget child,
}) =>
    Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(children: [
        Container(
          padding:
          const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            border:
            Border(bottom: BorderSide(color: Colors.grey.shade200)),
          ),
          child: Row(children: [
            Icon(icon, color: AppColors.kPrimary, size: 18),
            const SizedBox(width: 8),
            Text(title,
                style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Colors.black87)),
          ]),
        ),
        Padding(
          padding: const EdgeInsets.all(16),
          child: child,
        ),
      ]),
    );

Widget lockedTabzz({
  required IconData icon,
  required String title,
  required String subtitle,
  required String actionLabel,
  required VoidCallback onAction,
}) =>
    Center(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.lock_outline_rounded,
                  size: 40, color: Colors.grey.shade400),
            ),
            const SizedBox(height: 20),
            Text(title,
                style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1A1D2E))),
            const SizedBox(height: 8),
            Text(subtitle,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey.shade500,
                    height: 1.5)),
            const SizedBox(height: 24),
            SizedBox(
              width: 180,
              height: 44,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.kPrimary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                icon: Icon(icon, size: 18),
                label: Text(actionLabel,
                    style:
                    const TextStyle(fontWeight: FontWeight.w700)),
                onPressed: onAction,
              ),
            ),
          ],
        ),
      ),
    );