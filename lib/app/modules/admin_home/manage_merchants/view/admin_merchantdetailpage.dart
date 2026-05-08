
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common/style/app_colors.dart';

import '../controller/admin_merchantdetailedcontroller.dart';
import 'admin_editmerchant.dart';


class AdminMerchantDetailPage extends StatelessWidget {
  final int merchantId;

  const AdminMerchantDetailPage({Key? key, required this.merchantId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AdminMerchantDetailController());

    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.fetchMerchantDetail(merchantId);
    });

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF1A1A1A),
        elevation: 0.5,
        title: const Text(
          'Merchant Detail',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        actions: [
          // Edit button
          IconButton(
            icon: Container(
              padding: const EdgeInsets.all(7),
              decoration: BoxDecoration(
                color: AppColors.kPrimary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(Icons.edit_outlined,
                  color: AppColors.kPrimary, size: 18),
            ),
            onPressed: () {
              controller.initEditControllers();
              Get.to(() => AdminMerchantEditPage(
                merchantId: merchantId,
                controller: controller,
              ));
            },
          ),
          const SizedBox(width: 10),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(
            child: CircularProgressIndicator(color: AppColors.kPrimary),
          );
        }
        final m = controller.merchant.value;
        if (m == null) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.store_outlined, size: 60, color: Colors.grey[400]),
                const SizedBox(height: 12),
                Text('No merchant data',
                    style: TextStyle(color: Colors.grey[500], fontSize: 16)),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: () => controller.fetchMerchantDetail(merchantId),
                  icon: const Icon(Icons.refresh),
                  label: const Text('Retry'),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.kPrimary,
                      foregroundColor: Colors.white),
                ),
              ],
            ),
          );
        }
        return RefreshIndicator(
          color: AppColors.kPrimary,
          onRefresh: () => controller.fetchMerchantDetail(merchantId),
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // ── Header ─────────────────────────────────────────────
              _buildHeader(m),
              const SizedBox(height: 16),

              // ── Basic Info ─────────────────────────────────────────
              _buildInfoCard(
                icon: Icons.info_outline,
                title: 'Basic Information',
                children: [
                  _infoRow(Icons.person_outline, 'Owner Name', m.ownerName),
                  _infoRow(Icons.storefront_outlined, 'Shop Name', m.shopName),
                  _infoRow(Icons.email_outlined, 'Email', m.email),
                  _infoRow(Icons.phone_outlined, 'Phone 1', m.phone1),
                  _infoRow(Icons.phone_android_outlined, 'Phone 2', m.phone2),
                ],
              ),
              const SizedBox(height: 16),

              // ── Address ────────────────────────────────────────────
              _buildInfoCard(
                icon: Icons.location_on_outlined,
                title: 'Address Details',
                children: [
                  _infoRow(Icons.flag_outlined, 'State', m.state),
                  _infoRow(Icons.location_city_outlined, 'District', m.district),
                  _infoRow(Icons.place_outlined, 'Main Location', m.mainLocation),
                ],
              ),
              const SizedBox(height: 16),

              // ── GPS ────────────────────────────────────────────────
              _buildInfoCard(
                icon: Icons.my_location,
                title: 'Shop Location',
                children: [
                  _buildCoordinatesRow(
                      latitude: m.latitude, longitude: m.longitude),
                ],
              ),
              const SizedBox(height: 16),

              // ── Social / Optional ──────────────────────────────────
              _buildInfoCard(
                icon: Icons.share_outlined,
                title: 'Contact & Social',
                children: [
                  if (m.whatsapp.isNotEmpty)
                    _socialRow(Icons.chat_outlined, 'WhatsApp',
                        m.whatsapp, const Color(0xFF25D366)),
                  if (m.facebook.isNotEmpty)
                    _socialRow(Icons.facebook, 'Facebook',
                        m.facebook, const Color(0xFF1877F2)),
                  if (m.instagram.isNotEmpty)
                    _socialRow(Icons.camera_alt_outlined, 'Instagram',
                        m.instagram, const Color(0xFFE4405F)),
                  if (m.website.isNotEmpty)
                    _socialRow(Icons.language, 'Website',
                        m.website, const Color(0xFF0077B5)),
                  if (m.whatsapp.isEmpty &&
                      m.facebook.isEmpty &&
                      m.instagram.isEmpty &&
                      m.website.isEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Text('No social links provided',
                          style: TextStyle(
                              color: Colors.grey[400],
                              fontStyle: FontStyle.italic)),
                    ),
                ],
              ),
              const SizedBox(height: 24),
            ],
          ),
        );
      }),
    );
  }


  // ── Header ─────────────────────────────────────────────────────────────────
  Widget _buildHeader(dynamic m) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 2))
        ],
      ),
      padding: const EdgeInsets.all(24),
      child: Column(children: [
        Hero(
          tag: 'merchant_${m.id}',
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                    color: AppColors.kPrimary.withOpacity(0.2),
                    blurRadius: 20,
                    offset: const Offset(0, 8))
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.network(
                m.storeImage,
                height: 140,
                width: 140,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  height: 140,
                  width: 140,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        AppColors.kPrimary.withOpacity(0.1),
                        AppColors.kPrimary.withOpacity(0.3),
                      ],
                    ),
                  ),
                  child: Icon(Icons.store_rounded,
                      size: 60, color: AppColors.kPrimary),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          m.shopName,
          style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1A1A1A)),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 6),
        Text(m.ownerName,
            style: TextStyle(color: Colors.grey[600], fontSize: 14)),
      ]),
    );
  }

  // ── Info Card ──────────────────────────────────────────────────────────────
  Widget _buildInfoCard({
    required IconData icon,
    required String title,
    required List<Widget> children,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 10,
              offset: const Offset(0, 2))
        ],
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.kPrimary.withOpacity(0.05),
            borderRadius:
            const BorderRadius.vertical(top: Radius.circular(16)),
          ),
          child: Row(children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.kPrimary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: AppColors.kPrimary, size: 20),
            ),
            const SizedBox(width: 12),
            Text(title,
                style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: AppColors.kPrimary)),
          ]),
        ),
        Padding(
          padding: const EdgeInsets.all(16),
          child: Column(children: children),
        ),
      ]),
    );
  }

  // ── Info Row ───────────────────────────────────────────────────────────────
  Widget _infoRow(IconData icon, String label, String value,
      {bool isLink = false}) {
    final isEmpty = value.isEmpty;
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Icon(icon,
            size: 20, color: isEmpty ? Colors.grey[400] : Colors.grey[600]),
        const SizedBox(width: 12),
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(label,
                style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500)),
            const SizedBox(height: 4),
            Text(
              isEmpty ? 'Not provided' : value,
              style: TextStyle(
                fontSize: 15,
                color: isEmpty
                    ? Colors.grey[400]
                    : (isLink ? Colors.blue[700] : const Color(0xFF1A1A1A)),
                fontWeight: FontWeight.w500,
                decoration:
                isLink && !isEmpty ? TextDecoration.underline : null,
                fontStyle: isEmpty ? FontStyle.italic : null,
              ),
            ),
          ]),
        ),
      ]),
    );
  }

  // ── Social Row ─────────────────────────────────────────────────────────────
  Widget _socialRow(IconData icon, String label, String value, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8)),
          child: Icon(icon, size: 18, color: color),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(label,
                style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500)),
            const SizedBox(height: 2),
            Text(value,
                style: TextStyle(
                    fontSize: 14, color: color, fontWeight: FontWeight.w500),
                maxLines: 1,
                overflow: TextOverflow.ellipsis),
          ]),
        ),
        Icon(Icons.open_in_new, size: 16, color: Colors.grey[400]),
      ]),
    );
  }

  // ── Coordinates Row ────────────────────────────────────────────────────────
  Widget _buildCoordinatesRow(
      {required String latitude, required String longitude}) {
    final isEmpty = latitude.isEmpty || latitude == '0.0';
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Icon(Icons.map_outlined, size: 20, color: Colors.grey[600]),
        const SizedBox(width: 12),
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('Coordinates',
                style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500)),
            const SizedBox(height: 4),
            Text(
              isEmpty ? 'Not set' : '$latitude, $longitude',
              style: TextStyle(
                fontSize: 15,
                color: isEmpty ? Colors.grey[400] : const Color(0xFF1A1A1A),
                fontWeight: FontWeight.w500,
                fontStyle: isEmpty ? FontStyle.italic : null,
              ),
            ),
          ]),
        ),
        if (!isEmpty)
          Icon(Icons.my_location, color: AppColors.kPrimary, size: 20),
      ]),
    );
  }
}