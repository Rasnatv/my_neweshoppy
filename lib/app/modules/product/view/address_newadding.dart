import 'package:eshoppy/app/common/style/app_colors.dart';
import 'package:eshoppy/app/widgets/networkconnection_checkpage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../controller/newaddressadd_controller.dart';


class NewAddAddressPage extends StatelessWidget {
  NewAddAddressPage({super.key});

  final NewAddAddressController controller = Get.put(NewAddAddressController());

  @override
  Widget build(BuildContext context) {
    return NetworkAwareWrapper(child:Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),
      appBar: AppBar(
        backgroundColor: AppColors.kPrimary,
        elevation: 0,
       automaticallyImplyLeading: true,
        iconTheme: IconThemeData(color:Colors.white),
        title: const Text(
          'Add New Address',
          style: TextStyle(
            color: Colors.white,
            fontSize: 17,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.1,
          ),
        ),
        systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),
      body: Form(
        key: controller.formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Section: Personal Info
              _sectionHeader('Personal Information', Icons.person_outline),
              const SizedBox(height: 12),
              _buildField(
                controller: controller.fullNameController,
                label: 'Full Name',
                hint: 'Enter your full name',
                icon: Icons.person_outline_rounded,
                validator: (v) =>
                v == null || v.trim().isEmpty ? 'Full name is required' : null,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z ]')),
                ],
              ),
              const SizedBox(height: 14),
              _buildField(
                controller: controller.phoneController,
                label: 'Phone Number',
                hint: 'Enter 10-digit mobile number',
                icon: Icons.phone_outlined,
                keyboardType: TextInputType.phone,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(10),
                ],
                validator: (v) {
                  if (v == null || v.trim().isEmpty) return 'Phone number is required';
                  if (v.trim().length != 10) return 'Enter a valid 10-digit number';
                  return null;
                },
              ),

              const SizedBox(height: 24),

              // Section: Address Details
              _sectionHeader('Address Details', Icons.location_on_outlined),
              const SizedBox(height: 12),
              _buildField(
                controller: controller.houseNoController,
                label: 'House No / Flat',
                hint: 'e.g. 12A, Flat 3B',
                icon: Icons.home_outlined,
                validator: (v) =>
                v == null || v.trim().isEmpty ? 'House number is required' : null,
              ),
              const SizedBox(height: 14),
              _buildField(
                controller: controller.areaController,
                label: 'Area / Street',
                hint: 'e.g. Beach Road, MG Road',
                icon: Icons.map_outlined,
                validator: (v) =>
                v == null || v.trim().isEmpty ? 'Area is required' : null,
              ),
              const SizedBox(height: 14),
              _buildField(
                controller: controller.cityController,
                label: 'City',
                hint: 'Enter your city',
                icon: Icons.location_city_outlined,
                validator: (v) =>
                v == null || v.trim().isEmpty ? 'City is required' : null,
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  Expanded(
                    child: _buildField(
                      controller: controller.districtController,
                      label: 'District',
                      hint: 'District',
                      icon: Icons.map_rounded,
                      validator: (v) =>
                      v == null || v.trim().isEmpty ? 'Required' : null,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: _buildField(
                      controller: controller.pincodeController,
                      label: 'Pincode',
                      hint: '6-digit pincode',
                      icon: Icons.pin_drop_outlined,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(6),
                      ],
                      validator: (v) {
                        if (v == null || v.trim().isEmpty) return 'Required';
                        if (v.trim().length != 6) return 'Invalid';
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              _buildField(
                controller: controller.stateController,
                label: 'State',
                hint: 'Enter your state',
                icon: Icons.flag_outlined,
                validator: (v) =>
                v == null || v.trim().isEmpty ? 'State is required' : null,
              ),

              const SizedBox(height: 32),

              // Save Button
              Obx(
                    () => SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: ElevatedButton(
                    onPressed: controller.isLoading.value
                        ? null
                        : controller.addAddress,
                    child: controller.isLoading.value
                        ? const SizedBox(
                      height: 22,
                      width: 22,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2.5,
                      ),
                    )
                        : const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.save_outlined,
                            color: Colors.white, size: 20),
                        SizedBox(width: 8),
                        Text(
                          'Save Address',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    ));
  }

  // ── Section header ──────────────────────────────────────────────────────────
  Widget _sectionHeader(String title, IconData icon) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: const Color(0xFF00695C).withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 16, color: const Color(0xFF00695C)),
        ),
        const SizedBox(width: 10),
        Text(
          title,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: Color(0xFF1A1A2E),
            letterSpacing: 0.2,
          ),
        ),
      ],
    );
  }

  // ── Reusable text field ─────────────────────────────────────────────────────
  Widget _buildField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    List<TextInputFormatter>? inputFormatters,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      validator: validator,
      style: const TextStyle(
        fontSize: 14,
        color: Color(0xFF1A1A2E),
        fontWeight: FontWeight.w500,
      ),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        hintStyle: TextStyle(
          color: Colors.grey.shade400,
          fontSize: 13,
        ),
        labelStyle: const TextStyle(
          color: Color(0xFF6B7280),
          fontSize: 13,
          fontWeight: FontWeight.w500,
        ),
        prefixIcon: Icon(icon, color: const Color(0xFF00695C), size: 20),
        filled: true,
        fillColor: Colors.white,
        contentPadding:
        const EdgeInsets.symmetric(vertical: 16, horizontal: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade200),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade200),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide:
          const BorderSide(color: Color(0xFF00695C), width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.redAccent, width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.redAccent, width: 1.5),
        ),
      ),
    );
  }
}