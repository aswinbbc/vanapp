import 'package:flutter/material.dart';
import 'package:vanapp/utils/constants/constant.dart';
import 'package:vanapp/views/add_product_screen.dart';
import 'package:vanapp/views/goods_reciever_screen.dart';
import 'package:vanapp/views/purchase_return/purchase_return_screen.dart';
import 'package:vanapp/views/settings_screen.dart';
import 'package:vanapp/views/view_scanned_product_screen.dart';
import 'package:vanapp/views/write_stock_taken_screen.dart';

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

  @override
  void initState() {
    Constants().setEmployeeName("");
    Constants().setEmployeeId("");

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        toolbarHeight: 40,
        centerTitle: true,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const ListTile(),
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
