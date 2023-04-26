import 'package:vanapp/models/supplier_model.dart';

import '../utils/network_service.dart';

class CompanyController {
  Future<List<Supplier>> getBranches() async {
    final List result = await loadServerData("GoodsReceipt/GetSupplierList");

    return result.map((json) => Supplier.fromJson(json)).toList();
  }
}
