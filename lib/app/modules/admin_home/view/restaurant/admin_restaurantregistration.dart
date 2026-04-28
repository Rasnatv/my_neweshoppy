
import 'dart:io';
import 'package:eshoppy/app/widgets/networkconnection_checkpage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../../../common/style/app_colors.dart';
import '../../../../common/utils/validators.dart';
import '../../controller/restaurant_regcontroller.dart';

class RestaurantRegistrationPage extends StatelessWidget {
  final RestaurantRegController controller =
  Get.isRegistered<RestaurantRegController>()
      ? Get.find<RestaurantRegController>()
      : Get.put(RestaurantRegController());

  RestaurantRegistrationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return NetworkAwareWrapper(child:Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(result: true),
        ),
        title: const Text(
          "Restaurant Registration",
          style: TextStyle(
            color: Colors.white,
            fontSize: 17,
            fontWeight: FontWeight.w700,
          ),
        ),
        backgroundColor: AppColors.kPrimary,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Form(
        key: controller.formKey,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Restaurant Image ─────────────────────────────────
                _buildCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _sectionHeader(
                        icon: Icons.store_mall_directory_rounded,
                        title: "Restaurant Image *",
                      ),
                      const SizedBox(height: 20),
                      _restaurantImagePicker(),
                      Obx(() =>
                      controller.restaurantImageError.value.isNotEmpty
                          ? Padding(
                        padding:
                        const EdgeInsets.only(top: 8, left: 4),
                        child: Text(
                          controller.restaurantImageError.value,
                          style: TextStyle(
                              color: Colors.red.shade700,
                              fontSize: 12),
                        ),
                      )
                          : const SizedBox.shrink()),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // ── Basic Information ────────────────────────────────
                _buildCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _sectionHeader(
                        icon: Icons.info_outline_rounded,
                        title: "Basic Information",
                      ),
                      const SizedBox(height: 20),

                      // Restaurant Name — mandatory
                      _validatedTextField(
                        ctrl: controller.restaurantNameCtrl,
                        label: "Restaurant Name *",
                        hint: "Enter restaurant name",
                        icon: Icons.restaurant_rounded,
                        validator: (v) =>
                            DValidator.validateEmptyText('Restaurant name', v),
                      ),
                      const SizedBox(height: 16),

                      // Owner Name — mandatory
                      _validatedTextField(
                        ctrl: controller.ownerCtrl,
                        label: "Owner Name *",
                        hint: "Enter owner name",
                        icon: Icons.person_outline_rounded,
                        validator: (v) =>
                            DValidator.validateEmptyText('Owner name', v),
                      ),
                      const SizedBox(height: 16),

                      // Address — mandatory
                      _validatedTextField(
                        ctrl: controller.addressCtrl,
                        label: "Address *",
                        hint: "Enter full address",
                        icon: Icons.location_on_outlined,
                        maxLines: 2,
                        validator: (v) =>
                            DValidator.validateEmptyText('Address', v),
                      ),
                      const SizedBox(height: 16),

                      // Phone — mandatory
                      _validatedTextField(
                        ctrl: controller.phoneCtrl,
                        label: "Phone *",
                        hint: "Enter 10-digit phone number",
                        icon: Icons.phone_outlined,
                        type: TextInputType.phone,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(10),
                        ],
                        validator: (v) => DValidator.validatePhoneNumber(v),
                      ),
                      const SizedBox(height: 16),

                      // Email — mandatory
                      _validatedTextField(
                        ctrl: controller.emailCtrl,
                        label: "Email *",
                        hint: "Enter email address",
                        icon: Icons.email_outlined,
                        type: TextInputType.emailAddress,
                        validator: (v) {
                          if (v == null || v.trim().isEmpty) {
                            return 'Email is required';
                          }
                          return DValidator.validateEmail(v);
                        },
                      ),
                      const SizedBox(height: 16),

                      // Website — optional, must be valid URL if filled
                      _validatedTextField(
                        ctrl: controller.websiteCtrl,
                        label: "Website",
                        hint: "https://yourwebsite.com",
                        icon: Icons.language_outlined,
                        type: TextInputType.url,
                        validator: controller.validateWebsiteUrl,
                      ),
                      const SizedBox(height: 16),

                      // UPI ID — mandatory
                      _validatedTextField(
                        ctrl: controller.upiCtrl,
                        label: "UPI ID *",
                        hint: "e.g. name@upi",
                        icon: Icons.account_balance_wallet_outlined,
                        validator: (v) =>
                            DValidator.validateEmptyText('UPI ID', v),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // ── QR Code Upload ───────────────────────────────────
                _buildCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _sectionHeader(
                        icon: Icons.qr_code_2_rounded,
                        title: "Payment QR Code *",
                      ),
                      const SizedBox(height: 6),
                      Text(
                        "Upload your UPI / payment QR code image",
                        style: TextStyle(
                            fontSize: 13, color: Colors.grey.shade500),
                      ),
                      const SizedBox(height: 20),
                      _qrCodePicker(),
                      Obx(() => controller.qrCodeImageError.value.isNotEmpty
                          ? Padding(
                        padding:
                        const EdgeInsets.only(top: 8, left: 4),
                        child: Text(
                          controller.qrCodeImageError.value,
                          style: TextStyle(
                              color: Colors.red.shade700, fontSize: 12),
                        ),
                      )
                          : const SizedBox.shrink()),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // ── Social & Contact — all optional ─────────────────
                _buildCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _sectionHeader(
                        icon: Icons.share_outlined,
                        title: "Social & Contact",
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "All fields below are optional",
                        style: TextStyle(
                            fontSize: 12, color: Colors.grey.shade400),
                      ),
                      const SizedBox(height: 20),

                      // WhatsApp — optional, 10 digits if filled
                      _validatedTextField(
                        ctrl: controller.whatsappCtrl,
                        label: "WhatsApp",
                        hint: "Enter 10-digit WhatsApp number",
                        icon: Icons.chat_outlined,
                        type: TextInputType.phone,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(10),
                        ],
                        validator: (v) {
                          if (v == null || v.trim().isEmpty) return null;
                          return DValidator.validatePhoneNumber(v);
                        },
                      ),
                      const SizedBox(height: 16),

                      // Facebook — optional, must be facebook.com URL if filled
                      _validatedTextField(
                        ctrl: controller.facebookCtrl,
                        label: "Facebook",
                        hint: "https://facebook.com/yourpage",
                        icon: Icons.facebook_outlined,
                        type: TextInputType.url,
                        validator: controller.validateFacebookUrl,
                      ),
                      const SizedBox(height: 16),

                      // Instagram — optional, must be instagram.com URL or @handle
                      _validatedTextField(
                        ctrl: controller.instaCtrl,
                        label: "Instagram",
                        hint: "@yourhandle or https://instagram.com/yourhandle",
                        icon: Icons.photo_camera_outlined,
                        type: TextInputType.url,
                        validator: controller.validateInstagramUrl,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // ── Additional Images — optional ─────────────────────
                _buildCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: _sectionHeader(
                              icon: Icons.photo_library_outlined,
                              title: "Additional Images",
                            ),
                          ),
                          InkWell(
                            onTap: controller.pickAdditionalImages,
                            borderRadius: BorderRadius.circular(10),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 14, vertical: 8),
                              decoration: BoxDecoration(
                                color: AppColors.kPrimary.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                    color: AppColors.kPrimary.withOpacity(0.3)),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.add_photo_alternate_outlined,
                                      color: AppColors.kPrimary, size: 18),
                                  const SizedBox(width: 6),
                                  Text(
                                    "Add",
                                    style: TextStyle(
                                        color: AppColors.kPrimary,
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "Optional — add photos of your restaurant",
                        style: TextStyle(
                            fontSize: 12, color: Colors.grey.shade400),
                      ),
                      const SizedBox(height: 16),
                      Obx(() => controller.additionalImages.isEmpty
                          ? Container(
                        height: 100,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade50,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                              color: Colors.grey.shade200, width: 1.5),
                        ),
                        child: Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.add_photo_alternate_outlined,
                                  size: 28,
                                  color: Colors.grey.shade400),
                              const SizedBox(height: 6),
                              Text(
                                "No additional images selected",
                                style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.grey.shade400),
                              ),
                            ],
                          ),
                        ),
                      )
                          : Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children: controller.additionalImages
                            .asMap()
                            .entries
                            .map(
                              (e) => Stack(
                            children: [
                              ClipRRect(
                                borderRadius:
                                BorderRadius.circular(10),
                                child: Image.file(
                                  e.value,
                                  width: 100,
                                  height: 100,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Positioned(
                                right: 4,
                                top: 4,
                                child: GestureDetector(
                                  onTap: () => controller
                                      .additionalImages
                                      .removeAt(e.key),
                                  child: Container(
                                    padding: const EdgeInsets.all(4),
                                    decoration: BoxDecoration(
                                      color: Colors.black54,
                                      borderRadius:
                                      BorderRadius.circular(8),
                                    ),
                                    child: const Icon(
                                        Icons.close_rounded,
                                        size: 14,
                                        color: Colors.white),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                            .toList(),
                      )),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // ── Submit Button ────────────────────────────────────
                Obx(() => SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      gradient: LinearGradient(
                        colors: controller.isLoading.value
                            ? [
                          Colors.grey.shade400,
                          Colors.grey.shade300
                        ]
                            : [
                          AppColors.kPrimary,
                          AppColors.kPrimary.withOpacity(0.8),
                        ],
                      ),
                      boxShadow: controller.isLoading.value
                          ? []
                          : [
                        BoxShadow(
                          color: AppColors.kPrimary.withOpacity(0.3),
                          blurRadius: 12,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                      onPressed: controller.isLoading.value
                          ? null
                          : controller.submit,
                      child: controller.isLoading.value
                          ? const SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(
                            color: Colors.white, strokeWidth: 2.5),
                      )
                          : const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.check_circle_outline, size: 22),
                          SizedBox(width: 10),
                          Text(
                            "REGISTER RESTAURANT",
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.8,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )),

                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    ));
  }

  // ── Card wrapper ──────────────────────────────────────────────────────────
  Widget _buildCard({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 10,
              offset: const Offset(0, 2)),
        ],
      ),
      child: child,
    );
  }

  // ── Section header ────────────────────────────────────────────────────────
  Widget _sectionHeader({required IconData icon, required String title}) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.kPrimary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: AppColors.kPrimary, size: 20),
        ),
        const SizedBox(width: 12),
        Text(
          title,
          style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w700,
              color: Colors.black87),
        ),
      ],
    );
  }

  // ── Validated text field ──────────────────────────────────────────────────
  Widget _validatedTextField({
    required TextEditingController ctrl,
    required String label,
    required String hint,
    required IconData icon,
    TextInputType type = TextInputType.text,
    int maxLines = 1,
    String? Function(String?)? validator,
    List<TextInputFormatter>? inputFormatters,
  }) {
    return TextFormField(
      controller: ctrl,
      keyboardType: type,
      maxLines: maxLines,
      inputFormatters: inputFormatters,
      style: const TextStyle(fontSize: 15),
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: validator,
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
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.red.shade400, width: 1.5),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.red.shade600, width: 2),
        ),
        errorStyle: TextStyle(color: Colors.red.shade700, fontSize: 12),
        contentPadding:
        const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
    );
  }

  // ── Restaurant Image Picker ───────────────────────────────────────────────
  Widget _restaurantImagePicker() {
    return Obx(() => InkWell(
      onTap: controller.pickRestaurantImage,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        height: 200,
        width: double.infinity,
        decoration: BoxDecoration(
          border: Border.all(
            color: controller.restaurantImageError.value.isNotEmpty
                ? Colors.red.shade400
                : Colors.grey.shade300,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(12),
          color: Colors.grey.shade50,
        ),
        child: controller.restaurantImage.value == null
            ? Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: controller.restaurantImageError.value.isNotEmpty
                    ? Colors.red.withOpacity(0.1)
                    : AppColors.kPrimary.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.cloud_upload_outlined,
                size: 40,
                color: controller.restaurantImageError.value.isNotEmpty
                    ? Colors.red.shade400
                    : AppColors.kPrimary,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              "Upload Restaurant Photo",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color:
                controller.restaurantImageError.value.isNotEmpty
                    ? Colors.red.shade600
                    : Colors.grey.shade700,
              ),
            ),
            const SizedBox(height: 6),
            Text("Tap to browse gallery",
                style: TextStyle(
                    fontSize: 13, color: Colors.grey.shade500)),
          ],
        )
            : Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.file(
                controller.restaurantImage.value!,
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
              ),
            ),
            Positioned(
              top: 8,
              right: 8,
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.edit,
                    color: Colors.white, size: 20),
              ),
            ),
          ],
        ),
      ),
    ));
  }

  // ── QR Code Image Picker ──────────────────────────────────────────────────
  Widget _qrCodePicker() {
    return Obx(() => InkWell(
      onTap: controller.pickQrCodeImage,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        height: 180,
        width: double.infinity,
        decoration: BoxDecoration(
          border: Border.all(
            color: controller.qrCodeImageError.value.isNotEmpty
                ? Colors.red.shade400
                : Colors.grey.shade300,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(12),
          color: Colors.grey.shade50,
        ),
        child: controller.qrCodeImage.value == null
            ? Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: controller.qrCodeImageError.value.isNotEmpty
                    ? Colors.red.withOpacity(0.1)
                    : AppColors.kPrimary.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.qr_code_scanner_rounded,
                size: 36,
                color: controller.qrCodeImageError.value.isNotEmpty
                    ? Colors.red.shade400
                    : AppColors.kPrimary,
              ),
            ),
            const SizedBox(height: 14),
            Text(
              "Upload QR Code Image",
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: controller.qrCodeImageError.value.isNotEmpty
                    ? Colors.red.shade600
                    : Colors.grey.shade700,
              ),
            ),
            const SizedBox(height: 5),
            Text("Tap to browse gallery",
                style: TextStyle(
                    fontSize: 13, color: Colors.grey.shade500)),
          ],
        )
            : Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.file(
                controller.qrCodeImage.value!,
                fit: BoxFit.contain,
                width: double.infinity,
                height: double.infinity,
              ),
            ),
            Positioned(
              top: 8,
              right: 8,
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.edit,
                    color: Colors.white, size: 20),
              ),
            ),
            Positioned(
              bottom: 8,
              left: 8,
              child: Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.qr_code_rounded,
                        color: Colors.white, size: 14),
                    SizedBox(width: 4),
                    Text("QR Code",
                        style: TextStyle(
                            color: Colors.white, fontSize: 12)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    ));
  }
}