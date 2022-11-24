import 'package:flutter/material.dart';
import 'package:vanapp/utils/constants/utils.dart';

import '../utils/constants/constant.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final ipController = TextEditingController();

  @override
  initState() {
    super.initState();
    Constants.ip.then((value) => setState((() => ipController.text = value)));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(children: [
            Expanded(
                child: TextField(
              decoration:
                  const InputDecoration(hintText: "Enter server IP here"),
              controller: ipController,
            )),
            ElevatedButton(
                onPressed: () {
                  Constants()
                      .setIp(ipController.text)
                      .then((value) => showToast("ip saved, please restart"));
                },
                child: const Text('Save')),
          ]),
        ),
      ],
    );
  }
}
