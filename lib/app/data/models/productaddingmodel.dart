

class AttributeModel {
  final String name;
  final bool allowMultipleValues;

  AttributeModel({
    required this.name,
    this.allowMultipleValues = true,
  });
}

class SubCategoryModel {
  final String name;
  final List<AttributeModel> attributes;

  SubCategoryModel({
    required this.name,
    required this.attributes,
  });
}

class CategoryModel {
  final String name;
  final List<SubCategoryModel> subcategories;

  CategoryModel({
    required this.name,
    required this.subcategories,
  });
}
