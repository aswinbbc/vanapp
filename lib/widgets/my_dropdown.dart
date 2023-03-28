import 'package:flutter/material.dart';
import 'package:searchable_paginated_dropdown/searchable_paginated_dropdown.dart';

class MyDropdown extends StatefulWidget {
  const MyDropdown(
      {super.key,
      required this.list,
      required this.controller,
      this.onchange,
      this.hint});
  final List<String> list;
  final String? hint;
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

  setValue(String value) {
    if (value.isNotEmpty) {
      setState(() {
        controller.value = value;
        dropdownValue = value;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SearchableDropdown<String>(
      hintText: Text(widget.hint ?? ''),
      margin: const EdgeInsets.all(15),
      items: widget.list
          .map((e) => SearchableDropdownMenuItem<String>(
              value: e,
              label: e,
              child: Text(
                e,
                maxLines: 1,
                overflow: TextOverflow.fade,
              )))
          .toList(),
      onChanged: (String? value) {
        setValue(value ?? '');
        widget.onchange != null ? widget.onchange!(value) : null;
      },
    );
    return DropdownButtonFormField<String>(
        isExpanded: true,
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

          setState(() {
            dropdownValue = value!;
            controller.value = value;
            widget.onchange != null ? widget.onchange!(value) : null;
          });
        },
        items: widget.list.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(
              value,
              maxLines: 1,
              overflow: TextOverflow.fade,
            ),
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
