class StockEntryModel {
  String? stEntryId;
  String? stockTakenName;

  StockEntryModel({this.stEntryId, this.stockTakenName});

  StockEntryModel.fromJson(Map<String, dynamic> json) {
    stEntryId = json['st_entry_id'];
    stockTakenName = json['stock_taken_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['st_entry_id'] = stEntryId;
    data['stock_taken_name'] = stockTakenName;
    return data;
  }

  @override
  String toString() {
    return stockTakenName ?? '';
  }
}
