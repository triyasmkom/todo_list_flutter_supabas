import 'package:flutter/material.dart';

class LogoComponent extends StatefulWidget {
  final String text;
  const LogoComponent({super.key, required this.text});

  @override
  State<LogoComponent> createState() => _LogoComponentState();
}

class _LogoComponentState extends State<LogoComponent> {
  @override
  Widget build(BuildContext context) {
    final bool isSmallScreen = MediaQuery.of(context).size.width < 600;

    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(height: isSmallScreen ? 60 : 0),
        Image.asset(
          "assets/logo/logo-putih.png",
          width: isSmallScreen ? 200 : 300,
        ),
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            widget.text,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: isSmallScreen ? 22 : 28,
              fontFamily: "UbuntuFont",
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
