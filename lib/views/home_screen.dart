import 'package:flutter/material.dart';
import 'package:vanapp/controllers/employee_controller.dart';
import 'package:vanapp/models/employee_model.dart';
import 'package:vanapp/utils/constants/constant.dart';
import 'package:vanapp/utils/constants/utils.dart';
import 'package:vanapp/views/add_product_screen.dart';
import 'package:vanapp/views/goods_reciever_screen.dart';
import 'package:vanapp/views/purchase_return/purchase_return_screen.dart';
import 'package:vanapp/views/settings_screen.dart';
import 'package:vanapp/views/view_scanned_product_screen.dart';
import 'package:vanapp/views/write_stock_taken_screen.dart';
import 'package:vanapp/widgets/my_dropdown.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final List screens = [
    const ViewScannedProductScreen(),
    const AddProductScreen(),
    const GoodsRecieverScreen(),
    const WriteStockScreen(),
    const PurchaseReturnScreen(),
    const SettingsScreen(),
  ];
  int currentIndex = 0;
  closeDrawer() {
    if (_scaffoldKey.currentState!.isDrawerOpen) {
      _scaffoldKey.currentState!.openEndDrawer();
    }
  }

  final controller = MyDropController();
  List<EmployeeModel> employees = [];
  String empname = '';
  @override
  void initState() {
    loadEmployee();
    // Constants.employeeId.then((value) {
    //   print({'@vv': value});
    //   if (value.trim().isEmpty) {
    //     setState(() {
    //       currentIndex = -1;
    //     });
    //   }
    // });
    super.initState();
  }

  loadEmployee() {
    Constants.employeeName.then((value) {
      setState(() {
        empname = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        toolbarHeight: 40,
        actions: [
          Center(child: Text('Employee: $empname')),
          SizedBox(
            width: 2,
          )
        ],
        centerTitle: true,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            ListTile(
              title: Row(
                children: [
                  Text("Select Employee: "),
                  FutureBuilder(
                      future: EmployeeController().getEmployees(),
                      builder: (context,
                          AsyncSnapshot<List<EmployeeModel>> snapshot) {
                        if (snapshot.hasData) {
                          employees = snapshot.data!;
                        }
                        return snapshot.hasData
                            ? Flexible(
                                child: MyDropdown(
                                  list: snapshot.data!
                                      .map((employee) => employee.toString())
                                      .toList(),
                                  controller: controller,
                                  onchange: (name) async {
                                    if (name!.trim().isEmpty) {
                                      showToast('Please choose Employee...');
                                    }
                                    await Constants()
                                        .setEmployeeName(name ?? '');
                                    String empId = employees
                                            .where((element) =>
                                                element.toString() ==
                                                controller.value)
                                            .first
                                            .empId ??
                                        '';
                                    await Constants().setEmployeeId(empId);
                                    loadEmployee();
                                  },
                                ),
                              )
                            : const Text("waiting.....");
                      }),
                ],
              ),
            ),
            ...screens
                .map(
                  (e) => ListTile(
                    title: Text(e.title),
                    onTap: () {
                      closeDrawer();
                      setState(
                        () => currentIndex = screens.indexOf(e),
                      );
                    },
                  ),
                )
                .toList()
          ],
        ),
      ),
      body: screens.elementAt(currentIndex),
    );
  }
}
