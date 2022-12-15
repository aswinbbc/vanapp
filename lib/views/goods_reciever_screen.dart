import 'package:flutter/material.dart';
import 'package:getwidget/components/button/gf_button.dart';
import 'package:getwidget/types/gf_button_type.dart';
import 'package:vanapp/controllers/supplier_controller.dart';
import 'package:vanapp/models/supplier_model.dart';
import 'package:vanapp/widgets/custom_textfield.dart';
import 'package:vanapp/widgets/my_barcode_scanner.dart';
import 'package:vanapp/widgets/my_data_table.dart';
import 'package:vanapp/widgets/my_dropdown.dart';

import '../controllers/product_controller.dart';
import '../models/product_model.dart';

class GoodsRecieverScreen extends StatefulWidget {
  const GoodsRecieverScreen({super.key});

  @override
  State<GoodsRecieverScreen> createState() => _GoodsRecieverScreenState();
}

class _GoodsRecieverScreenState extends State<GoodsRecieverScreen> {
  final TextEditingController barcodeController = TextEditingController();
  final TextEditingController productNameController = TextEditingController();
  final TextEditingController retailPriceController = TextEditingController();
  final TextEditingController qtyController = TextEditingController();
  bool isSearching = false;
  final MyDropController controller = MyDropController();
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
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView(
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
                      retailPriceController.text = value.retailPrice ?? "";
                      isSearching = false;
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
                        hintText: "Product name",
                        enabled: false,
                        controller: productNameController,
                      )),
                  Expanded(
                      child: CustomTextField(
                    hintText: "Price",
                    enabled: false,
                    controller: retailPriceController,
                  )),
                ],
              ),
              Row(
                children: [
                  Expanded(
                      child: CustomTextField(
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

                              qtyController.clear();
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
        Expanded(
            child: SingleChildScrollView(
                child: ProductDataTable(
          listOfColumns: productList,
          onRemove: (index) {
            setState(() {
              productList.removeAt(index);
            });
          },
        ))),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: SizedBox(
            height: 60,
            child: GFButton(
              onPressed: () async {
                final String supplier = suppliers
                    .where((element) => element.toString() == controller.value)
                    .first
                    .clientId!;
                final String entryId = await ProductController()
                    .writeGrnMaster(supplierId: supplier);
                print(entryId);
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
                print({
                  'completed',
                });
                setState(() {
                  productList.clear();
                });
              },
              text: "Submit",
              type: GFButtonType.solid,
              fullWidthButton: true,
              blockButton: true,
            ),
          ),
        ),
      ],
    );
  }
}
