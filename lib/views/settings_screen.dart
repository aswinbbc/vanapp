import 'package:flutter/material.dart';
import 'package:getwidget/components/button/gf_button.dart';
import 'package:vanapp/controllers/company_controller.dart';
import 'package:vanapp/models/branch_model.dart';
import 'package:vanapp/models/supplier_model.dart';
import 'package:vanapp/utils/constants/utils.dart';
import 'package:vanapp/utils/extension.dart';
import 'package:vanapp/widgets/my_dropdown.dart';

import '../utils/constants/constant.dart';
import '../widgets/custom_textfield.dart';

import 'package:device_info_plus/device_info_plus.dart';

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
  List<Branch> branches = [];
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
    loadBranches();
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
        GFButton(
            blockButton: true,
            onPressed: () async {
              ;
              await Constants().setPORT(portController.text);

              Constants()
                  .setIp(ipController.text)
                  .then((value) => showToast("saved, please restart"));
            },
            child: const Text('Save IP')),
        Divider(),
        SizedBox(height: 20),
        Row(
          children: [
            const Text("Select Branch: "),
            const SizedBox(
              width: 10,
            ),
            FutureBuilder(
                future: CompanyController().getBranches(),
                builder: (context, AsyncSnapshot<List<Branch>> snapshot) {
                  if (snapshot.hasData) {
                    branches = snapshot.data!;
                  }
                  return snapshot.hasData
                      ? Flexible(
                          child: MyDropdown(
                            initValue: currentBranch,
                            list: snapshot.data!
                                .map((branch) => branch.branchName.toString())
                                .toList(),
                            controller: controller,
                            onchange: (name) async {
                              if (name!.trim().isEmpty) {
                                showToast('Please choose Branch...');
                              }
                              await Constants().setBranch(name);

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
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: CustomTextField(
            hintText: "Enter system name",
            controller: systemNameController,
          ),
        ),
        GFButton(
            blockButton: true,
            onPressed: () async {
              if (systemNameController.text.isNotEmpty &&
                  branchid.trim().isNotEmpty) {
                showToast('wait..');
                print(systemNameController.text + branchid);
                await Constants().setSystemName(systemNameController.text);
                CompanyController().deviceRegistation(
                    deviceName: systemNameController.text, branchId: branchid);
                showToast('saved successfully..');
              } else {
                showToast('Please fill branch/system name...');
              }
            },
            child: const Text('Register')),
        Divider(),
        Spacer(),
        Spacer()
      ],
    );
  }

  late String branchid;
  loadBranches() {
    Constants.branch.then((value) {
      setState(() {
        currentBranch = value;
      });
      branchid = branches
              .where((element) => element.branchName == controller.value)
              .first
              .branchId ??
          '';
    });
  }
}
