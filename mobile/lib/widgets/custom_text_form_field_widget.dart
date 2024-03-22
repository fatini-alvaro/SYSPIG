import 'package:flutter/material.dart';
class CustomTextFormFieldWidget extends StatelessWidget {
  final Function(String) onChanged;
  final String? label;
  final TextInputType keyboardType;
  final bool obscureText;
  final String? errorText;
  final String? Function(String?)? validator;

  final InputDecoration? decoration;

  const CustomTextFormFieldWidget({
    Key? key, 
    required this.onChanged, 
    this.label,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    this.errorText,
    this.validator,
    this.decoration,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: keyboardType,
      decoration: decoration,
      onChanged: onChanged,
      obscureText:obscureText,   
      validator: validator,   
    );
  }
}
