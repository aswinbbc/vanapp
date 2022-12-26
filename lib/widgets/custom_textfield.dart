import 'package:flutter/material.dart';

class CustomTextField extends StatefulWidget {
  const CustomTextField(
      {super.key,
      required this.hintText,
      this.controller,
      this.inputType,
      this.enabled = true,
      this.style});
  final String hintText;
  final TextEditingController? controller;
  final TextInputType? inputType;
  final bool enabled;
  final TextStyle? style;
  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  late final TextEditingController controller;
  @override
  void initState() {
    controller = widget.controller ?? TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 3),
      child: TextField(
        style: widget.style,
        enabled: widget.enabled,
        keyboardType: widget.inputType ?? TextInputType.name,
        controller: controller,
        decoration: InputDecoration(
          labelText: widget.hintText,
          border: const OutlineInputBorder(),
          hintText: widget.hintText,
        ),
      ),
    );
  }
}
