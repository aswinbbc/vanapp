class ProductModel {
  String? prodId;
  String? prodCode;
  String? barcode;
  String? productName;
  String? uomId;
  String? uom;
  String? retailPrice;
  String? cost;
  String? stock;

  ProductModel(
      {this.prodId,
      this.prodCode,
      this.barcode,
      this.productName,
      this.uomId,
      this.uom,
      this.retailPrice,
      this.cost,
      this.stock});

  ProductModel.fromJson(Map<String, dynamic> json) {
    prodId = json['ProdId'];
    prodCode = json['ProdCode'];
    barcode = json['Barcode'];
    productName = json['ProductName'];
    uomId = json['uom_id'];
    uom = json['uom'];
    retailPrice = json['RetailPrice'];
    cost = json['Cost'];
    stock = json['Stock'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['ProdId'] = prodId;
    data['ProdCode'] = prodCode;
    data['Barcode'] = barcode;
    data['ProductName'] = productName;
    data['uom_id'] = uomId;
    data['uom'] = uom;
    data['RetailPrice'] = retailPrice;
    data['Cost'] = cost;
    data['Stock'] = stock;
    return data;
  }
}
