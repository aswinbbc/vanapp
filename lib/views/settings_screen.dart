import 'package:flutter/material.dart';
import 'package:getwidget/components/button/gf_button.dart';
import 'package:vanapp/controllers/company_controller.dart';
import 'package:vanapp/models/supplier_model.dart';
import 'package:vanapp/utils/constants/utils.dart';
import 'package:vanapp/utils/extension.dart';
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
  final systemNameController = TextEditingController();
  final portController = TextEditingController();
  List<Supplier> branches = [];
  final controller = MyDropController();
  String currentBranch = '';

  @override
  initState() {
    super.initState();
    Constants.ip.then((value) => setState((() => ipController.text = value)));
    Constants.systemName
        .then((value) => setState((() => systemNameController.text = value)));
    Constants.port
        .then((value) => setState((() => portController.text = value)));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(children: [
            const Text("IP:"),
            Expanded(
                flex: 2,
                child: CustomTextField(
                  hintText: "Enter server IP here",
                  controller: ipController,
                )),
            const Text(" PORT:"),
            Expanded(
                child: CustomTextField(
              hintText: "eg:- 90",
              controller: portController,
            )),
          ]),
        ),
        Row(
          children: [
            const Text("Select Branch: "),
            const SizedBox(
              width: 10,
            ),
            FutureBuilder(
                future: CompanyController().getBranches(),
                builder: (context, AsyncSnapshot<List<Supplier>> snapshot) {
                  if (snapshot.hasData) {
                    branches = snapshot.data!;
                  }
                  return snapshot.hasData
                      ? Flexible(
                          child: MyDropdown(
                            initValue: currentBranch,
                            list: snapshot.data!
                                .map((employee) => employee.toString())
                                .toList(),
                            controller: controller,
                            onchange: (name) async {
                              if (name!.trim().isEmpty) {
                                showToast('Please choose Employee...');
                              }
                              await Constants().setEmployeeName(name);
                              String branch = branches
                                      .where((element) =>
                                          element.toString() ==
                                          controller.value)
                                      .first
                                      .groupId ??
                                  '';
                              await Constants().setBranch(branch);
                              loadBranches();
                            },
                          ),
                        )
                      : const Text("waiting.....");
                }),
          ],
        ).withBorder(
          horizontalMargin: 8,
          horizontalPadding: 5,
        ),
        Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: CustomTextField(
                hintText: "Enter system name",
                controller: systemNameController,
              ),
            )),
        GFButton(
            blockButton: true,
            onPressed: () async {
              await Constants().setPORT(portController.text);
              await Constants().setSystemName(systemNameController.text);
              Constants()
                  .setIp(ipController.text)
                  .then((value) => showToast("saved, please restart"));
            },
            child: const Text('Save')),
      ],
    );
  }

  loadBranches() {
    Constants.employeeName.then((value) {
      setState(() {
        currentBranch = value;
      });
    });
  }
}
