
import 'package:eshoppy/app/widgets/networkconnection_checkpage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../common/style/app_colors.dart';
import 'addressupdate_controller.dart';

class EditAddressPage extends StatelessWidget {
  final int addressId;

  EditAddressPage({super.key, required this.addressId});

  final AddressUpdateController controller = Get.put(AddressUpdateController());

  static final Color primary = AppColors.kPrimary;
  static const Color bg = Color(0xFFF0F0F5);
  static const Color textDark = Color(0xFF1A1A1A);

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.fetchAddress(addressId);
    });

    return NetworkAwareWrapper(child:Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: AppColors.kPrimary,
        elevation: 0.5,
       automaticallyImplyLeading: true,
        iconTheme: IconThemeData(color: Colors.white),
        title: const Text(
          'Edit Address',
          style: TextStyle(
            color: Colors.white,
            fontSize: 17,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.1,
          ),
        ),
      ),
      body: Obx(() {
        if (controller.isFetching.value) {
          return  Center(
            child: CircularProgressIndicator(color: primary),
          );
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: controller.formKey,
            child: Column(
              children: [
                // ── Personal Info Card ────────────────────────────────────
                _buildCard(
                  children: [
                    _buildSectionTitle('Personal Info'),
                    const SizedBox(height: 14),
                    _buildField(
                      fieldController: controller.fullNameController,
                      label: 'Full Name',
                      hint: 'Enter full name',
                      icon: Icons.person_outline,
                      validator: (v) => (v == null || v.trim().isEmpty)
                          ? 'Name is required'
                          : null,
                    ),
                    const SizedBox(height: 14),
                    _buildField(
                      fieldController: controller.phoneController,
                      label: 'Phone Number',
                      hint: 'Enter 10-digit phone number',
                      icon: Icons.phone_outlined,
                      keyboardType: TextInputType.phone,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly
                      ],
                      maxLength: 10,
                      validator: (v) {
                        if (v == null || v.trim().isEmpty) {
                          return 'Phone is required';
                        }
                        if (v.trim().length < 10) {
                          return 'Enter a valid 10-digit number';
                        }
                        return null;
                      },
                    ),
                  ],
                ),

                const SizedBox(height: 14),

                // ── Address Details Card ──────────────────────────────────
                _buildCard(
                  children: [
                    _buildSectionTitle('Address Details'),
                    const SizedBox(height: 14),
                    _buildField(
                      fieldController: controller.houseNoController,
                      label: 'House / Flat No.',
                      hint: 'e.g. 45B',
                      icon: Icons.home_outlined,
                      validator: (v) => (v == null || v.trim().isEmpty)
                          ? 'House No. is required'
                          : null,
                    ),
                    const SizedBox(height: 14),
                    _buildField(
                      fieldController: controller.areaController,
                      label: 'Area / Street',
                      hint: 'e.g. New Street, Kanhangad',
                      icon: Icons.map_outlined,
                      maxLines: 2,
                      validator: (v) => (v == null || v.trim().isEmpty)
                          ? 'Area is required'
                          : null,
                    ),
                    const SizedBox(height: 14),
                    _buildField(
                      fieldController: controller.cityController,
                      label: 'City',
                      hint: 'Enter city',
                      icon: Icons.location_city_outlined,
                      validator: (v) => (v == null || v.trim().isEmpty)
                          ? 'City is required'
                          : null,
                    ),
                    const SizedBox(height: 14),
                    Row(
                      children: [
                        Expanded(
                          child: _buildField(
                            fieldController: controller.districtController,
                            label: 'District',
                            hint: 'Enter district',
                            icon: Icons.business_outlined,
                            validator: (v) =>
                            (v == null || v.trim().isEmpty)
                                ? 'Required'
                                : null,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildField(
                            fieldController: controller.stateController,
                            label: 'State',
                            hint: 'Enter state',
                            icon: Icons.flag_outlined,
                            validator: (v) =>
                            (v == null || v.trim().isEmpty)
                                ? 'Required'
                                : null,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    _buildField(
                      fieldController: controller.pincodeController,
                      label: 'Pincode',
                      hint: 'Enter 6-digit pincode',
                      icon: Icons.pin_drop_outlined,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly
                      ],
                      maxLength: 6,
                      validator: (v) {
                        if (v == null || v.trim().isEmpty) {
                          return 'Pincode is required';
                        }
                        if (v.trim().length < 6) {
                          return 'Enter a valid 6-digit pincode';
                        }
                        return null;
                      },
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // ── Update Button ─────────────────────────────────────────
                // Using Obx so isLoading rebuilds only this widget
                Obx(() => SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    // Always keep onPressed active — we block inside
                    // controller so button color never changes to grey
                    onPressed: controller.isLoading.value
                        ? null
                        : () => controller.updateAddress(addressId),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primary,
                      // Keep same purple even when disabled
                      disabledBackgroundColor: primary,
                      foregroundColor: Colors.white,
                      disabledForegroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      elevation: 0,
                    ),
                    child: controller.isLoading.value
                    // ── Spinner inside purple button ──────────────
                        ? const SizedBox(
                      height: 22,
                      width: 22,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2.5,
                      ),
                    )
                    // ── Normal label ──────────────────────────────
                        : const Text(
                      'UPDATE ADDRESS',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.8,
                      ),
                    ),
                  ),
                )),

                const SizedBox(height: 24),
              ],
            ),
          ),
        );
      }),
    ));
  }

  Widget _buildCard({required List<Widget> children}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Row(
      children: [
        Container(
          width: 3.5,
          height: 16,
          decoration: BoxDecoration(
            color: primary,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            fontSize: 13.5,
            fontWeight: FontWeight.w700,
            color: textDark,
            letterSpacing: 0.3,
          ),
        ),
      ],
    );
  }

  Widget _buildField({
    required TextEditingController fieldController,
    required String label,
    required String hint,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    List<TextInputFormatter>? inputFormatters,
    int maxLines = 1,
    int? maxLength,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: fieldController,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      maxLines: maxLines,
      maxLength: maxLength,
      validator: validator,
      style: const TextStyle(fontSize: 14, color: textDark),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon, size: 18, color: const Color(0xFF999999)),
        labelStyle:
        const TextStyle(fontSize: 13, color: Color(0xFF888888)),
        hintStyle:
        const TextStyle(fontSize: 13, color: Color(0xFFBBBBBB)),
        filled: true,
        fillColor: const Color(0xFFFAFAFA),
        counterText: '',
        contentPadding:
        const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(9),
          borderSide:
          const BorderSide(color: Color(0xFFE0E0E0), width: 1.2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(9),
          borderSide:  BorderSide(color: primary, width: 1.6),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(9),
          borderSide: BorderSide(color: Colors.red.shade300, width: 1.2),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(9),
          borderSide: BorderSide(color: Colors.red.shade400, width: 1.6),
        ),
      ),
    );
  }
}