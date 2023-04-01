import 'package:flutter/material.dart';

class ProductDataTable extends StatefulWidget {
  const ProductDataTable(
      {super.key,
      required this.listOfColumns,
      required this.onRemove,
      this.showCount = false});
  final List<Map<String, dynamic>> listOfColumns;
  final Function(int) onRemove;
  final bool showCount;
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
          border: TableBorder.symmetric(
              // inside: const BorderSide(width: 2.0),
              // outside: const BorderSide(width: 1.0),
              ),
          columnSpacing: 1,
          columns: [
            if (widget.showCount)
              const DataColumn(
                  label: Expanded(flex: 1, child: Center(child: Text('#')))),
            const DataColumn(label: Expanded(flex: 4, child: Text('Product'))),
            const DataColumn(
                label: Expanded(flex: 1, child: Center(child: Text('Qty')))),
            const DataColumn(
                label: Expanded(flex: 1, child: Center(child: Text('Cost')))),
            const DataColumn(
                label: Expanded(flex: 2, child: Center(child: Text('total')))),
          ],
          rows:
              listOfColumns // Loops through dataColumnText, each iteration assigning the value to element
                  .map(
                    ((map) => DataRow(
                          cells: <DataCell>[
                            if (widget.showCount)
                              DataCell(
                                  Center(child: Text(map['count'].toString()))),
                            DataCell(Text(map['product']
                                .productName!)), //Extracting from Map element the value
                            DataCell(
                                Center(child: Text(map['qty'].toString()))),
                            DataCell(Center(child: Text(map['product'].cost!))),
                            DataCell(Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Text((double.parse(map['product'].cost!) *
                                        map['qty'])
                                    .toStringAsFixed(2)),
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
