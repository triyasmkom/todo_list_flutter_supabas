import 'dart:async';

import 'package:flutter/material.dart';
import 'package:todolist_app/screen/landing_page.dart';

class LauncherPage extends StatefulWidget {
  const LauncherPage({super.key});

  @override
  State<LauncherPage> createState() => _LauncherPageState();
}

class _LauncherPageState extends State<LauncherPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    startLaunching();
  }

  startLaunching() async {
    var duration = Duration(seconds: 2);

    return Timer(duration, () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) {
            return BottomNavigationBarPage();
          },
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/background/login.png"),
            fit: BoxFit.fill,
          ),
        ),
        child: Center(
          child: Image.asset(
            "assets/logo/logo-putih.png",
            height: 216,
            width: 360,
          ),
        ),
      ),
    );
  }
}
