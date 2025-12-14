import 'package:flutter/material.dart';

class TextFormFieldComponent extends StatelessWidget {
  final TextEditingController controller;
  final String? labelText;
  final String hintText;
  final IconData? prefixIcon;
  final bool? obscureText;
  final String? Function(String?)? validator;
  final TextInputType keyboardType;
  final IconButton? suffixIcon;

  const TextFormFieldComponent({
    super.key,
    required this.controller,
    this.labelText,
    required this.hintText,
    this.prefixIcon,
    this.validator,
    this.obscureText,
    this.suffixIcon,
    required this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: validator,
      obscureText: obscureText ?? false,
      keyboardType: keyboardType,
      controller: controller,
      style: TextStyle(
        color: Colors.black,
        fontSize: 19,
        fontFamily: "UbuntuFont",
      ),
      decoration: InputDecoration(
        fillColor: Colors.white,
        hintStyle: TextStyle(
          color: Color(0xffb4b4b4),
          fontSize: 19,
          fontFamily: "UbuntuFont",
        ),
        suffixIcon: suffixIcon,
        filled: true,
        labelText: labelText,
        hintText: hintText,
        prefixIcon:
            prefixIcon != null
                ? Icon(prefixIcon, color: Color(0xffb4b4b4))
                : null,
        border: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
      ),
    );
  }
}
