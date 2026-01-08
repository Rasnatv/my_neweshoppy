// class CategoryRequest {
//   String title;
//   String image; // base64 string
//   List<ItemData> itemsData;
//
//   CategoryRequest({
//     required this.title,
//     required this.image,
//     required this.itemsData,
//   });
//
//   Map<String, dynamic> toJson() {
//     return {
//       "title": title,
//       "image": image,
//       "items_data": itemsData.map((e) => e.toJson()).toList(),
//     };
//   }
// }
//
// class ItemData {
//   String name;
//   String? customName;
//   List<String> values;
//
//   ItemData({
//     required this.name,
//     this.customName,
//     required this.values,
//   });
//
//   Map<String, dynamic> toJson() {
//     final data = <String, dynamic>{
//       "name": name,
//       "values": values,
//     };
//
//     if (customName != null) {
//       data["custom_name"] = customName;
//     }
//
//     return data;
//   }
// }
class CategoryRequest {
  String title;
  String image;
  List<ItemData> itemsData;

  CategoryRequest({
    required this.title,
    required this.image,
    required this.itemsData,
  });

  Map<String, dynamic> toJson() {
    return {
      "title": title,
      "image": image,
      "items_data": itemsData.map((e) => e.toJson()).toList(),
    };
  }
}

class ItemData {
  String name;
  String? customName;
  List<String> values;

  ItemData({
    required this.name,
    this.customName,
    required this.values,
  });

  Map<String, dynamic> toJson() {
    final map = {
      "name": name,
      "values": values,
    };

    if (customName != null && customName!.trim().isNotEmpty) {
      map["custom_name"] = customName!;
    }

    return map;
  }
}

