import 'package:flutter/material.dart';

class TextButtonComponent extends StatelessWidget {
  final String labelText;
  final VoidCallback onPressed;

  const TextButtonComponent({
    super.key,
    required this.onPressed,
    required this.labelText,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: ButtonStyle(
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
        mouseCursor: WidgetStateProperty.all(SystemMouseCursors.click),
        foregroundColor: WidgetStateProperty.resolveWith((state) {
          if (state.contains(WidgetState.hovered)) {
            return Colors.white;
          }
          return const Color(0xff2c64c6);
        }),
      ),
      onPressed: onPressed,
      child: Text(
        labelText,
        style: TextStyle(
          fontFamily: "UbuntuFont",
          fontWeight: FontWeight.bold,
          fontSize: 16,
          color: Colors.black,
        ),
      ),
    );
  }
}
