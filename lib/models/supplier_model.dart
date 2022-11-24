class Supplier {
  String? clientId;
  String? clientCode;
  String? clientName;
  String? groupId;
  String? groupName;
  String? address1;
  String? mobile;

  Supplier(
      {this.clientId,
      this.clientCode,
      this.clientName,
      this.groupId,
      this.groupName,
      this.address1,
      this.mobile});

  Supplier.fromJson(Map<String, dynamic> json) {
    clientId = json['client_id'];
    clientCode = json['ClientCode'];
    clientName = json['ClientName'];
    groupId = json['group_id'];
    groupName = json['GroupName'];
    address1 = json['Address1'];
    mobile = json['Mobile'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['client_id'] = clientId;
    data['ClientCode'] = clientCode;
    data['ClientName'] = clientName;
    data['group_id'] = groupId;
    data['GroupName'] = groupName;
    data['Address1'] = address1;
    data['Mobile'] = mobile;
    return data;
  }

  @override
  String toString() {
    return clientName ?? "";
  }
}
