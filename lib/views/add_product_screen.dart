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
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(children: [
        Row(
          children: [
            Expanded(
              child: CustomTextField(
                hintText: "Product",
                controller: productNameController,
              ),
            ),
            Expanded(
              child: MyBarcodeScanner(
                focusNode: barcodeFocus,
                controller: barcodeController,
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
                        return snapshot.hasData
                            ? MyDropdown(
                                list: snapshot.data!
                                    .map((supplier) => supplier.toString())
                                    .toList(),
                                controller: categoryController,
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
                hintText: "Retail Price",
                controller: retailPriceController,
              ),
            ),
            Expanded(
              child: CustomTextField(
                hintText: "Purchase price",
                controller: purchasePriceController,
              ),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.all(18.0),
          child: SizedBox(
            height: 60,
            width: double.infinity,
            child: GFButton(
              onPressed: () {
                ProductController controllerProduct = ProductController();
                controllerProduct
                    .isBarcodeExist(barcodeController.text)
                    .then((value) {
                  if (value) {
                    showToast('barcode already exist');
                  } else {
                    controllerProduct.createProduct(barcode: barcodeController.text, prodName: productNameController.text, catId: , brandId: brandId, uomId: uomId, uomName: uomName, purchasePrice: purchasePrice, retailPrice: retailPrice)
                  }
                });
              },
              text: "Submit",
              type: GFButtonType.solid,
              fullWidthButton: true,
              blockButton: true,
            ),
          ),
        ),
      ]),
    );
  }
}
