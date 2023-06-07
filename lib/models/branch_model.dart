class Branch {
  String? branchId;
  String? branchName;
  String? branchAddress;
  String? branchContact;
  String? branchHead;
  String? rowsId;
  String? fkBranchId;
  String? primaryPriceLevel;
  String? salesPriceLevel;
  String? saPriceLevelCanChange;
  String? saLowestPriceLevel;
  String? quotationPriceLevel;
  String? qtnPriceLevelCanChange;
  String? salesOrderPriceLevel;
  String? saorderPriceLevelCanChange;
  String? salesBillNo;
  String? deliveryBillNo;
  String? quotatationBillNo;
  String? preventZeroStock;

  Branch(
      {this.branchId,
      this.branchName,
      this.branchAddress,
      this.branchContact,
      this.branchHead,
      this.rowsId,
      this.fkBranchId,
      this.primaryPriceLevel,
      this.salesPriceLevel,
      this.saPriceLevelCanChange,
      this.saLowestPriceLevel,
      this.quotationPriceLevel,
      this.qtnPriceLevelCanChange,
      this.salesOrderPriceLevel,
      this.saorderPriceLevelCanChange,
      this.salesBillNo,
      this.deliveryBillNo,
      this.quotatationBillNo,
      this.preventZeroStock});

  Branch.fromJson(Map<String, dynamic> json) {
    branchId = json['branch_id'];
    branchName = json['branch_name'];
    branchAddress = json['branch_address'];
    branchContact = json['branch_contact'];
    branchHead = json['branch_head'];
    rowsId = json['rows_id'];
    fkBranchId = json['fk_branch_id'];
    primaryPriceLevel = json['primary_price_level'];
    salesPriceLevel = json['sales_price_level'];
    saPriceLevelCanChange = json['sa_price_level_can_change'];
    saLowestPriceLevel = json['sa_lowest_price_level'];
    quotationPriceLevel = json['quotation_price_level'];
    qtnPriceLevelCanChange = json['qtn_price_level_can_change'];
    salesOrderPriceLevel = json['sales_order_price_level'];
    saorderPriceLevelCanChange = json['saorder_price_level_can_change'];
    salesBillNo = json['sales_bill_no'];
    deliveryBillNo = json['delivery_bill_no'];
    quotatationBillNo = json['quotatation_bill_no'];
    preventZeroStock = json['prevent_zero_stock'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['branch_id'] = branchId;
    data['branch_name'] = branchName;
    data['branch_address'] = branchAddress;
    data['branch_contact'] = branchContact;
    data['branch_head'] = branchHead;
    data['rows_id'] = rowsId;
    data['fk_branch_id'] = fkBranchId;
    data['primary_price_level'] = primaryPriceLevel;
    data['sales_price_level'] = salesPriceLevel;
    data['sa_price_level_can_change'] = saPriceLevelCanChange;
    data['sa_lowest_price_level'] = saLowestPriceLevel;
    data['quotation_price_level'] = quotationPriceLevel;
    data['qtn_price_level_can_change'] = qtnPriceLevelCanChange;
    data['sales_order_price_level'] = salesOrderPriceLevel;
    data['saorder_price_level_can_change'] = saorderPriceLevelCanChange;
    data['sales_bill_no'] = salesBillNo;
    data['delivery_bill_no'] = deliveryBillNo;
    data['quotatation_bill_no'] = quotatationBillNo;
    data['prevent_zero_stock'] = preventZeroStock;
    return data;
  }
}
