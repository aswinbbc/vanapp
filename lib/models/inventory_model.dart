class InventoryModel {
  String? inventoryId;
  String? code;
  String? name;
  String? address;
  String? contactNo;
  String? authorizedPerson;
  String? creditLimit;
  String? creditDays;
  String? priceLevel;
  String? invType;
  String? isRemovable;
  String? branchId;

  InventoryModel(
      {this.inventoryId,
      this.code,
      this.name,
      this.address,
      this.contactNo,
      this.authorizedPerson,
      this.creditLimit,
      this.creditDays,
      this.priceLevel,
      this.invType,
      this.isRemovable,
      this.branchId});

  InventoryModel.fromJson(Map<String, dynamic> json) {
    inventoryId = json['InventoryId'];
    code = json['code'];
    name = json['name'];
    address = json['Address'];
    contactNo = json['ContactNo'];
    authorizedPerson = json['AuthorizedPerson'];
    creditLimit = json['CreditLimit'];
    creditDays = json['CreditDays'];
    priceLevel = json['PriceLevel'];
    invType = json['invType'];
    isRemovable = json['isRemovable'];
    branchId = json['branch_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['InventoryId'] = inventoryId;
    data['code'] = code;
    data['name'] = name;
    data['Address'] = address;
    data['ContactNo'] = contactNo;
    data['AuthorizedPerson'] = authorizedPerson;
    data['CreditLimit'] = creditLimit;
    data['CreditDays'] = creditDays;
    data['PriceLevel'] = priceLevel;
    data['invType'] = invType;
    data['isRemovable'] = isRemovable;
    data['branch_id'] = branchId;
    return data;
  }
}
