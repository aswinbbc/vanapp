// import 'package:barcode_validator/barcode_validator.dart';
import 'package:flutter/material.dart';
import 'package:vanapp/controllers/product_controller.dart';
import 'package:vanapp/widgets/custom_textfield.dart';
import 'package:vanapp/widgets/my_barcode_scanner.dart';

class ViewScannedProductScreen extends StatefulWidget {
  const ViewScannedProductScreen({super.key});

  @override
  State<ViewScannedProductScreen> createState() =>
      _ViewScannedProductScreenState();
}

class _ViewScannedProductScreenState extends State<ViewScannedProductScreen> {
  final TextEditingController barcodeController = TextEditingController();
  final TextEditingController barcodeViewController = TextEditingController();
  final TextEditingController productNameController = TextEditingController();
  final TextEditingController retailPriceController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController stockController = TextEditingController();
  final TextEditingController uomController = TextEditingController();
  bool isSearching = false;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(children: [
        Visibility(
            visible: isSearching, child: const LinearProgressIndicator()),
        Row(
          children: [
            Expanded(
              flex: 2,
              child: MyBarcodeScanner(
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
                      productNameController.text = value.productName ?? "";
                      uomController.text = value.uom ?? "";
                      retailPriceController.text = value.retailPrice ?? "";
                      stockController.text = value.stock ?? "";
                      descriptionController.text = value.prodCode ?? "";
                      barcodeViewController.text = value.barcode ?? '';
                      isSearching = false;
                      if ((value.prodId ?? '').isNotEmpty) {
                        barcodeController.text = '';
                      }
                      // value.prodId != null ? FocusScope.of(context).unfocus() : null;
                    });
                  });
                  // }
                },
              ),
            ),
            Expanded(
                child: CustomTextField(
              enabled: false,
              hintText: "UOM",
              controller: uomController,
            )),
          ],
        ),
        Row(
          children: [
            const Expanded(child: Text("Barcode")),
            const Text(":"),
            Expanded(
              flex: 2,
              child: CustomTextField(
                hintText: "Barcode",
                enabled: false,
                controller: barcodeViewController,
              ),
            ),
          ],
        ),
        Row(
          children: [
            const Expanded(child: Text("Product")),
            const Text(":"),
            Expanded(
              flex: 2,
              child: CustomTextField(
                hintText: "Product",
                enabled: false,
                controller: productNameController,
              ),
            ),
          ],
        ),
        Row(
          children: [
            const Expanded(child: Text("Description")),
            const Text(":"),
            Expanded(
              flex: 2,
              child: CustomTextField(
                hintText: "Description",
                enabled: false,
                controller: descriptionController,
              ),
            ),
          ],
        ),
        Row(
          children: [
            const Expanded(child: Text("Retail Price")),
            const Text(":"),
            Expanded(
              flex: 2,
              child: CustomTextField(
                hintText: "Retail Price",
                enabled: false,
                controller: retailPriceController,
              ),
            ),
          ],
        ),
        Row(
          children: [
            const Expanded(child: Text("Stock")),
            const Text(":"),
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
          ],
        ),
      ]),
    );
  }
}
