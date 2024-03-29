import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

class MyBarcodeScanner extends StatefulWidget {
  const MyBarcodeScanner(
      {super.key, this.onBarcode, this.controller, this.focusNode});
  final Function(String)? onBarcode;
  final FocusNode? focusNode;
  final TextEditingController? controller;
  @override
  State<MyBarcodeScanner> createState() => _MyBarcodeScannerState();
}

class _MyBarcodeScannerState extends State<MyBarcodeScanner> {
  late final TextEditingController controller;
  late final Function(String) onBarcode;
  @override
  void initState() {
    controller = widget.controller ?? TextEditingController();
    onBarcode = widget.onBarcode ?? (text) {};
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Expanded(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
          child: RawKeyboardListener(
            focusNode: widget.focusNode ?? FocusNode(),
            onKey: (event) {
              if (event.isKeyPressed(LogicalKeyboardKey.enter)) {
                onBarcode(controller.text);
              }
            },
            child: TextField(
              onSubmitted: onBarcode,
              controller: controller,
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                hintText: "Barcode",
                suffixIcon: InkWell(
                    onTap: getBarcode,
                    child: const Icon(Icons.qr_code_scanner_outlined)),
              ),
            ),
          ),
        ),
      )
    ]);
  }

  getBarcode() async {
    controller.text = await FlutterBarcodeScanner.scanBarcode(
        "#ff6666", "Cancel", false, ScanMode.BARCODE);
    onBarcode(controller.text);
  }
}
