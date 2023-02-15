import 'package:vanapp/models/brand_model.dart';
import 'package:vanapp/models/category_model.dart';
import 'package:vanapp/models/credit_purchase_invoice_model.dart';
import 'package:vanapp/models/product_model.dart';
import 'package:vanapp/models/uom_model.dart';
import 'package:vanapp/utils/constants/utils.dart';
import 'package:vanapp/utils/network_service.dart';

import '../utils/constants/constant.dart';

class StockManagerController {
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

  Future<String> get inventoryId async {
    String branchId = "1";
    final List result =
        await loadServerData("Inventory/GetAllInventory?branch_id=$branchId");

    return result.first['InventoryId'];
  }

//stock taken
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

  Future<String> writeStockTakenDetails(
      {required String entryId,
      required String productId,
      unitId = '1',
      required String cost,
      String qty = '1'}) async {
    final List result = await loadServerData(
            "StockTaken/WriteStockTakenDetails?entry_id=$entryId&product_id=$productId&unit_id=$unitId&cost=$cost&qty=$qty") ??
        ['error'];
    print(result);
    return result.first.toString();
  }

  Future<String> writeStockFinish({
    entry = '1',
  }) async {
    final List result =
        await loadServerData("StockTaken/WriteStockLedger?entry_id=$entry");

    return result.first['status'];
  }
//--stock taken

//GRN
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

  Future<String> writeGrnDetails(
      {required String entryId,
      required String productId,
      uomName = 'PCS',
      uomId = '1',
      required String cost,
      String qty = '1'}) async {
    final List? result = await loadServerData(
        "GoodsReceipt/WriteGRNDetails?slno=1&entryid=$entryId&product_id=$productId&qty=$qty&inv_code=Company&uom_name=$uomName&uom_id=$uomId&price=$cost");
    print(result);
    return result != null ? result.first.toString() : 'error';
  }

  //--GRN

  // Purchase return
  Future<List<CreditPurchaseinvoice>> getCreditPurchaseinvoices(
      {branchId = '1', required String clientId}) async {
    final List result = await loadServerData(
        "PurchaseReturn/GetCreditPurchaseinvoice?branch_id=$branchId&clientId=$clientId");
    return result.map((json) => CreditPurchaseinvoice.fromJson(json)).toList();
  }

  Future<String> writePurchaseReturnMaster({
    required String supplierId,
    required String netTotal,
    required String recipt,
    required String purchaseId,
    required String purchaseType,
    systemId = '1',
    userId = '1',
  }) async {
    String entryDate = currentDate;
    userId = await Constants.userId;
    final List result = await loadServerData(
        "PurchaseReturn/WritePurchaseReturnMaster?system_id=$systemId&entry_date=$entryDate&supplier_id=$supplierId&user_id=$userId&discount=0&other_charges=0&net_total=$netTotal&receipt=$recipt&ref_no=aa&narration=nil&purchase_id=$purchaseId&purchase_type=$purchaseType");
    await loadServerData(
        "PurchaseReturn/AccountsPosting?entry_date=$entryDate&supplier_id=$supplierId&narration=nil&return_amount=$netTotal&receipt_amount=$recipt&system_id=$systemId&pr_entry_id=${result.first['BillID']}&pr_entry_no=${result.first['bill_no']}");
    return result.first['bill_no'];
  }

  Future<String> writePurchaseReturnDetails(
      {required String salesId,
      required String productId,
      required String slNo,
      uomName = 'PCS',
      required String cost,
      String qty = '1'}) async {
    String total = (double.parse(cost) * double.parse(qty)).toString();

    final List result = await loadServerData(
        "PurchaseReturn/WritePurchaseReturnDetails?sales_id=$salesId&Sl_no=$slNo&product_id=$productId&qty=$qty&price=$cost&row_disocunt=0&net_price=$total&inv_code=company&uom=$uomName&narration=aa");

    return result.first.toString();
  }
  //--purchase return
}

class ProductController {
  Future<List<UOMModel>> getUOMs() async {
    final List result = await loadServerData("product/GetAllUoMList");

    return result.map((json) => UOMModel.fromJson(json)).toList();
  }

  Future<List<CategoryModel>> getCategories() async {
    final List result = await loadServerData("product/GetAllCategory");

    return result.map((json) => CategoryModel.fromJson(json)).toList();
  }

  Future<List<BrandModel>> getbrands() async {
    final List result = await loadServerData("product/GetAllBrand");

    return result.map((json) => BrandModel.fromJson(json)).toList();
  }

  Future<bool> isBarcodeExist(String barcode) async {
    final List result =
        await loadServerData("product/BarcodeExistCheck?barcode=$barcode");

    return result.first['status'] == 'true';
  }

  Future<String> createProduct(
      {required String barcode,
      required prodName,
      required String catId,
      required String brandId,
      String systemId = "1",
      required String uomId,
      required String uomName,
      required String purchasePrice,
      required String retailPrice}) async {
    String userId = await Constants.userId;
    final List result = await loadServerData(
        "product/WriteProduct?productName=$prodName&category_id=$catId&brand_id=$brandId&barcode=$barcode&system_id=$systemId&user_id=$userId&uom_id=$uomId&uom_name=$uomName&purchase_price=$purchasePrice&retail_price=$retailPrice");

    return result.first['status'];
  }
}
