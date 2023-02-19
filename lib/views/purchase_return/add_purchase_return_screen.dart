import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:vanapp/utils/constants/utils.dart';

import '../../controllers/product_controller.dart';
import '../../models/product_model.dart';
import '../../widgets/custom_textfield.dart';
import '../../widgets/my_barcode_scanner.dart';
import '../../widgets/product_data_table.dart';

class AddPurchaseReturnScreen extends StatefulWidget {
  const AddPurchaseReturnScreen(
      {super.key,
      required this.supplierId,
      required this.paymentMode,
      this.purchaseId,
      this.purchaseType});
  final String supplierId, paymentMode;
  final String? purchaseId, purchaseType;

  @override
  State<AddPurchaseReturnScreen> createState() =>
      _AddPurchaseReturnScreenState();
}

class _AddPurchaseReturnScreenState extends State<AddPurchaseReturnScreen> {
  final TextEditingController barcodeController = TextEditingController();
  final TextEditingController productNameController = TextEditingController();
  final TextEditingController retailPriceController = TextEditingController();
  final TextEditingController qtyController = TextEditingController();
  final TextEditingController barcodeViewController = TextEditingController();
  final TextEditingController unitController = TextEditingController();

  final TextEditingController stockController = TextEditingController();
  final TextEditingController priceController = TextEditingController();

  var focusNode = FocusNode();
  bool isSearching = false;
  List<Map<String, dynamic>> productList = [
    // {
    //   'product': ProductModel(
    //     productName: "apple",
    //     cost: "20.00",
    //   ),
    //   'qty': 1
    // }
  ];
  ProductModel? sampleProduct;

  bool isTableVisible = false;

  FocusNode quanityFocusNode = FocusNode();

  var total = 0.0;

  var isSubmitted = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 40,
      ),
      body: Stack(
        children: [
          Visibility(
            visible: isSubmitted,
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          ),
          Visibility(
            maintainState: true,
            visible: !isTableVisible,
            child: Column(
              children: [
                MyBarcodeScanner(
                  focusNode: focusNode,
                  controller: barcodeController,
                  onBarcode: (barcode) {
                    // if (isValidBarcode(barcode)) {
                    setState(() {
                      isSearching = true;
                    });
                    StockManagerController()
                        .getProductByBarcode(barcode)
                        .then((value) {
                      setState(() {
                        sampleProduct = value;
                        productNameController.text = value.productName ?? "";
                        retailPriceController.text = value.cost ?? "";
                        unitController.text = value.uom ?? "";
                        stockController.text = value.stock ?? "";
                        priceController.text = value.retailPrice ?? "";
                        barcodeViewController.text = value.barcode ?? '';
                        isSearching = false;
                        if ((value.prodId ?? '').isNotEmpty) {
                          barcodeController.text = '';
                          quanityFocusNode.requestFocus();
                        }
                        // value.prodId != null ? FocusScope.of(context).unfocus() : null;
                      });
                    });
                    // }
                  },
                ),
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: CustomTextField(
                        hintText: "Barcode",
                        enabled: false,
                        controller: barcodeViewController,
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: CustomTextField(
                        hintText: "Unit",
                        enabled: false,
                        controller: unitController,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: CustomTextField(
                        style: const TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.w600,
                            fontSize: 20),
                        hintText: "Stock",
                        enabled: false,
                        controller: stockController,
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: CustomTextField(
                        hintText: "Retail price",
                        enabled: false,
                        controller: priceController,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                        flex: 2,
                        child: CustomTextField(
                          hintText: "Product name",
                          enabled: false,
                          controller: productNameController,
                        )),
                    Expanded(
                        child: CustomTextField(
                      hintText: "Cost",
                      controller: retailPriceController,
                    )),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                        child: CustomTextField(
                      focusNode: quanityFocusNode,
                      hintText: "Qty eg:- 1",
                      inputType: TextInputType.number,
                      controller: qtyController,
                    )),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: SizedBox(
                          height: 60,
                          child: GFButton(
                            onPressed: () {
                              setState(() {
                                if (sampleProduct != null) {
                                  sampleProduct!.cost =
                                      retailPriceController.text;
                                  productList.add({
                                    'product': sampleProduct,
                                    'qty': double.parse(
                                        qtyController.text.isEmpty
                                            ? "1"
                                            : qtyController.text)
                                  });
                                }
                                calculateTotal();
                                barcodeController.clear();
                                productNameController.clear();
                                retailPriceController.clear();
                                barcodeViewController.clear();
                                unitController.clear();
                                stockController.clear();
                                priceController.clear();
                                qtyController.clear();
                                focusNode.requestFocus();
                                sampleProduct = null;

                                calculateTotal();
                              });
                            },
                            text: "Add",
                            type: GFButtonType.solid,
                            fullWidthButton: true,
                            blockButton: true,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Visibility(
              visible: isTableVisible,
              child: SingleChildScrollView(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 18.0),
                    child: Text(
                      'Net Total : ${total.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 18.0),
                    child: Text(
                      'Recipt : ${widget.paymentMode == 'Cash' ? total.toStringAsFixed(2) : '0.00'}',
                      style: const TextStyle(
                          fontWeight: FontWeight.w800,
                          color: Colors.green,
                          fontSize: 20),
                    ),
                  ),
                  ProductDataTable(
                    listOfColumns: productList,
                    onRemove: (index) {
                      setState(() {
                        productList.removeAt(index);
                        calculateTotal();
                      });
                    },
                  ),
                ],
              ))),
          Align(
            alignment: Alignment.bottomLeft,
            child: Padding(
              padding: const EdgeInsets.all(18.0),
              child: SizedBox(
                height: 60,
                width: 220,
                child: GFButton(
                  onPressed: !isSubmitted ? submitPurchaseReturn : null,
                  text: "Submit",
                  type: GFButtonType.solid,
                  fullWidthButton: true,
                  blockButton: true,
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: const EdgeInsets.all(18.0),
              child: FloatingActionButton(
                  onPressed: () {
                    setState(() {
                      isTableVisible = !isTableVisible;
                    });
                  },
                  child: isTableVisible
                      ? const Icon(Icons.arrow_circle_up)
                      : const Icon(Icons.arrow_circle_down)),
            ),
          ),
        ],
      ),
    );
  }

  void submitPurchaseReturn() async {
    if (productList.isNotEmpty) {
      setState(() {
        isSubmitted = true;
      });
      final String entryId =
          await StockManagerController().writePurchaseReturnMaster(
        purchaseId: widget.purchaseId ?? '0',
        purchaseType: widget.purchaseType ?? 'nil',
        netTotal: total.toString(),
        recipt:
            widget.paymentMode == 'Cash' ? total.toStringAsFixed(2) : '0.00',
        supplierId: widget.supplierId,
      );
      int i = 1;
      await Future.wait(productList.map((productMap) async {
        ProductModel product = productMap['product'];

        await StockManagerController().writePurchaseReturnDetails(
            salesId: entryId,
            uomName: product.uom,
            productId: product.prodId!,
            cost: double.parse(product.cost!).toStringAsFixed(0),
            slNo: (i++).toString(),
            qty: productMap['qty'].toString());
      }));

      setState(() {
        productList.clear();
        calculateTotal();
        isSubmitted = false;
      });
    } else {
      showToast('empty list....');
    }
  }

  void calculateTotal() {
    total = productList.isNotEmpty
        ? productList.map((productMap) {
            ProductModel product = productMap['product'];
            double price = double.parse(product.cost ?? '0');
            double qty = productMap['qty'];
            return price * qty;
          }).reduce((a, b) => a + b)
        : 0;
  }
}
