import 'package:flutter/material.dart';
import 'package:vanapp/models/credit_purchase_invoice_model.dart';

class PurchaseInvoiceTable extends StatefulWidget {
  const PurchaseInvoiceTable(
      {super.key, required this.list, required this.onClick});
  final List<CreditPurchaseinvoice> list;
  final Function(int) onClick;
  @override
  State<PurchaseInvoiceTable> createState() => _PurchaseInvoiceTableState();
}

class _PurchaseInvoiceTableState extends State<PurchaseInvoiceTable> {
//  DataTableWidget(this.listOfColumns);     // Getting the data from outside, on initialization
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SizedBox(
        width: (MediaQuery.of(context).size.width - 5),
        child: DataTable(
          border: TableBorder.symmetric(
              // inside: const BorderSide(width: 2.0),
              // outside: const BorderSide(width: 1.0),
              ),
          columnSpacing: 1,
          columns: const [
            DataColumn(label: Expanded(flex: 4, child: Text('Bill No'))),
            DataColumn(
                label:
                    Expanded(flex: 1, child: Center(child: Text('Balance')))),
            DataColumn(
                label:
                    Expanded(flex: 1, child: Center(child: Text('Bill Date')))),
            DataColumn(
                label: Expanded(flex: 1, child: Center(child: Text('Return')))),
          ],
          rows: widget
              .list // Loops through dataColumnText, each iteration assigning the value to element
              .map(
                ((creditPurchaseinvoice) => DataRow(
                      cells: <DataCell>[
                        DataCell(Text(creditPurchaseinvoice
                            .billId!)), //Extracting from Map element the value
                        DataCell(Center(
                            child: Text(
                                creditPurchaseinvoice.balance.toString()))),
                        DataCell(Center(
                            child: Text(
                                creditPurchaseinvoice.billDate.toString()))),
                        DataCell(
                          Center(
                            child: IconButton(
                                icon: const Icon(
                                    Icons.arrow_circle_right_outlined),
                                onPressed: (() => widget.onClick(
                                      widget.list
                                          .indexOf(creditPurchaseinvoice),
                                    ))),
                          ),
                        ),
                      ],
                    )),
              )
              .toList(),
        ),
      ),
    );
  }
}
