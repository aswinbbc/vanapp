class UOMModel {
  String? uomId;
  String? uomName;
  String? isSynch;

  UOMModel({this.uomId, this.uomName, this.isSynch});

  UOMModel.fromJson(Map<String, dynamic> json) {
    uomId = json['pm_id'];
    uomName = json['pc_name'];
    isSynch = json['is_synch'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['pm_id'] = uomId;
    data['pc_name'] = uomName;
    data['is_synch'] = isSynch;
    return data;
  }

  @override
  String toString() {
    return uomName ?? "";
  }
}
