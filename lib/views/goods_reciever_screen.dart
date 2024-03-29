import 'package:flutter/material.dart';
import 'package:getwidget/components/button/gf_button.dart';
import 'package:getwidget/types/gf_button_type.dart';
import 'package:vanapp/controllers/supplier_controller.dart';
import 'package:vanapp/models/supplier_model.dart';
import 'package:vanapp/utils/constants/utils.dart';
import 'package:vanapp/widgets/custom_textfield.dart';
import 'package:vanapp/widgets/my_barcode_scanner.dart';
import 'package:vanapp/widgets/product_data_table.dart';
import 'package:vanapp/widgets/my_dropdown.dart';

import '../controllers/product_controller.dart';
import '../models/product_model.dart';

class GoodsRecieverScreen extends StatefulWidget {
  const GoodsRecieverScreen({super.key});
  String get title => 'Goods reciever';

  @override
  State<GoodsRecieverScreen> createState() => _GoodsRecieverScreenState();
}

class _GoodsRecieverScreenState extends State<GoodsRecieverScreen> {
  final TextEditingController barcodeController = TextEditingController();
  final TextEditingController stockController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController barcodeViewController = TextEditingController();
  final TextEditingController unitController = TextEditingController();
  final TextEditingController productNameController = TextEditingController();
  final TextEditingController retailPriceController = TextEditingController();
  final TextEditingController qtyController = TextEditingController();
  final TextEditingController focController = TextEditingController();
  bool isSearching = false;
  final MyDropController controller = MyDropController();
  var focusNode = FocusNode();
  int count = 1;

  var total = 0.0;
  List<Map<String, dynamic>> productList = [
    // {
    //   'product': ProductModel(
    //     productName: "apple",
    //     cost: "20.00",
    //   ),
    //   'qty': 1
    // }
  ];
  List<Supplier> suppliers = [];

  ProductModel? sampleProduct;

  FocusNode quanityFocusNode = FocusNode();

  var isTableVisible = false;

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
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 1.0),
                child: Row(
                  children: [
                    const Expanded(child: Text("Supplier")),
                    const Text(" : "),
                    Expanded(
                        flex: 2,
                        child: FutureBuilder(
                            future: SupplierController().getSuppliers(),
                            builder: (context,
                                AsyncSnapshot<List<Supplier>> snapshot) {
                              if (snapshot.hasData) {
                                suppliers = snapshot.data!;
                              }
                              return snapshot.hasData
                                  ? MyDropdown(
                                      list: snapshot.data!
                                          .map(
                                              (supplier) => supplier.toString())
                                          .toList(),
                                      controller: controller,
                                    )
                                  : const Text("waiting.....");
                            })),
                  ],
                ),
              ),
              MyBarcodeScanner(
                controller: barcodeController,
                focusNode: focusNode,
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
                        stockController.text = value.stock ?? "";
                        priceController.text = value.retailPrice ?? "";
                        unitController.text = value.uom ?? "";

                        barcodeViewController.text = value.barcode ?? '';
                        isSearching = false;
                        if ((value.prodId ?? '').isNotEmpty) {
                          barcodeController.text = '';
                          quanityFocusNode.requestFocus();
                        }
                        // value.prodId != null
                        //     ? FocusScope.of(context).unfocus()
                        //     : null;
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
                    flex: 2,
                    child: CustomTextField(
                      style: const TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.w600,
                      ),
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
                        height: 50,
                        child: GFButton(
                          onPressed: () {
                            setState(() {
                              if (sampleProduct != null) {
                                productList.add({
                                  'product': sampleProduct,
                                  'count': count++,
                                  'qty': double.parse(qtyController.text.isEmpty
                                      ? "1"
                                      : qtyController.text)
                                });
                              }
                              sampleProduct = null;
                              barcodeController.clear();
                              productNameController.clear();
                              retailPriceController.clear();
                              barcodeViewController.clear();
                              stockController.clear();
                              priceController.clear();
                              unitController.clear();
                              qtyController.clear();
                              calculateTotal();
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
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 18.0, vertical: 8),
                child: Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: CustomTextField(
                        hintText: "FOC",
                        controller: focController,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      'Net Total : ${total.toStringAsFixed(2)}',
                      textAlign: TextAlign.justify,
                      style: const TextStyle(
                          fontWeight: FontWeight.w800,
                          color: Colors.green,
                          fontSize: 20),
                    ),
                  ],
                ),
              ),
              ProductDataTable(
                showCount: true,
                listOfColumns: productList,
                onRemove: (index) {
                  setState(() {
                    productList.removeAt(index);
                    calculateTotal();
                  });
                },
              ),
            ],
          )),
        ),
        Align(
          alignment: Alignment.bottomLeft,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 5),
            child: SizedBox(
              height: 60,
              width: 220,
              child: GFButton(
                onPressed: !isSubmitted ? submitGRN : null,
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
            padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 5),
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

  void submitGRN() async {
    setState(() {
      isSubmitted = true;
    });

    if (productList.isNotEmpty) {
      final String supplier = suppliers
          .where((element) => element.toString() == controller.value)
          .first
          .clientId!;
      final Map<String, String> entryRes = await StockManagerController()
          .writeGrnMaster(
              supplierId: supplier,
              foc:
                  focController.text.trim().isEmpty ? "0" : focController.text);
      final pController = StockManagerController();

      await Future.wait(productList.map((productMap) async {
        ProductModel product = productMap['product'];
        await pController.writeGrnDetails(
            slno: productMap['count'].toString(),
            entryId: entryRes['BILLID']!,
            uomName: product.uom,
            uomId: product.uomId,
            productId: product.prodId!,
            cost: product.cost!,
            qty: productMap['qty'].toString());
      }));

      setState(() {
        count = 1;
        productList.clear();
        calculateTotal();
        isSubmitted = false;
        focController.clear();
      });
      // ignore: use_build_context_synchronously
      await _showMyDialog(context, "Entry Number", entryRes['grnNo']!);
    } else {
      showToast('empty list...');
      setState(() {
        calculateTotal();
        isSubmitted = false;
      });
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

Future<void> _showMyDialog(
    BuildContext context, String title, String content) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(title),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text(content),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('close'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
