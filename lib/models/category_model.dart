class CategoryModel {
  String? ctId;
  String? categoryName;
  String? isActive;
  String? categImage;

  CategoryModel({this.ctId, this.categoryName, this.isActive, this.categImage});

  CategoryModel.fromJson(Map<String, dynamic> json) {
    ctId = json['pc_id'];
    categoryName = json['pc_name'];
    isActive = json['is_active'];
    categImage = json['categ_image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['pc_id'] = ctId;
    data['pc_name'] = categoryName;
    data['is_active'] = isActive;
    data['categ_image'] = categImage;
    return data;
  }

  @override
  String toString() {
    return categoryName ?? "";
  }
}
