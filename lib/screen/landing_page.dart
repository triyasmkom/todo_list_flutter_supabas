import 'package:flutter/material.dart';
import 'package:todolist_app/screen/account/menu_account_page.dart';
import 'package:todolist_app/screen/home_menu/home_page.dart';
import 'package:todolist_app/screen/widget/history_page.dart';

class BottomNavigationBarPage extends StatefulWidget {
  const BottomNavigationBarPage({super.key});

  @override
  State<BottomNavigationBarPage> createState() =>
      _BottomNavigationBarPageState();
}

class _BottomNavigationBarPageState extends State<BottomNavigationBarPage> {
  int _selectedIndex = 0;

  // static const TextStyle optionStyle = TextStyle(
  //   fontWeight: FontWeight.bold,
  //   fontSize: 30,
  // );

  static const List<Widget> _widgetOptions = <Widget>[
    HomePage(),
    HistoryPage(),
    MenuAccountPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: _widgetOptions.elementAt(_selectedIndex)),
      bottomNavigationBar: Container(
        width: double.infinity,
        height: 90,

        child: BottomNavigationBar(
          unselectedLabelStyle: TextStyle(
            fontSize: 20,
            fontFamily: "PoppinsFont",
          ),
          selectedLabelStyle: TextStyle(
            fontFamily: "PoppinsFont",
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
          backgroundColor: Color(0xff5b8bdf),
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home, size: 30),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.history, size: 30),
              label: 'Riwayat',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person, size: 30),
              label: 'Akun',
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.amber[800],
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}
