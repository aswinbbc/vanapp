import 'package:vanapp/models/credit_purchase_invoice_model.dart';
import 'package:vanapp/models/product_model.dart';
import 'package:vanapp/utils/constants/utils.dart';
import 'package:vanapp/utils/network_service.dart';

import '../utils/constants/constant.dart';

class ProductController {
  Future<ProductModel> getProductByBarcode(
    String barcode,
  ) async {
    final List result = await loadServerData(
        "Product/GetProdDetailsByBarcode?barcode=$barcode");

    return ProductModel.fromJson(result.first);
  }

  Future<String> get zeroStockEntryId async {
    final List result =
        await loadServerData("StockTaken/GetZeroStockEntries?branch_id=1");

    return result.first['st_entry_id'];
  }

  Future<String> enterStock(
    String entryId,
    String supplier,
  ) async {
    final List result = await loadServerData(
        "StockTaken/WriteStockTakenDetails?entry_id=3&product_id=2&unit_id=1&cost=25&qty=15");

    return result.first.toString();
  }

  Future<String> get inventoryId async {
    String branchId = "1";
    final List result =
        await loadServerData("Inventory/GetAllInventory?branch_id=$branchId");

    return result.first['InventoryId'];
  }

  Future<String> writeStockTakenMaster({
    stockTakenEmpId = '1',
    narration = 'testings',
    appUserId = '4',
    refNo = 'aa',
    systemId = '1',
  }) async {
    appUserId = await Constants.userId;
    String inventoryId = await this.inventoryId;
    String zeroEntryId = await zeroStockEntryId;
    String entryDate = currentDate;
    final List result = await loadServerData(
        "StockTaken/WriteStockTakenMaster?entry_date=$entryDate&ref_no=$refNo&stock_taken_emp_id=$stockTakenEmpId&inventory_id=$inventoryId&narration=testings&app_user_id=$appUserId&zero_stock_entry_id=$zeroEntryId&system_id=$systemId");
    return result.first['entry_id'];
  }

  Future<String> writeGrnMaster({
    required String supplierId,
    systemId = '1',
    userId = '1',
  }) async {
    String entryDate = currentDate;
    userId = await Constants.userId;

    final List result = await loadServerData(
        "GoodsReceipt/WriteGRNMaster?supplier_id=$supplierId&entry_date=$entryDate&system_id=$systemId&user_id=$userId");

    return result.first['BILLID'];
  }

  Future<String> writeStockFinish({
    entry = '1',
  }) async {
    final List result =
        await loadServerData("StockTaken/WriteStockLedger?entry_id=$entry");

    return result.first['status'];
  }

  Future<String> writeStockTakenDetails(
      {required String entryId,
      required String productId,
      unitId = '1',
      required String cost,
      String qty = '1'}) async {
    final List result = await loadServerData(
        "StockTaken/WriteStockTakenDetails?entry_id=$entryId&product_id=$productId&unit_id=$unitId&cost=$cost&qty=$qty");
    return result.first.toString();
  }

  Future<String> writeGrnDetails(
      {required String entryId,
      required String productId,
      uomName = 'PCS',
      uomId = '1',
      required String cost,
      String qty = '1'}) async {
    final List result = await loadServerData(
        "GoodsReceipt/WriteGRNDetails?slno=1&entryid=$entryId&product_id=$productId&qty=$qty&inv_code=Company&uom_name=$uomName&uom_id=$uomId&price=$cost");

    return result.first.toString();
  }

  Future<List<CreditPurchaseinvoice>> getCreditPurchaseinvoices(
      {branchId = '1', required String clientId}) async {
    final List result = await loadServerData(
        "PurchaseReturn/GetCreditPurchaseinvoice?branch_id=$branchId&clientId=$clientId");
    print(result);
    return result.map((json) => CreditPurchaseinvoice.fromJson(json)).toList();
  }
}
