import 'package:flutter/material.dart';
import 'package:vanapp/controllers/product_controller.dart';
import 'package:vanapp/controllers/supplier_controller.dart';
import 'package:vanapp/models/credit_purchase_invoice_model.dart';
import 'package:vanapp/models/supplier_model.dart';
import 'package:vanapp/views/purchase_return/add_purchase_return_screen.dart';
import 'package:vanapp/widgets/my_dropdown.dart';
import 'package:vanapp/views/purchase_return/widgets/purchase_invoice_table.dart';

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
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 1.0),
          child: Row(
            children: [
              const Expanded(child: Text("Supplier")),
              const Text(" : "),
              Expanded(
                flex: 2,
                child: FutureBuilder(
                  future: SupplierController().getSuppliers(),
                  builder: (context, AsyncSnapshot<List<Supplier>> snapshot) {
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
              value: groups[1],
              title: Text(groups[1]),
              onChanged: (String? value) {
                currentGroupIndex = 1;
                navigateToAddPage(context);
              },
            )),
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
          ],
        ),
        Expanded(
          child: SingleChildScrollView(
              child: PurchaseInvoiceTable(
            list: list,
            onClick: (index) {
              navigateToAddPage(
                  context, list[index].billId, list[index].billType);
            },
          )),
        ),
      ],
    );
  }

  navigateToAddPage(BuildContext context,
      [String? purchaseId, String? purchaseType]) async {
    final String supplierId = suppliers
        .where((element) => element.toString() == controller.value)
        .first
        .clientId!;
    await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AddPurchaseReturnScreen(
              supplierId: supplierId,
              paymentMode: groups[currentGroupIndex],
              purchaseId: purchaseId,
              purchaseType: purchaseType),
        ));
    currentGroupIndex = 0;
  }

  getInvoiceData() async {
    final String supplier = suppliers
        .where((element) => element.toString() == controller.value)
        .first
        .clientId!;
    StockManagerController()
        .getCreditPurchaseinvoices(clientId: supplier)
        .then((value) {
      setState(() {
        list = value;
      });
    });
  }
}
