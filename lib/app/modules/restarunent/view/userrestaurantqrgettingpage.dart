
import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gal/gal.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../data/models/resaturantqrmodel.dart';
import '../controller/qrgettingcontroller.dart';
import '../controller/restaurant_maincartcontroller.dart';


// ── Storage ───────────────────────────────────────────────────────────────────
final _box = GetStorage();

String get _authToken => _box.read('auth_token') ?? '';

const String _baseUrl =
    'https://rasma.astradevelops.in/e_shoppyy/public/api';

Map<String, String> get _apiHeaders => {
  'Content-Type': 'application/json',
  'Accept': 'application/json',
  'Authorization': 'Bearer $_authToken',
};

// ── UPI pay ───────────────────────────────────────────────────────────────────
Future<void> _handlePay(
    List<PaymentDetailModel> data, BuildContext context) async {
  // Step 1: launch UPI app for each vendor
  for (final item in data) {
    await _launchUpi(item);
    await Future.delayed(const Duration(milliseconds: 600));
  }

  // Step 2: after returning, show transaction ID bottom sheet
  await Future.delayed(const Duration(milliseconds: 800));
  if (context.mounted) {
    _showTransactionSheet(context, data);
  }
}

Future<void> _launchUpi(PaymentDetailModel item) async {
  final hasUpiId = item.upiId.trim().isNotEmpty;

  final upiUri = Uri.parse(
    hasUpiId
        ? 'upi://pay'
        '?pa=${item.upiId.trim()}'
        '&pn=${Uri.encodeComponent(item.restaurantName)}'
        '&am=${item.totalPrice.toStringAsFixed(2)}'
        '&cu=INR'
        '&tn=${Uri.encodeComponent('Order payment - ${item.restaurantName}')}'
        : 'upi://pay',
  );

  try {
    await launchUrl(upiUri, mode: LaunchMode.externalNonBrowserApplication);
  } catch (_) {
    _snack('No UPI app found', 'Please install GPay, PhonePe, or Paytm');
  }
}

// ── Transaction ID bottom sheet ───────────────────────────────────────────────
void _showTransactionSheet(
    BuildContext context, List<PaymentDetailModel> data) {
  final txnController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  final RxString screenshotPath = ''.obs;
  final RxBool isSubmitting = false.obs;

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
        child: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Handle bar
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

                // Title
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
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Payment Done?',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF111111),
                          ),
                        ),
                        Text(
                          'Enter your UPI transaction ID to confirm',
                          style: TextStyle(
                            fontSize: 12,
                            color: Color(0xFF9CA3AF),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // Summary of amounts
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF9FAFB),
                    borderRadius: BorderRadius.circular(12),
                    border:
                    Border.all(color: const Color(0xFFE5E7EB), width: 0.5),
                  ),
                  child: Column(
                    children: [
                      ...data.map((item) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              item.restaurantName,
                              style: const TextStyle(
                                fontSize: 12,
                                color: Color(0xFF374151),
                              ),
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
                      )),
                      const Divider(height: 12, color: Color(0xFFE5E7EB)),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
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

                // Transaction ID field
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
                  controller: txnController,
                  textCapitalization: TextCapitalization.characters,
                  style: const TextStyle(
                    fontSize: 14,
                    fontFamily: 'monospace',
                    color: Color(0xFF111111),
                    letterSpacing: 0.5,
                  ),
                  decoration: InputDecoration(
                    hintText: 'e.g. 407312345678',
                    hintStyle: const TextStyle(
                      color: Color(0xFFD1D5DB),
                      fontSize: 13,
                    ),
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
                      borderSide:
                      const BorderSide(color: Color(0xFFDC2626), width: 1),
                    ),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.paste_rounded,
                          size: 18, color: Color(0xFF9CA3AF)),
                      onPressed: () async {
                        final clip =
                        await Clipboard.getData(Clipboard.kTextPlain);
                        if (clip?.text != null) {
                          txnController.text = clip!.text!;
                        }
                      },
                    ),
                  ),
                  validator: (val) {
                    if (val == null || val.trim().isEmpty) {
                      return 'Please enter your transaction ID';
                    }
                    if (val.trim().length < 6) {
                      return 'Transaction ID seems too short';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 8),
                const Text(
                  'Find it in your UPI app under payment history',
                  style: TextStyle(fontSize: 11, color: Color(0xFF9CA3AF)),
                ),

                const SizedBox(height: 16),

                // ── Payment Screenshot (optional) ──────────────────────────
                const Text(
                  'Payment Screenshot ',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF374151),
                  ),
                ),
                const SizedBox(height: 8),
                Obx(() => screenshotPath.value.isEmpty
                    ? GestureDetector(
                  onTap: () async {
                    final picker = ImagePicker();
                    final picked = await picker.pickImage(
                      source: ImageSource.gallery,
                      imageQuality: 70,
                    );
                    if (picked != null) {
                      screenshotPath.value = picked.path;
                    }
                  },
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF9FAFB),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: const Color(0xFFE5E7EB),
                        width: 1,
                        // dashed look via custom approach below
                      ),
                    ),
                    child: const Column(
                      children: [
                        Icon(Icons.upload_rounded,
                            size: 24, color: Color(0xFF9CA3AF)),
                        SizedBox(height: 6),
                        Text('Tap to upload screenshot',
                            style: TextStyle(
                                fontSize: 12,
                                color: Color(0xFF9CA3AF))),
                      ],
                    ),
                  ),
                )
                    : Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.file(
                        File(screenshotPath.value),
                        width: double.infinity,
                        height: 140,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Positioned(
                      top: 6,
                      right: 6,
                      child: GestureDetector(
                        onTap: () => screenshotPath.value = '',
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: Colors.black54,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Icon(Icons.close,
                              size: 14, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                )),

                const SizedBox(height: 20),

                // Confirm button
                Obx(() => SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: isSubmitting.value
                        ? null
                        : () async {
                      if (formKey.currentState!.validate()) {
                        isSubmitting.value = true;
                        final txnId = txnController.text.trim();
                        final screenshot = screenshotPath.value;

                        // Call API for each restaurant
                        bool allSuccess = true;
                        for (final item in data) {
                          final success =
                          await _storeTransaction(
                            restaurantId: item.restaurantId,
                            transactionId: txnId,
                            screenshotPath:
                            screenshot.isNotEmpty
                                ? screenshot
                                : null,
                          );
                          if (!success) {
                            allSuccess = false;
                            break;
                          }
                        }

                        isSubmitting.value = false;

                        if (allSuccess) {
                          Get.back(); // close sheet
                          _onPaymentConfirmed(txnId, data);
                        }
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isSubmitting.value
                          ? const Color(0xFF9CA3AF)
                          : const Color(0xFF059669),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14)),
                    ),
                    child: isSubmitting.value
                        ? const SizedBox(
                      height: 18,
                      width: 18,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                        : const Text(
                      'Confirm Payment',
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                )),

                const SizedBox(height: 10),

                // Skip button
                SizedBox(
                  width: double.infinity,
                  child: TextButton(
                    onPressed: () => Get.back(),
                    child: const Text(
                      'Pay Later',
                      style:
                      TextStyle(fontSize: 13, color: Color(0xFF9CA3AF)),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}

// ── Store Transaction API ─────────────────────────────────────────────────────
// POST /store-Transaction
// Body: { restaurant_id, transaction_id, payment_screenshot (base64, optional) }
Future<bool> _storeTransaction({
  required dynamic restaurantId, // accepts int or String from model
  required String transactionId,
  String? screenshotPath,
}) async {
  try {
    // Normalize restaurantId to int if possible
    final int? parsedId = restaurantId is int
        ? restaurantId
        : int.tryParse(restaurantId.toString());

    // Build request body
    final Map<String, dynamic> body = {
      'restaurant_id': parsedId ?? restaurantId.toString(),
      'transaction_id': transactionId,
    };

    // Attach screenshot as base64 if provided
    if (screenshotPath != null && screenshotPath.isNotEmpty) {
      final file = File(screenshotPath);
      if (await file.exists()) {
        final bytes = await file.readAsBytes();
        final base64Str = base64Encode(bytes);
        // Detect extension for mime type
        final ext = screenshotPath.split('.').last.toLowerCase();
        final mime = ext == 'png' ? 'image/png' : 'image/jpeg';
        body['payment_screenshot'] = 'data:$mime;base64,$base64Str';
      }
    }

    final response = await http.post(
      Uri.parse('$_baseUrl/store-Transaction'),
      headers: _apiHeaders,
      body: jsonEncode(body),
    );

    final jsonData = jsonDecode(response.body);

    if (response.statusCode == 200 && jsonData['status'] == true) {
      return true;
    } else {
      _snack(
        'Transaction Failed',
        jsonData['message'] ?? 'Could not store transaction. Try again.',
        isSuccess: false,
      );
      return false;
    }
  } catch (e) {
    debugPrint('storeTransaction error: $e');
    _snack(
      'Network Error',
      'Could not connect. Please check your connection.',
      isSuccess: false,
    );
    return false;
  }
}

// ── Called after transaction confirmed & API success ─────────────────────────
void _onPaymentConfirmed(
    String txnId, List<PaymentDetailModel> data) {
  // Clear the final cart
  try {
    final cartController = Get.find<FinalCartController>();
    cartController.restaurants.clear();
    cartController.restaurants.refresh();
  } catch (_) {
    // Controller not registered — safe to ignore
  }

  // Show success screen / snackbar
  _snack(
    'Payment Confirmed! 🎉',
    'Transaction ID: $txnId',
    isSuccess: true,
    duration: 4,
  );

  // Navigate to order success page (adjust route as needed)
  // Replace with your actual success route:
  Get.offNamed('/order-success', arguments: {
    'transaction_id': txnId,
    'restaurants': data.map((e) => e.restaurantName).toList(),
    'total': data.fold(0.0, (s, i) => s + i.totalPrice),
  });

}

Future<void> _downloadQr(String url, String restaurantName) async {
  try {
    final status = await Permission.storage.request();
    if (!status.isGranted && !status.isLimited) {
      final mediaStatus = await Permission.photos.request();
      if (!mediaStatus.isGranted) {
        _snack('Permission denied',
            'Please allow storage access in settings');
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

// ── Copy UPI to clipboard ─────────────────────────────────────────────────────
void _copyUpi(String upiId) {
  Clipboard.setData(ClipboardData(text: upiId));
  _snack('UPI ID Copied!', upiId, isSuccess: true);
}

// ── Snackbar helper ───────────────────────────────────────────────────────────
void _snack(String title, String message,
    {bool isSuccess = false, int duration = 3}) {
  Get.snackbar(
    title,
    message,
    snackPosition: SnackPosition.BOTTOM,
    backgroundColor:
    isSuccess ? const Color(0xFF059669) : const Color(0xFF111111),
    colorText: Colors.white,
    borderRadius: 12,
    margin: const EdgeInsets.all(16),
    duration: Duration(seconds: duration),
  );
}

// ── Main page ─────────────────────────────────────────────────────────────────
class QRPaymentPage extends StatelessWidget {
  const QRPaymentPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(PaymentgettController());

    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      appBar: AppBar(
        title: const Text(
          'Payment',
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.3,
            color: Color(0xFF111111),
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0.5,
        shadowColor: const Color(0xFFE5E7EB),
        leading: GestureDetector(
          onTap: () => Get.back(),
          child: Center(
            child: Container(
              width: 34,
              height: 34,
              margin: const EdgeInsets.only(left: 8),
              decoration: BoxDecoration(
                color: const Color(0xFFF3F4F6),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.arrow_back_ios_new_rounded,
                size: 15,
                color: Color(0xFF111111),
              ),
            ),
          ),
        ),
        actions: [
          Obx(() {
            final count =
                controller.paymentResponse.value?.data.length ?? 0;
            if (count == 0) return const SizedBox.shrink();
            return Container(
              margin: const EdgeInsets.only(right: 16),
              padding:
              const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFFEEF2FF),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                '$count vendors',
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF4338CA),
                ),
              ),
            );
          }),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(
              color: Color(0xFF4F46E5),
              strokeWidth: 2.5,
            ),
          );
        }

        if (controller.errorMessage.isNotEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFEF2F2),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Icon(Icons.wifi_off_rounded,
                        size: 36, color: Color(0xFFDC2626)),
                  ),
                  const SizedBox(height: 16),
                  const Text('Something went wrong',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF111111))),
                  const SizedBox(height: 6),
                  Text(controller.errorMessage.value,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          fontSize: 13, color: Color(0xFF9CA3AF))),
                  const SizedBox(height: 24),
                  TextButton(
                    onPressed: controller.fetchPaymentDetails,
                    style: TextButton.styleFrom(
                      backgroundColor: const Color(0xFF111111),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 28, vertical: 12),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text('Try again',
                        style: TextStyle(fontWeight: FontWeight.w600)),
                  ),
                ],
              ),
            ),
          );
        }

        final data = controller.paymentResponse.value?.data ?? [];

        if (data.isEmpty) {
          return const Center(
            child: Text('No payment details available.',
                style: TextStyle(color: Color(0xFF9CA3AF), fontSize: 14)),
          );
        }

        return Column(
          children: [
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                itemCount: data.length,
                itemBuilder: (_, index) =>
                    _RestaurantPaymentCard(item: data[index]),
              ),
            ),
            _BottomPayBar(
              total: controller.grandTotal,
              data: data,
            ),
          ],
        );
      }),
    );
  }
}

// ── Initials avatar ───────────────────────────────────────────────────────────
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
  if (parts.length >= 2) {
    return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
  }
  return name.substring(0, name.length.clamp(0, 2)).toUpperCase();
}

// ── Payment card ──────────────────────────────────────────────────────────────
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
            // Header
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
                    child: Text(_initials(item.restaurantName),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.5,
                        )),
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(item.restaurantName,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF111111),
                          letterSpacing: -0.2,
                        )),
                    const SizedBox(height: 2),
                    Text('${item.ownerName} · Owner',
                        style: const TextStyle(
                            fontSize: 11, color: Color(0xFF9CA3AF))),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 14),
            const Divider(height: 1, color: Color(0xFFF1F2F4)),
            const SizedBox(height: 12),

            // QR code
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
                      height: 140,
                      width: 140,
                      fit: BoxFit.contain,
                      loadingBuilder: (context, child, progress) {
                        if (progress == null) return child;
                        return SizedBox(
                          height: 140,
                          width: 140,
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
                        height: 140,
                        width: 140,
                        child: Icon(Icons.qr_code_2_rounded,
                            size: 64, color: Color(0xFFD1D5DB)),
                      ),
                    ),
                  ),
                ),
              )
            else
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 12, vertical: 8),
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
                    Text('QR code not available',
                        style: TextStyle(
                            fontSize: 11, color: Color(0xFF9CA3AF))),
                  ],
                ),
              ),

            const SizedBox(height: 12),

            // Save QR + Copy UPI
            Row(
              children: [
                if (item.hasQrCode)
                  Expanded(
                    child: _ActionButton(
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
                    child: _ActionButton(
                      icon: Icons.copy_rounded,
                      label: 'Copy UPI',
                      color: const Color(0xFF0284C7),
                      bgColor: const Color(0xFFE0F2FE),
                      onTap: () => _copyUpi(item.upiId.trim()),
                    ),
                  ),
              ],
            ),

            const SizedBox(height: 12),
            const Divider(height: 1, color: Color(0xFFF1F2F4)),
            const SizedBox(height: 12),

            // Amount
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Amount due',
                    style: TextStyle(
                      fontSize: 11,
                      color: Color(0xFF9CA3AF),
                      letterSpacing: 0.3,
                    )),
                Text(
                  '₹${item.totalPrice.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF111111),
                    letterSpacing: -0.3,
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

// ── Action button widget ──────────────────────────────────────────────────────
class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final Color bgColor;
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.bgColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 18, color: color),
            const SizedBox(height: 4),
            Text(label,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: color,
                )),
          ],
        ),
      ),
    );
  }
}

// ── Bottom pay bar ────────────────────────────────────────────────────────────
class _BottomPayBar extends StatelessWidget {
  final double total;
  final List<PaymentDetailModel> data;
  const _BottomPayBar({required this.total, required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFF7F8FA),
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      child: Column(
        children: [
          Container(
            padding:
            const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border:
              Border.all(color: const Color(0xFFE5E7EB), width: 0.5),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('GRAND TOTAL',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF9CA3AF),
                      letterSpacing: 1.0,
                    )),
                Text(
                  '₹${total.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF111111),
                    letterSpacing: -0.5,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => _handlePay(data, context),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF111111),
                foregroundColor: Colors.white,
                elevation: 0,
                padding: const EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14)),
              ),
              child: const Text(
                'Confirm & Pay All',
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.2),
              ),
            ),
          ),
        ],
      ),
    );
  }
}