import 'package:flutter/material.dart';
import 'package:vanapp/views/goods_reciever_screen.dart';
import 'package:vanapp/views/settings_screen.dart';
import 'package:vanapp/views/view_scanned_product_screen.dart';
import 'package:vanapp/views/write_stock_taken_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Widget> screens = [
    const ViewScannedProductScreen(),
    const GoodsRecieverScreen(),
    const WriteStockScreen(),
    const SettingsScreen(),
  ];
  int currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const ListTile(),
            ListTile(
              title: const Text('View product details'),
              onTap: () => setState(
                () => currentIndex = 0,
              ),
            ),
            ListTile(
              title: const Text('Goods reciever'),
              onTap: () => setState(
                () => currentIndex = 1,
              ),
            ),
            ListTile(
              title: const Text('Enter Stock'),
              onTap: () => setState(
                () => currentIndex = 2,
              ),
            ),
            ListTile(
              title: const Text('Settings'),
              onTap: () => setState(
                () => currentIndex = 3,
              ),
            ),
          ],
        ),
      ),
      body: screens.elementAt(currentIndex),
    );
  }
}
