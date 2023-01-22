class BrandModel {
  String? brandId;
  String? brandName;
  String? isActive;

  BrandModel({this.brandId, this.brandName, this.isActive});

  BrandModel.fromJson(Map<String, dynamic> json) {
    brandId = json['pt_id'];
    brandName = json['pt_name'];
    isActive = json['is_active'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['pt_id'] = brandId;
    data['pt_name'] = brandName;
    data['is_active'] = isActive;
    return data;
  }

  @override
  String toString() {
    return brandName ?? "";
  }
}
