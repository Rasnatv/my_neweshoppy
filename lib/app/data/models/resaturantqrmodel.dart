
class PaymentResponseModel {
  final bool status;
  final int statusCode;
  final String message;
  final List<PaymentDetailModel> data;

  PaymentResponseModel({
    required this.status,
    required this.statusCode,
    required this.message,
    required this.data,
  });

  factory PaymentResponseModel.fromJson(Map<String, dynamic> json) {
    return PaymentResponseModel(
      status: json['status'] ?? false,
      statusCode: json['status_code'] ?? 0,
      message: json['message'] ?? '',
      data: (json['data'] as List)
          .map((e) => PaymentDetailModel.fromJson(e))
          .toList(),
    );
  }
}

class PaymentDetailModel {
  final String restaurantId;
  final String restaurantName;
  final String ownerName;
  final String upiId;
  final String qrCodeUrl;
  final double totalPrice;

  PaymentDetailModel({
    required this.restaurantId,
    required this.restaurantName,
    required this.ownerName,
    required this.upiId,
    required this.qrCodeUrl,
    required this.totalPrice,
  });

  factory PaymentDetailModel.fromJson(Map<String, dynamic> json) {
    return PaymentDetailModel(
      restaurantId: json['restaurant_id'] ?? '',
      restaurantName: json['restaurant_name'] ?? '',
      ownerName: json['owner_name'] ?? '',
      upiId: json['upi_id'] ?? '',
      qrCodeUrl: json['qr_code'] ?? '',
      totalPrice: double.tryParse(json['total_price'].toString()) ?? 0.0,
    );
  }

  bool get hasUpi => upiId.trim().isNotEmpty;
  bool get hasQrCode => qrCodeUrl.trim().isNotEmpty;
}