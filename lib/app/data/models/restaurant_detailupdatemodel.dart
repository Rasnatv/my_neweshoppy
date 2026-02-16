
class RestaurantUpdateRequest {
  final int restaurantId;
  final String? restaurantImage;
  final String? ownerName;
  final String? address;
  final String? phone;
  final String? email;
  final String? website;
  final String? whatsapp;
  final String? facebook;
  final String? instagram;
  final String? restaurantname;

  RestaurantUpdateRequest({
    required this.restaurantId,
    this.restaurantImage,
    this.ownerName,
    this.address,
    this.phone,
    this.email,
    this.website,
    this.whatsapp,
    this.facebook,
    this.instagram,
    this.restaurantname,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      "restaurant_id": restaurantId,
    };

    if (restaurantImage != null) data["restaurant_image"] = restaurantImage;
    if (ownerName != null) data["owner_name"] = ownerName;
    if (address != null) data["address"] = address;
    if (phone != null) data["phone"] = phone;
    if (email != null) data["email"] = email;
    if (website != null) data["website"] = website;
    if (whatsapp != null) data["whatsapp"] = whatsapp;
    if (facebook != null) data["facebook_link"] = facebook;
    if (instagram != null) data["instagram_link"] = instagram;
    if (restaurantname != null) data["restaurant_name"] = restaurantname;

    return data;
  }
}
