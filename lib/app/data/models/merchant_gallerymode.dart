class MerchantImage {
  final int id;
  final String imageUrl;

  MerchantImage({
    required this.id,
    required this.imageUrl,
  });

  factory MerchantImage.fromJson(Map<String, dynamic> json) {
    return MerchantImage(
      id: json['id'],
      imageUrl: json['image_url'], // ✅ EXACT API KEY
    );
  }
}
