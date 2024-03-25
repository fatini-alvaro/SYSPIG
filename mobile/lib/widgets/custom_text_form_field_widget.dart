import 'package:flutter/material.dart';

class CustomTextFormFieldWidget extends StatelessWidget {
  final Function(String) onChanged;
  final String label;
  final String? hintText;
  final Icon? prefixIcon;
  final Icon? suffixIcon;
  final TextInputType? keyboardType;
  final bool obscureText;
  final String? errorText;
  final String? Function(String?)? validator;
  final String? initialValue;

  const CustomTextFormFieldWidget({
    Key? key, 
    required this.onChanged, 
    required this.label,
    this.hintText,
    this.prefixIcon,
    this.suffixIcon,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    this.errorText,
    this.validator,
    this.initialValue
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(      
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        hintText: hintText,
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      onChanged: onChanged,
      obscureText:obscureText,   
      validator: validator,   
      initialValue: initialValue,
    );
  }
}
