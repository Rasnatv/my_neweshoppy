class MerchantGalleryImage {
  final int id;
  final int merchantId;
  final String imageUrl;

  MerchantGalleryImage({
    required this.id,
    required this.merchantId,
    required this.imageUrl,
  });

  factory MerchantGalleryImage.fromJson(Map<String, dynamic> json) {
    return MerchantGalleryImage(
      id: json['id'],
      merchantId: int.parse(json['merchant_id'].toString()),
      imageUrl: json['image_url'],
    );
  }
}
