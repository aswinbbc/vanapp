import 'package:flutter/material.dart';

class MyDropdown extends StatefulWidget {
  const MyDropdown(
      {super.key, required this.list, required this.controller, this.onchange});
  final List<String> list;
  final MyDropController controller;
  final Function(String?)? onchange;

  @override
  State<MyDropdown> createState() => _MyDropdownState();
}

class _MyDropdownState extends State<MyDropdown> {
  late String dropdownValue;
  late MyDropController controller;
  @override
  void initState() {
    dropdownValue = widget.list.first;
    controller = widget.controller;
    controller.value = dropdownValue;
    widget.onchange != null ? widget.onchange!(dropdownValue) : null;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
        value: dropdownValue,
        icon: const Icon(Icons.arrow_downward),
        elevation: 16,
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          filled: true,
          fillColor: Colors.transparent,
        ),
        onChanged: (String? value) {
          // This is called when the user selects an item.
          widget.onchange != null ? widget.onchange!(value) : null;
          setState(() {
            dropdownValue = value!;
            controller.value = value;
          });
        },
        items: widget.list.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList());
  }
}

class MyDropController extends ChangeNotifier {
  String _value = "";

  set value(String value) {
    _value = value;
    notifyListeners();
  }

  String get value => _value;
}
