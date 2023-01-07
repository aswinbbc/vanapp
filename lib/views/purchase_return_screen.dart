import 'package:flutter/material.dart';
import 'package:getwidget/components/button/gf_button.dart';
import 'package:getwidget/types/gf_button_type.dart';
import 'package:vanapp/controllers/product_controller.dart';
import 'package:vanapp/controllers/supplier_controller.dart';
import 'package:vanapp/models/credit_purchase_invoice_model.dart';
import 'package:vanapp/models/supplier_model.dart';
import 'package:vanapp/widgets/my_dropdown.dart';
import 'package:vanapp/widgets/purchase_invoice_table.dart';

class PurchaseReturnScreen extends StatefulWidget {
  const PurchaseReturnScreen({super.key});
  String get title => 'Purchase Return';
  @override
  State<PurchaseReturnScreen> createState() => _PurchaseReturnScreenState();
}

class _PurchaseReturnScreenState extends State<PurchaseReturnScreen> {
  bool isSearching = false;
  final MyDropController controller = MyDropController();

  List<Supplier> suppliers = [];
  List<CreditPurchaseinvoice> list = [];
  List<String> groups = ['On Credit', 'Cash'];
  int currentGroupIndex = 0;

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
                        builder:
                            (context, AsyncSnapshot<List<Supplier>> snapshot) {
                          if (snapshot.hasData) {
                            suppliers = snapshot.data!;
                          }
                          if (snapshot.hasData) {
                            return MyDropdown(
                              list: snapshot.data!
                                  .map((supplier) => supplier.toString())
                                  .toList(),
                              controller: controller,
                              onchange: (p0) => getInvoiceData(),
                            );
                          } else {
                            return const Text("waiting.....");
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  Expanded(
                      child: RadioListTile(
                    groupValue: groups[currentGroupIndex],
                    value: groups[0],
                    title: Text(groups[0]),
                    onChanged: (String? value) {
                      setState(() {
                        currentGroupIndex = 0;
                      });
                    },
                  )),
                  Expanded(
                      child: RadioListTile(
                    groupValue: groups[currentGroupIndex],
                    value: groups[1],
                    title: Text(groups[1]),
                    onChanged: (String? value) {
                      setState(() {
                        currentGroupIndex = 1;
                      });
                    },
                  )),
                ],
              ),
              SingleChildScrollView(
                  child: PurchaseInvoiceTable(
                list: list,
                onClick: (index) {
                  print(list[index].vendorNo);
                  //select
                },
              )),
            ],
          ),
        ),
        Visibility(
          visible: isTableVisible,
          child: Placeholder(),
        ),
        // Align(
        //   alignment: Alignment.bottomLeft,
        //   child: Padding(
        //     padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 5),
        //     child: SizedBox(
        //       height: 60,
        //       width: 220,
        //       child: GFButton(
        //         onPressed: () {},
        //         text: "Submit",
        //         type: GFButtonType.solid,
        //         fullWidthButton: true,
        //         blockButton: true,
        //       ),
        //     ),
        //   ),
        // ),
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

  getInvoiceData() async {
    final String supplier = suppliers
        .where((element) => element.toString() == controller.value)
        .first
        .clientId!;
    list =
        await ProductController().getCreditPurchaseinvoices(clientId: supplier);

    setState(() {});
  }
}
