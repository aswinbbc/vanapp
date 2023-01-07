class CreditPurchaseinvoice {
  String? isSelect;
  String? billId;
  String? entryNo;
  String? billDate;
  String? vendorNo;
  String? balance;
  String? billType;

  CreditPurchaseinvoice(
      {this.isSelect,
      this.billId,
      this.entryNo,
      this.billDate,
      this.vendorNo,
      this.balance,
      this.billType});

  CreditPurchaseinvoice.fromJson(Map<String, dynamic> json) {
    isSelect = json['is_select'];
    billId = json['billId'];
    entryNo = json['entry_no'];
    billDate = json['billDate'];
    vendorNo = json['vendorNo'];
    balance = json['balance'];
    billType = json['billType'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['is_select'] = isSelect;
    data['billId'] = billId;
    data['entry_no'] = entryNo;
    data['billDate'] = billDate;
    data['vendorNo'] = vendorNo;
    data['balance'] = balance;
    data['billType'] = billType;
    return data;
  }
}
