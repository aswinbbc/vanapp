import 'package:vanapp/models/product_model.dart';
import 'package:vanapp/utils/constants/utils.dart';
import 'package:vanapp/utils/network_service.dart';

class ProductController {
  Future<ProductModel> getProductByBarcode(
    String barcode,
  ) async {
    final List result =
        await getData("Product/GetProdDetailsByBarcode?barcode=$barcode");

    return ProductModel.fromJson(result.first);
  }

  Future<String> get zeroStockEntryId async {
    final List result =
        await getData("StockTaken/GetZeroStockEntries?branch_id=1");
    print(result);
    return result.first['entry_id'];
  }

  Future<String> enterStock(
    String entryId,
    String supplier,
  ) async {
    final List result = await getData(
        "StockTaken/WriteStockTakenDetails?entry_id=3&product_id=2&unit_id=1&cost=25&qty=15");
    print(result);
    return result.first.toString();
  }

  Future<String> get inventoryId async {
    String branchId = "1";
    final List result =
        await getData("Inventory/GetAllInventory?branch_id=$branchId");
    print(result);
    return result.first['InventoryId'];
  }

  Future<String> writeStockTakenMaster({
    stockTakenEmpId = '1',
    narration = 'testings',
    appUserId = '4',
    refNo = 'aa',
    systemId = '29',
  }) async {
    String inventoryId = await this.inventoryId;
    String zeroEntryId = await zeroStockEntryId;
    String entryDate = currentDate;
    final List result = await getData(
        "StockTaken/WriteStockTakenMaster?entry_date=$entryDate&ref_no=$refNo&stock_taken_emp_id=$stockTakenEmpId&inventory_id=$inventoryId&narration=testings&app_user_id=$appUserId&zero_stock_entry_id=$zeroEntryId&system_id=$systemId");
    print(result);
    return result.first['entry_id'];
  }

  Future<String> writeGrnMaster({
    required String supplierId,
    systemId = '29',
    userId = '1',
  }) async {
    String entryDate = currentDate;
    final List result = await getData(
        "GoodsReceipt/WriteGRNMaster?supplier_id=$supplierId&entry_date=$entryDate&system_id=$systemId&user_id=$userId");
    print(result);
    return result.first['entry_id'];
  }

  Future<String> writeStockTakenDetails(
      {required String entryId,
      required String productId,
      unitId = '1',
      required String cost,
      String qty = '1'}) async {
    final List result = await getData(
        "StockTaken/WriteStockTakenDetails?entry_id=$entryId&product_id=$productId&unit_id=$unitId&cost=$cost&qty=$qty");
    print(result);
    return result.first.toString();
  }
}
