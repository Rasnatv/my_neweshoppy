class Manageproductmodel{
  final String id;
  final String name;
  final String imagePath;
  final double price;

  Manageproductmodel({
    required this.id,
    required this.name,
    required this.imagePath,
    required this.price,
  });

  Manageproductmodel copyWith({
    String? id,
    String? name,
    String? imagePath,
    double? price,
  }) {
    return Manageproductmodel(
      id: id ?? this.id,
      name: name ?? this.name,
      imagePath: imagePath ?? this.imagePath,
      price: price ?? this.price,
    );
  }
}
