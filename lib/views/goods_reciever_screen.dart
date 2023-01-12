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
  bool isSearching = false;
  final MyDropController controller = MyDropController();
  var focusNode = FocusNode();
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
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
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
                  ProductController()
                      .getProductByBarcode(barcode)
                      .then((value) {
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
                                  'qty': double.parse(qtyController.text.isEmpty
                                      ? "1"
                                      : qtyController.text)
                                });
                              }
                              barcodeController.clear();
                              productNameController.clear();
                              retailPriceController.clear();
                              barcodeViewController.clear();
                              stockController.clear();
                              priceController.clear();
                              unitController.clear();
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
                onPressed: submitGRN,
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
    if (productList.isNotEmpty) {
      final String supplier = suppliers
          .where((element) => element.toString() == controller.value)
          .first
          .clientId!;
      final String entryId =
          await ProductController().writeGrnMaster(supplierId: supplier);
      final pController = ProductController();

      await Future.wait(productList.map((productMap) async {
        ProductModel product = productMap['product'];
        await pController.writeGrnDetails(
            entryId: entryId,
            uomName: product.uom,
            uomId: product.uomId,
            productId: product.prodId!,
            cost: product.cost!,
            qty: productMap['qty'].toString());
      }));
      setState(() {
        productList.clear();
      });
    } else {
      showToast('empty list...');
    }
  }
}
