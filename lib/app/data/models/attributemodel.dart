class CategoryAttributeModel {
  final String name;
  final String? customName;
  final List<String> values;

  CategoryAttributeModel({
    required this.name,
    this.customName,
    required this.values,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      "name": name,
      "values": values,
    };

    if (customName != null && customName!.isNotEmpty) {
      data["custom_name"] = customName;
    }

    return data;
  }
}
