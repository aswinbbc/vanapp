import 'package:flutter/material.dart';
import 'package:getwidget/components/button/gf_button.dart';
import 'package:getwidget/types/gf_button_type.dart';
import 'package:vanapp/utils/constants/utils.dart';
import 'package:vanapp/widgets/custom_textfield.dart';
import 'package:vanapp/widgets/my_barcode_scanner.dart';
import 'package:vanapp/widgets/product_data_table.dart';

import '../controllers/product_controller.dart';
import '../models/product_model.dart';

class WriteStockScreen extends StatefulWidget {
  const WriteStockScreen({super.key});
  String get title => 'Enter Stock';
  @override
  State<WriteStockScreen> createState() => _WriteStockScreenState();
}

class _WriteStockScreenState extends State<WriteStockScreen> {
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

  var isSubmitted = false;

  @override
  Widget build(BuildContext context) {
    return Stack(
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
                    if (value.prodId != null) {
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
                    }
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
                    enabled: false,
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
                                productList.add({
                                  'product': sampleProduct,
                                  'qty': double.parse(qtyController.text.isEmpty
                                      ? "1"
                                      : qtyController.text)
                                });
                              }
                              barcodeController.clear();
                              productNameController.clear();
                              retailPriceController.clear();
                              barcodeViewController.clear();
                              unitController.clear();
                              stockController.clear();
                              priceController.clear();
                              qtyController.clear();
                              focusNode.requestFocus();
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
                child: ProductDataTable(
              listOfColumns: productList,
              onRemove: (index) {
                setState(() {
                  productList.removeAt(index);
                });
              },
            ))),
        Align(
          alignment: Alignment.bottomLeft,
          child: Padding(
            padding: const EdgeInsets.all(18.0),
            child: SizedBox(
              height: 60,
              width: 220,
              child: GFButton(
                onPressed: !isSubmitted ? submitStockTaken : null,
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
    );
  }

  void submitStockTaken() async {
    setState(() {
      isSubmitted = true;
    });
    if (productList.isNotEmpty) {
      final String entryId =
          await StockManagerController().writeStockTakenMaster();
      await Future.wait(productList.map((productMap) async {
        ProductModel product = productMap['product'];
        await StockManagerController().writeStockTakenDetails(
            entryId: entryId,
            unitId: product.uomId,
            productId: product.prodId!,
            cost: product.cost!,
            qty: productMap['qty'].toString());
      }));
      await StockManagerController().writeStockFinish(entry: entryId);
      setState(() {
        productList.clear();
        isSubmitted = false;
      });
    } else {
      showToast('empty list...');
      setState(() {
        isSubmitted = false;
      });
    }
  }
}
