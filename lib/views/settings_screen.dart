import 'package:flutter/material.dart';
import 'package:getwidget/components/button/gf_button.dart';
import 'package:vanapp/controllers/employee_controller.dart';
import 'package:vanapp/models/employee_model.dart';
import 'package:vanapp/utils/constants/utils.dart';
import 'package:vanapp/widgets/my_dropdown.dart';

import '../utils/constants/constant.dart';
import '../widgets/custom_textfield.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});
  String get title => 'Settings';
  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final ipController = TextEditingController();
  final portController = TextEditingController();

  @override
  initState() {
    super.initState();
    Constants.ip.then((value) => setState((() => ipController.text = value)));
    Constants.port
        .then((value) => setState((() => portController.text = value)));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(children: [
            Text("IP:"),
            Expanded(
                flex: 2,
                child: CustomTextField(
                  hintText: "Enter server IP here",
                  controller: ipController,
                )),
            Text(" PORT:"),
            Expanded(
                child: CustomTextField(
              hintText: "eg:- 90",
              controller: portController,
            )),
          ]),
        ),
        GFButton(
            blockButton: true,
            onPressed: () async {
              await Constants().setPORT(portController.text);
              Constants()
                  .setIp(ipController.text)
                  .then((value) => showToast("saved, please restart"));
            },
            child: const Text('Save')),
      ],
    );
  }
}
