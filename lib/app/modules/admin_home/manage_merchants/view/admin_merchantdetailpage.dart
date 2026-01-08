
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:io';

import '../../../../common/style/app_colors.dart';
import '../../../../common/style/app_text_style.dart';

class AdminMerchantDetailPageUI extends StatefulWidget {
  final Map<String, String?> merchant;

  const AdminMerchantDetailPageUI({super.key, required this.merchant});

  @override
  State<AdminMerchantDetailPageUI> createState() =>
      _AdminMerchantDetailPageUIState();
}

class _AdminMerchantDetailPageUIState extends State<AdminMerchantDetailPageUI> {
  late String currentStatus;

  @override
  void initState() {
    super.initState();
    currentStatus = widget.merchant["status"] ?? "Pending";
  }

  @override
  Widget build(BuildContext context) {
    Color statusColor = _getStatusColor(currentStatus);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Merchant Details",
          style: AppTextStyle.rTextNunitoWhite17w700,
        ),
        backgroundColor: AppColors.kPrimary,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Store Image + Status Badge
            Stack(
              alignment: Alignment.topRight,
              children: [
                Center(
                  child: widget.merchant["image"] != null
                      ? ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.file(
                      File(widget.merchant["image"]!),
                      width: 150,
                      height: 150,
                      fit: BoxFit.cover,
                    ),
                  )
                      : Container(
                    width: 150,
                    height: 150,
                    decoration: BoxDecoration(
                      color: AppColors.kPrimary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: AppColors.kPrimary.withOpacity(0.3),
                        width: 2,
                      ),
                    ),
                    child: Icon(
                      Icons.storefront,
                      size: 80,
                      color: AppColors.kPrimary,
                    ),
                  ),
                ),
                // Status Badge
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: statusColor,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: statusColor.withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Text(
                    currentStatus,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Merchant Details Card
            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Merchant Information",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.kPrimary,
                      ),
                    ),
                    const Divider(height: 24),
                    _buildDetailRow(
                      Icons.store,
                      "Shop Name",
                      widget.merchant["shopName"] ?? "-",
                    ),
                    _buildDetailRow(
                      Icons.person,
                      "Owner Name",
                      widget.merchant["ownerName"] ?? "-",
                    ),
                    _buildDetailRow(
                      Icons.email,
                      "Email",
                      widget.merchant["email"] ?? "-",
                    ),
                    _buildDetailRow(
                      Icons.phone,
                      "Phone",
                      widget.merchant["phone"] ?? "-",
                    ),
                    const SizedBox(height: 16),
                    Text(
                      "Location Details",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.kPrimary,
                      ),
                    ),
                    const Divider(height: 24),
                    _buildDetailRow(
                      Icons.location_city,
                      "State",
                      widget.merchant["state"] ?? "-",
                    ),
                    _buildDetailRow(
                      Icons.map,
                      "District",
                      widget.merchant["district"] ?? "-",
                    ),
                    _buildDetailRow(
                      Icons.location_on,
                      "Location",
                      widget.merchant["location"] ?? "-",
                    ),
                    _buildDetailRow(
                      Icons.home,
                      "Address",
                      widget.merchant["address"] ?? "-",
                    ),
                    const SizedBox(height: 16),
                    Text(
                      "Social Media",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.kPrimary,
                      ),
                    ),
                    const Divider(height: 24),
                    _buildDetailRow(
                      Icons.phone_android,
                      "WhatsApp",
                      widget.merchant["whatsapp"] ?? "-",
                    ),
                    _buildDetailRow(
                      Icons.facebook,
                      "Facebook",
                      widget.merchant["facebook"] ?? "-",
                    ),
                    _buildDetailRow(
                      Icons.camera_alt,
                      "Instagram",
                      widget.merchant["instagram"] ?? "-",
                    ),
                    _buildDetailRow(
                      Icons.language,
                      "Website",
                      widget.merchant["website"] ?? "-",
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),

            // Approve / Reject Buttons (only show if status is Pending)
            if (currentStatus.toLowerCase() == "pending")
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: ElevatedButton.icon(
                        onPressed: () => _handleApprove(),
                        icon: const Icon(Icons.check, color: Colors.white),
                        label: const Text(
                          "Approve",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 3,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: ElevatedButton.icon(
                        onPressed: () => _handleReject(),
                        icon: const Icon(Icons.close, color: Colors.white),
                        label: const Text(
                          "Reject",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 3,
                        ),
                      ),
                    ),
                  ),
                ],
              ),

            // Show current status if already approved/rejected
            if (currentStatus.toLowerCase() != "pending")
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: statusColor, width: 2),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      currentStatus.toLowerCase() == "approved"
                          ? Icons.check_circle
                          : Icons.cancel,
                      color: statusColor,
                      size: 24,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      "This merchant has been $currentStatus",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: statusColor,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            size: 20,
            color: AppColors.kPrimary.withOpacity(0.7),
          ),
          const SizedBox(width: 12),
          Expanded(
            flex: 2,
            child: Text(
              "$label:",
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 15,
                color: Colors.black87,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 15,
                color: Colors.black54,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case "approved":
        return Colors.green;
      case "rejected":
        return Colors.red;
      case "pending":
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  void _handleApprove() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Approve Merchant"),
        content: Text(
          "Are you sure you want to approve ${widget.merchant["shopName"]}?",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              // TODO: Implement API call to approve merchant
              setState(() {
                currentStatus = "Approved";
              });
              Navigator.pop(context);
              Get.snackbar(
                "Success",
                "Merchant approved successfully!",
                backgroundColor: Colors.green,
                colorText: Colors.white,
                snackPosition: SnackPosition.BOTTOM,
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
            ),
            child: const Text("Approve"),
          ),
        ],
      ),
    );
  }

  void _handleReject() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Reject Merchant"),
        content: Text(
          "Are you sure you want to reject ${widget.merchant["shopName"]}?",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              // TODO: Implement API call to reject merchant
              setState(() {
                currentStatus = "Rejected";
              });
              Navigator.pop(context);
              Get.snackbar(
                "Success",
                "Merchant rejected successfully!",
                backgroundColor: Colors.red,
                colorText: Colors.white,
                snackPosition: SnackPosition.BOTTOM,
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text("Reject"),
          ),
        ],
      ),
    );
  }
}