import 'package:vanapp/models/supplier_model.dart';

import '../utils/network_service.dart';

class SupplierController {
  Future<List<String>> getSuppliers() async {
    final List result = await getData("GoodsReceipt/GetSupplierList");

    return result.map((json) => Supplier.fromJson(json).toString()).toList();
  }
}
