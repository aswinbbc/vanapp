import 'package:vanapp/models/supplier_model.dart';

import '../utils/network_service.dart';

class SupplierController {
  Future<List<Supplier>> getSuppliers() async {
    final List result = await loadServerData("GoodsReceipt/GetSupplierList");

    return result.map((json) => Supplier.fromJson(json)).toList();
  }
}
