import 'package:flutter/material.dart';

class ProductDataTable extends StatefulWidget {
  const ProductDataTable(
      {super.key, required this.listOfColumns, required this.onRemove});
  final List<Map<String, dynamic>> listOfColumns;
  final Function(int) onRemove;
  @override
  State<ProductDataTable> createState() => _ProductDataTableState();
}

class _ProductDataTableState extends State<ProductDataTable> {
  @override
  void initState() {
    super.initState();
    listOfColumns = widget.listOfColumns;
  }

  late List<Map<String, dynamic>> listOfColumns;

//  DataTableWidget(this.listOfColumns);     // Getting the data from outside, on initialization
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SizedBox(
        width: (MediaQuery.of(context).size.width - 5),
        child: DataTable(
          columnSpacing: 1,
          columns: const [
            DataColumn(label: Expanded(flex: 4, child: Text('Product'))),
            DataColumn(label: Expanded(flex: 1, child: Text('Qty'))),
            DataColumn(label: Expanded(flex: 1, child: Text('Cost'))),
            DataColumn(label: Expanded(flex: 1, child: Text('total'))),
          ],
          rows:
              listOfColumns // Loops through dataColumnText, each iteration assigning the value to element
                  .map(
                    ((map) => DataRow(
                          cells: <DataCell>[
                            DataCell(Text(map['product']
                                .productName!)), //Extracting from Map element the value
                            DataCell(Text(map['qty'].toString())),
                            DataCell(Text(map['product'].cost!)),
                            DataCell(Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text((double.parse(map['product'].cost!) *
                                        map['qty'])
                                    .toString()),
                                InkWell(
                                  child: const Icon(Icons.close),
                                  onTap: () {
                                    widget.onRemove(listOfColumns.indexOf(map));
                                  },
                                )
                              ],
                            )),
                          ],
                        )),
                  )
                  .toList(),
        ),
      ),
    );
  }
}