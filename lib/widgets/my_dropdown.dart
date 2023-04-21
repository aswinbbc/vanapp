import 'package:flutter/material.dart';
import 'package:searchable_paginated_dropdown/searchable_paginated_dropdown.dart';

class MyDropdown extends StatefulWidget {
  const MyDropdown(
      {super.key,
      required this.list,
      required this.controller,
      this.onchange,
      this.hint,
      this.initValue,
      this.horizontalMargin,
      this.verticalMargin});
  final List<String> list;
  final String? hint;
  final double? horizontalMargin, verticalMargin;
  final MyDropController controller;
  final String? initValue;
  final Function(String?)? onchange;

  @override
  State<MyDropdown> createState() => _MyDropdownState();
}

class _MyDropdownState extends State<MyDropdown> {
  late String dropdownValue;
  late MyDropController controller;
  @override
  void initState() {
    dropdownValue = widget.initValue ?? widget.list.first;
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
      margin: EdgeInsets.symmetric(
          horizontal: widget.horizontalMargin ?? 15,
          vertical: widget.verticalMargin ?? 15),
      value: controller.value,
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
