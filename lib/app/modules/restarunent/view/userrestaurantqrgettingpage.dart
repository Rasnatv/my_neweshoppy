
import 'dart:io';
import 'package:eshoppy/app/modules/landingview/view/landing_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gal/gal.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../common/style/app_colors.dart';
import '../../../data/models/resaturantqrmodel.dart';
import '../../userhome/widget/qrgettingpage/actionbutton.dart';
import '../controller/qrgettingcontroller.dart';
import '../controller/restaurant_maincartcontroller.dart';

// ── UPI App Model ─────────────────────────────────────────────────────────────
class _UpiApp {
  final String name;
  final String scheme;
  final IconData icon;
  final Color color;
  final Color bgColor;

  const _UpiApp({
    required this.name,
    required this.scheme,
    required this.icon,
    required this.color,
    required this.bgColor,
  });
}

const _upiApps = [
  _UpiApp(
    name: 'Google Pay',
    scheme: 'tez://upi/pay',
    icon: Icons.g_mobiledata_rounded,
    color: Color(0xFF4285F4),
    bgColor: Color(0xFFE8F0FE),
  ),
  _UpiApp(
    name: 'PhonePe',
    scheme: 'phonepe://pay',
    icon: Icons.phone_android_rounded,
    color: Color(0xFF5F259F),
    bgColor: Color(0xFFF3E8FF),
  ),

];

// ── UPI App Picker ────────────────────────────────────────────────────────────
Future<_UpiApp?> _showUpiAppPicker(BuildContext context) async {
  return await showModalBottomSheet<_UpiApp>(
    context: context,
    backgroundColor: Colors.transparent,
    builder: (_) => Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: const Color(0xFFE5E7EB),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Pay with',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w700,
              color: Color(0xFF111111),
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Choose a UPI app to complete your payment',
            style: TextStyle(fontSize: 12, color: Color(0xFF9CA3AF)),
          ),
          const SizedBox(height: 16),
          ..._upiApps.map(
                (app) => GestureDetector(
              onTap: () => Navigator.of(context).pop(app),
              child: Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  color: const Color(0xFFF9FAFB),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                      color: const Color(0xFFE5E7EB), width: 0.5),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        color: app.bgColor,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(app.icon, color: app.color, size: 22),
                    ),
                    const SizedBox(width: 14),
                    Text(
                      app.name,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF111111),
                      ),
                    ),
                    const Spacer(),
                    const Icon(Icons.arrow_forward_ios_rounded,
                        size: 14, color: Color(0xFFD1D5DB)),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

// ── Open UPI App only (no sheet, no delay) ───────────────────────────────────
Future<void> handlePay(
    List<PaymentDetailModel> data, BuildContext context) async {
  final selectedApp = await _showUpiAppPicker(context);
  if (selectedApp == null) return;

  try {
    final uri = Uri.parse(selectedApp.scheme);
    final launched =
    await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!launched) {
      _snack('${selectedApp.name} not installed',
          'Please install ${selectedApp.name}');
    }
  } catch (_) {
    _snack('Error', 'Could not open ${selectedApp.name}');
  }
  // ✅ No delay, no sheet — user comes back and fills the form already on page
}

// ── Payment Confirmed ─────────────────────────────────────────────────────────
void _onPaymentConfirmed(String txnId, List<PaymentDetailModel> data) {
  try {
    final cartController = Get.find<FinalCartController>();
    cartController.restaurants.clear();
    cartController.restaurants.refresh();
  } catch (_) {}

  Get.snackbar(
    'Payment Confirmed! 🎉',
    'Transaction ID: $txnId',
    snackPosition: SnackPosition.BOTTOM,
    backgroundColor: AppColors.kPrimary,
    colorText: Colors.white,
    duration: const Duration(seconds: 4),
  );

  Get.offUntil(
    GetPageRoute(page: () => const LandingView()),
        (route) => false,
  );
}

// ── Download QR ───────────────────────────────────────────────────────────────
Future<void> _downloadQr(String url, String restaurantName) async {
  try {
    final status = await Permission.storage.request();
    if (!status.isGranted && !status.isLimited) {
      final mediaStatus = await Permission.photos.request();
      if (!mediaStatus.isGranted) {
        _snack('Permission denied', 'Please allow storage access in settings');
        return;
      }
    }
    _snack('Downloading...', 'Saving QR code to gallery');
    final dir = await getTemporaryDirectory();
    final filePath =
        '${dir.path}/qr_${restaurantName.replaceAll(' ', '_')}.png';
    await Dio().download(url, filePath);
    await Gal.putImage(filePath, album: 'eShoppy QR Codes');
    _snack('QR Saved!', 'QR code saved to your gallery', isSuccess: true);
  } catch (e) {
    _snack('Download failed', 'Could not save QR code. Try again.');
  }
}

void _copyUpi(String upiId) {
  Clipboard.setData(ClipboardData(text: upiId));
  _snack('UPI ID Copied!', upiId, isSuccess: true);
}

void _snack(String title, String message,
    {bool isSuccess = false, int duration = 3}) {
  Get.snackbar(
    title,
    message,
    snackPosition: SnackPosition.BOTTOM,
    backgroundColor:
    isSuccess ? const Color(0xFF059669) : const Color(0xFF111111),
    colorText: Colors.white,
    duration: Duration(seconds: duration),
    margin: const EdgeInsets.all(12),
    borderRadius: 12,
  );
}

// ── Initials helpers ──────────────────────────────────────────────────────────
const _avatarPalettes = [
  [Color(0xFF6366F1), Color(0xFF4F46E5)],
  [Color(0xFF0EA5E9), Color(0xFF0284C7)],
  [Color(0xFF10B981), Color(0xFF059669)],
  [Color(0xFFF59E0B), Color(0xFFD97706)],
  [Color(0xFFEC4899), Color(0xFFDB2777)],
];

List<Color> _avatarColors(String name) =>
    _avatarPalettes[name.codeUnitAt(0) % _avatarPalettes.length];

String _initials(String name) {
  final parts = name.trim().split(' ');
  if (parts.length >= 2) return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
  return name.substring(0, name.length.clamp(0, 2)).toUpperCase();
}

// ── Main Page ─────────────────────────────────────────────────────────────────
class QRPaymentPage extends StatefulWidget {
  const QRPaymentPage({super.key});

  @override
  State<QRPaymentPage> createState() => _QRPaymentPageState();
}

class _QRPaymentPageState extends State<QRPaymentPage> {
  final _txnController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String _screenshotPath = '';
  bool _isSubmitting = false;

  @override
  void dispose() {
    _txnController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(PaymentgettController());

    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      appBar: AppBar(
        automaticallyImplyLeading: true,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'Payment',
          style: TextStyle(
            color: Colors.white,
            fontSize: 17,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.1,
          ),
        ),
        backgroundColor: AppColors.restaurantclr,
        elevation: 0,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(
                color: Color(0xFF4F46E5), strokeWidth: 2.5),
          );
        }

        final data = controller.paymentResponse.value?.data ?? [];

        if (data.isEmpty) {
          return const Center(
            child: Text(
              'No payment details available.',
              style: TextStyle(color: Color(0xFF9CA3AF), fontSize: 14),
            ),
          );
        }

        return Column(
          children: [
            // ── Scrollable body ──────────────────────────────────────────────
            Expanded(
              child: Form(
                key: _formKey,
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                  children: [
                    // ── Restaurant QR cards ──────────────────────────────────
                    ...data.map(
                          (item) => _RestaurantPaymentCard(item: item),
                    ),

                    const SizedBox(height: 8),

                    // ── Divider with label ───────────────────────────────────
                    Row(
                      children: [
                        const Expanded(
                            child: Divider(color: Color(0xFFE5E7EB))),
                        Padding(
                          padding:
                          const EdgeInsets.symmetric(horizontal: 12),
                          child: Text(
                            'After paying, confirm below',
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.grey.shade500,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        const Expanded(
                            child: Divider(color: Color(0xFFE5E7EB))),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // ── Confirm section card ─────────────────────────────────
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(
                            color: const Color(0xFFE5E7EB), width: 0.5),
                      ),
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Section title
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFD1FAE5),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const Icon(
                                    Icons.check_circle_rounded,
                                    color: Color(0xFF059669),
                                    size: 18),
                              ),
                              const SizedBox(width: 10),
                              const Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Confirm Payment',
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w700,
                                      color: Color(0xFF111111),
                                    ),
                                  ),
                                  Text(
                                    'Enter details after completing UPI payment',
                                    style: TextStyle(
                                        fontSize: 11,
                                        color: Color(0xFF9CA3AF)),
                                  ),
                                ],
                              ),
                            ],
                          ),

                          const SizedBox(height: 16),

                          // Payment summary
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF9FAFB),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                  color: const Color(0xFFE5E7EB),
                                  width: 0.5),
                            ),
                            child: Column(
                              children: [
                                ...data.map(
                                      (item) => Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 4),
                                    child: Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          item.restaurantName,
                                          style: const TextStyle(
                                              fontSize: 12,
                                              color: Color(0xFF374151)),
                                        ),
                                        Text(
                                          '₹${item.totalPrice.toStringAsFixed(2)}',
                                          style: const TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                            color: Color(0xFF111111),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                const Divider(
                                    height: 12, color: Color(0xFFE5E7EB)),
                                Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      'Total paid',
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        color: Color(0xFF111111),
                                      ),
                                    ),
                                    Text(
                                      '₹${data.fold(0.0, (s, i) => s + i.totalPrice).toStringAsFixed(2)}',
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w700,
                                        color: Color(0xFF059669),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 16),

                          // ── Transaction ID ───────────────────────────────
                          const Text(
                            'Transaction ID',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF374151),
                            ),
                          ),
                          const SizedBox(height: 6),
                          TextFormField(
                            controller: _txnController,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              LengthLimitingTextInputFormatter(12),
                            ],
                            style: const TextStyle(
                              fontSize: 14,
                              fontFamily: 'monospace',
                              color: Color(0xFF111111),
                              letterSpacing: 0.5,
                            ),
                            decoration: InputDecoration(
                              hintText: 'e.g. 407312345678',
                              hintStyle: const TextStyle(
                                  color: Color(0xFFD1D5DB), fontSize: 13),
                              filled: true,
                              fillColor: const Color(0xFFF9FAFB),
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 14, vertical: 14),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(
                                    color: Color(0xFFE5E7EB), width: 0.5),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(
                                    color: Color(0xFFE5E7EB), width: 0.5),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(
                                    color: Color(0xFF4F46E5), width: 1.5),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(
                                    color: Color(0xFFDC2626), width: 1),
                              ),
                              suffixIcon: IconButton(
                                icon: const Icon(Icons.paste_rounded,
                                    size: 18, color: Color(0xFF9CA3AF)),
                                onPressed: () async {
                                  final clip = await Clipboard.getData(
                                      Clipboard.kTextPlain);
                                  if (clip?.text != null) {
                                    _txnController.text = clip!.text!;
                                  }
                                },
                              ),
                            ),
                            validator: (val) {
                              if (val == null || val.trim().isEmpty) {
                                return 'Please enter your transaction ID';
                              }
                              if (val.trim().length < 12) {
                                return 'Transaction ID must be 12 digits';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 6),
                          const Text(
                            'Find it in your UPI app under payment history',
                            style: TextStyle(
                                fontSize: 11, color: Color(0xFF9CA3AF)),
                          ),

                          const SizedBox(height: 16),

                          // ── Payment Screenshot ───────────────────────────
                          const Text(
                            'Payment Screenshot',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF374151),
                            ),
                          ),
                          const SizedBox(height: 8),
                          _screenshotPath.isEmpty
                              ? GestureDetector(
                            onTap: _pickScreenshot,
                            child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(
                                  vertical: 20),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF9FAFB),
                                borderRadius:
                                BorderRadius.circular(12),
                                border: Border.all(
                                    color: const Color(0xFFE5E7EB),
                                    width: 1),
                              ),
                              child: const Column(
                                children: [
                                  Icon(Icons.upload_rounded,
                                      size: 26,
                                      color: Color(0xFF9CA3AF)),
                                  SizedBox(height: 6),
                                  Text(
                                    'Tap to upload screenshot',
                                    style: TextStyle(
                                        fontSize: 12,
                                        color: Color(0xFF9CA3AF)),
                                  ),
                                  SizedBox(height: 2),
                                  Text(
                                    'Optional but recommended',
                                    style: TextStyle(
                                        fontSize: 10,
                                        color: Color(0xFFD1D5DB)),
                                  ),
                                ],
                              ),
                            ),
                          )
                              : Stack(
                            children: [
                              ClipRRect(
                                borderRadius:
                                BorderRadius.circular(12),
                                child: Image.file(
                                  File(_screenshotPath),
                                  width: double.infinity,
                                  height: 160,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Positioned(
                                top: 6,
                                right: 6,
                                child: GestureDetector(
                                  onTap: () => setState(
                                          () => _screenshotPath = ''),
                                  child: Container(
                                    padding: const EdgeInsets.all(5),
                                    decoration: BoxDecoration(
                                      color: Colors.black54,
                                      borderRadius:
                                      BorderRadius.circular(20),
                                    ),
                                    child: const Icon(Icons.close,
                                        size: 14,
                                        color: Colors.white),
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: 6,
                                right: 6,
                                child: GestureDetector(
                                  onTap: _pickScreenshot,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 5),
                                    decoration: BoxDecoration(
                                      color: Colors.black54,
                                      borderRadius:
                                      BorderRadius.circular(10),
                                    ),
                                    child: const Text(
                                      'Change',
                                      style: TextStyle(
                                          fontSize: 11,
                                          color: Colors.white),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 20),

                          // ── Confirm Payment button ───────────────────────
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: _isSubmitting
                                  ? null
                                  : () =>
                                  _submitPayment(context, data, controller),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: _isSubmitting
                                    ? const Color(0xFF9CA3AF)
                                    : const Color(0xFF0F5151),
                                foregroundColor: Colors.white,
                                elevation: 0,
                                padding: const EdgeInsets.symmetric(
                                    vertical: 15),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(14)),
                              ),
                              child: _isSubmitting
                                  ? const SizedBox(
                                height: 18,
                                width: 18,
                                child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2),
                              )
                                  : const Text(
                                'Confirm Payment',
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),

            // ── Bottom Pay Bar ───────────────────────────────────────────────
            _BottomPayBar(
              total: controller.grandTotal,
              data: data,
            ),
          ],
        );
      }),
    );
  }

  Future<void> _pickScreenshot() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(
        source: ImageSource.gallery, imageQuality: 70);
    if (picked != null) {
      setState(() => _screenshotPath = picked.path);
    }
  }

  Future<void> _submitPayment(
      BuildContext context,
      List<PaymentDetailModel> data,
      PaymentgettController payController,
      ) async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);

    final txnId = _txnController.text.trim();
    bool allSuccess = true;

    for (final item in data) {
      final success = await payController.storeTransaction(
        restaurantId: item.restaurantId,
        transactionId: txnId,
        screenshotPath: _screenshotPath.isNotEmpty ? _screenshotPath : null,
      );
      if (!success) {
        allSuccess = false;
        break;
      }
    }

    setState(() => _isSubmitting = false);

    if (allSuccess) {
      _onPaymentConfirmed(txnId, data);
    }
  }
}

// ── Bottom Pay Bar ────────────────────────────────────────────────────────────
class _BottomPayBar extends StatelessWidget {
  final double total;
  final List<PaymentDetailModel> data;

  const _BottomPayBar({required this.total, required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(
          16, 12, 16, 12 + MediaQuery.of(context).padding.bottom),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Color(0xFFE5E7EB), width: 0.5)),
      ),
      child: Row(
        children: [
          // Total amount
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Total Amount',
                style: TextStyle(fontSize: 11, color: Color(0xFF9CA3AF)),
              ),
              Text(
                '₹${total.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF111111),
                ),
              ),
            ],
          ),
          const SizedBox(width: 16),
          // Pay button
          Expanded(
            child: ElevatedButton.icon(
              onPressed: () => handlePay(data, context),
              icon: const Icon(Icons.payment_rounded, size: 18),
              label: const Text(
                'Pay with UPI',
                style:
                TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.restaurantclr,
                foregroundColor: Colors.white,
                elevation: 0,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Restaurant Payment Card (QR + actions only) ───────────────────────────────
class _RestaurantPaymentCard extends StatelessWidget {
  final PaymentDetailModel item;
  const _RestaurantPaymentCard({required this.item});

  @override
  Widget build(BuildContext context) {
    final colors = _avatarColors(item.restaurantName);
    final hasUpiId = item.upiId.trim().isNotEmpty;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE5E7EB), width: 0.5),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Header ──────────────────────────────────────────────────────
            Row(
              children: [
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: colors,
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Text(
                      _initials(item.restaurantName),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.restaurantName,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF111111),
                        letterSpacing: -0.2,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${item.ownerName} · Owner',
                      style: const TextStyle(
                          fontSize: 11, color: Color(0xFF9CA3AF)),
                    ),
                  ],
                ),
                const Spacer(),
                // Amount chip
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFD1FAE5),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '₹${item.totalPrice.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF059669),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 14),
            const Divider(height: 1, color: Color(0xFFF1F2F4)),
            const SizedBox(height: 12),

            // ── QR Code ─────────────────────────────────────────────────────
            if (item.hasQrCode)
              Center(
                child: Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF9FAFB),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                        color: const Color(0xFFE5E7EB), width: 0.5),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      item.qrCodeUrl,
                      height: 160,
                      width: 160,
                      fit: BoxFit.contain,
                      loadingBuilder: (context, child, progress) {
                        if (progress == null) return child;
                        return SizedBox(
                          height: 160,
                          width: 160,
                          child: Center(
                            child: CircularProgressIndicator(
                              value: progress.expectedTotalBytes != null
                                  ? progress.cumulativeBytesLoaded /
                                  progress.expectedTotalBytes!
                                  : null,
                              strokeWidth: 2,
                              color: const Color(0xFF4F46E5),
                            ),
                          ),
                        );
                      },
                      errorBuilder: (_, __, ___) => const SizedBox(
                        height: 160,
                        width: 160,
                        child: Icon(Icons.qr_code_2_rounded,
                            size: 64, color: Color(0xFFD1D5DB)),
                      ),
                    ),
                  ),
                ),
              )
            else
              Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: const Color(0xFFF9FAFB),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.qr_code_rounded,
                        size: 14, color: Color(0xFFD1D5DB)),
                    SizedBox(width: 6),
                    Text(
                      'QR code not available',
                      style: TextStyle(
                          fontSize: 11, color: Color(0xFF9CA3AF)),
                    ),
                  ],
                ),
              ),

            const SizedBox(height: 10),

            // ── How to pay tip ───────────────────────────────────────────────
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFFFFBEB),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                    color: const Color(0xFFFCD34D), width: 0.8),
              ),
              child: const Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.tips_and_updates_rounded,
                      size: 16, color: Color(0xFFD97706)),
                  SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'How to pay?',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF92400E),
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          '1. Tap "Pay with UPI" below → scan this QR\n2. Or copy the UPI ID and paste it manually\n3. Come back and confirm with transaction ID',
                          style: TextStyle(
                            fontSize: 11,
                            color: Color(0xFFB45309),
                            height: 1.6,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // ── Action buttons ───────────────────────────────────────────────
            Row(
              children: [
                if (item.hasQrCode)
                  Expanded(
                    child: ActionButton(
                      icon: Icons.download_rounded,
                      label: 'Save QR',
                      color: const Color(0xFF4F46E5),
                      bgColor: const Color(0xFFEEF2FF),
                      onTap: () =>
                          _downloadQr(item.qrCodeUrl, item.restaurantName),
                    ),
                  ),
                if (item.hasQrCode && hasUpiId) const SizedBox(width: 8),
                if (hasUpiId)
                  Expanded(
                    child: ActionButton(
                      icon: Icons.copy_rounded,
                      label: 'Copy UPI',
                      color: const Color(0xFF0284C7),
                      bgColor: const Color(0xFFE0F2FE),
                      onTap: () => _copyUpi(item.upiId.trim()),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
