import 'package:flutter/material.dart';
import 'package:getwidget/components/button/gf_button.dart';
import 'package:getwidget/types/gf_button_type.dart';
import 'package:vanapp/controllers/product_controller.dart';
import 'package:vanapp/models/brand_model.dart';
import 'package:vanapp/models/category_model.dart';
import 'package:vanapp/models/uom_model.dart';
import 'package:vanapp/utils/constants/utils.dart';
import 'package:vanapp/widgets/custom_textfield.dart';
import 'package:vanapp/widgets/my_barcode_scanner.dart';
import 'package:vanapp/widgets/my_dropdown.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key});
  String get title => 'Add new product';
  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final MyDropController categoryController = MyDropController();
  final MyDropController brandController = MyDropController();
  final MyDropController uomController = MyDropController();
  final TextEditingController barcodeController = TextEditingController();
  final TextEditingController productNameController = TextEditingController();
  final TextEditingController retailPriceController = TextEditingController();
  final TextEditingController purchasePriceController = TextEditingController();
  final TextEditingController uomNameController = TextEditingController();

  List<CategoryModel> categories = [];
  List<UOMModel> uoms = [];
  List<BrandModel> brands = [];

  FocusNode barcodeFocus = FocusNode();
  FocusNode retailFocus = FocusNode();
  bool isSubmitted = false;
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(children: [
        Row(
          children: [
            Visibility(
              visible: isSubmitted,
              child: const LinearProgressIndicator(),
            ),
            Expanded(
              child: MyBarcodeScanner(
                focusNode: barcodeFocus,
                controller: barcodeController,
              ),
            ),
            Expanded(
              child: CustomTextField(
                hintText: "Product",
                controller: productNameController,
              ),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Row(
            children: [
              const Expanded(child: Text("Category")),
              const Text(" : "),
              Expanded(
                  flex: 3,
                  child: FutureBuilder(
                      future: ProductController().getCategories(),
                      builder: (context,
                          AsyncSnapshot<List<CategoryModel>> snapshot) {
                        if (snapshot.hasData) {
                          categories = snapshot.data!;
                        }
                        if (snapshot.hasData) {
                          return MyDropdown(
                            list: snapshot.data!
                                .map((supplier) => supplier.toString())
                                .toList(),
                            controller: categoryController,
                          );
                        } else {
                          return const Text("waiting.....");
                        }
                      })),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Row(
            children: [
              const Expanded(child: Text("Brand")),
              const Text(" : "),
              Expanded(
                  flex: 3,
                  child: FutureBuilder(
                      future: ProductController().getbrands(),
                      builder:
                          (context, AsyncSnapshot<List<BrandModel>> snapshot) {
                        if (snapshot.hasData) {
                          brands = snapshot.data!;
                        }
                        return snapshot.hasData
                            ? MyDropdown(
                                list: snapshot.data!
                                    .map((brand) => brand.toString())
                                    .toList(),
                                controller: brandController,
                              )
                            : const Text("waiting.....");
                      })),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Row(
            children: [
              const Expanded(child: Text("UOM")),
              const Text(" : "),
              Expanded(
                  flex: 3,
                  child: FutureBuilder(
                      future: ProductController().getUOMs(),
                      builder:
                          (context, AsyncSnapshot<List<UOMModel>> snapshot) {
                        if (snapshot.hasData) {
                          uoms = snapshot.data!;
                        }
                        return snapshot.hasData
                            ? MyDropdown(
                                list: snapshot.data!
                                    .map((uom) => uom.toString())
                                    .toList(),
                                controller: uomController,
                              )
                            : const Text("waiting.....");
                      })),
            ],
          ),
        ),
        Row(
          children: [
            Expanded(
              child: CustomTextField(
                hintText: "opening cost",
                focusNode: retailFocus,
                controller: purchasePriceController,
              ),
            ),
            Expanded(
              child: CustomTextField(
                hintText: "Retail Price",
                controller: retailPriceController,
              ),
            ),
          ],
        ),
        Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(18.0),
                child: SizedBox(
                  height: 60,
                  width: double.infinity,
                  child: GFButton(
                    onPressed: clear,
                    text: "clear",
                    type: GFButtonType.transparent,
                    fullWidthButton: true,
                    blockButton: true,
                  ),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(18.0),
                child: SizedBox(
                  height: 60,
                  width: double.infinity,
                  child: GFButton(
                    onPressed: !isSubmitted ? submit : null,
                    text: "Submit",
                    type: GFButtonType.solid,
                    fullWidthButton: true,
                    blockButton: true,
                  ),
                ),
              ),
            ),
          ],
        ),
      ]),
    );
  }

  void submit() {
    setState(() {
      isSubmitted = true;
    });
    var purchasePrice = purchasePriceController.text.isEmpty
        ? '0'
        : purchasePriceController.text;
    var retailPrice =
        retailPriceController.text.isEmpty ? '0' : retailPriceController.text;

    if (barcodeController.text.isEmpty) {
      showToast('barcode is empty..');
      barcodeFocus.requestFocus();
      return;
    }
    try {
      if (int.parse(purchasePrice) > int.parse(retailPrice)) {
        showToast('retail price must be greater');
        return;
      }
    } catch (e) {
      showToast('not a valid price');
      return;
    }

    ProductController controllerProduct = ProductController();
    controllerProduct
        .isBarcodeExist(barcodeController.text)
        .then((value) async {
      if (value) {
        showToast('barcode already exist');
      } else {
        if (purchasePriceController.text.isEmpty) {
          showToast('purchase price must not be empty');

          return;
        }
        if (retailPriceController.text.isEmpty) {
          showToast('retail price must not be empty');

          return;
        }
        String catId = categories
            .where((element) => element.toString() == categoryController.value)
            .first
            .ctId!;
        String brandId = brands
            .where((element) => element.toString() == brandController.value)
            .first
            .brandId!;
        String uomId = uoms
            .where((element) => element.toString() == uomController.value)
            .first
            .uomId!;
        await controllerProduct.createProduct(
            barcode: barcodeController.text,
            prodName: productNameController.text,
            catId: catId,
            brandId: brandId,
            uomId: uomId,
            uomName: uomController.value,
            purchasePrice: purchasePrice,
            retailPrice: retailPrice);
        showToast('inserted');
        clear();
      }
    });
  }

  void clear() {
    setState(() {
      isSubmitted = false;
    });
    barcodeController.clear();
    retailPriceController.clear();
    purchasePriceController.clear();
    productNameController.clear();
    categoryController.value = categories.first.toString();
    uomController.value = "PCS";
    brandController.value = brands.first.toString();
    barcodeFocus.requestFocus();
  }
}
