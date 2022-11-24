import 'package:flutter/material.dart';
import 'package:getwidget/components/button/gf_button.dart';
import 'package:getwidget/types/gf_button_type.dart';
import 'package:vanapp/widgets/custom_textfield.dart';
import 'package:vanapp/widgets/my_barcode_scanner.dart';
import 'package:vanapp/widgets/my_data_table.dart';

import '../controllers/product_controller.dart';
import '../models/product_model.dart';

class WriteStockScreen extends StatefulWidget {
  const WriteStockScreen({super.key});

  @override
  State<WriteStockScreen> createState() => _WriteStockScreenState();
}

class _WriteStockScreenState extends State<WriteStockScreen> {
  final TextEditingController barcodeController = TextEditingController();
  final TextEditingController productNameController = TextEditingController();
  final TextEditingController retailPriceController = TextEditingController();
  final TextEditingController qtyController = TextEditingController();
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
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        MyBarcodeScanner(
          controller: barcodeController,
          onBarcode: (barcode) {
            // if (isValidBarcode(barcode)) {
            setState(() {
              isSearching = true;
            });
            ProductController().getProductByBarcode(barcode).then((value) {
              setState(() {
                productNameController.text = value.productName ?? "";
                retailPriceController.text = value.retailPrice ?? "";
                isSearching = false;
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
                        productList.add({
                          'product': ProductModel(
                            barcode: barcodeController.text,
                            productName: productNameController.text,
                            cost: retailPriceController.text,
                          ),
                          'qty': int.parse(qtyController.text.isEmpty
                              ? "1"
                              : qtyController.text)
                        });
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
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: SizedBox(
            height: 60,
            child: GFButton(
              onPressed: () async {
                final String entryId =
                    await ProductController().writeStockTakenMaster();
                productList.map((productMap) async {
                  print('adding');
                  ProductModel product = productMap['product'];
                  await ProductController().writeStockTakenDetails(
                      entryId: entryId,
                      productId: product.prodId!,
                      cost: product.cost!,
                      qty: productMap['qty']);
                });
                print('completed');
                productList.clear();
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
