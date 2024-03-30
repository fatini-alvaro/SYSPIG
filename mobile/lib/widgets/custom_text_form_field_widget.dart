import 'package:flutter/material.dart';

class CustomTextFormFieldWidget extends StatelessWidget {
  final Function(String) onChanged;
  final Function()? onTap;
  final String label;
  final String? hintText;
  final Icon? prefixIcon;
  final Icon? suffixIcon;
  final TextInputType? keyboardType;
  final bool obscureText;
  final String? errorText;
  final String? Function(String?)? validator;
  final String? initialValue;
  final TextEditingController? controller;

  const CustomTextFormFieldWidget({
    Key? key, 
    required this.onChanged, 
    required this.label,
    this.onTap,
    this.hintText,
    this.prefixIcon,
    this.suffixIcon,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    this.errorText,
    this.validator,
    this.initialValue,
    this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(      
      keyboardType: keyboardType,
      controller: controller,
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
      onTap: onTap,
      obscureText:obscureText,   
      validator: validator,   
      initialValue: initialValue,
    );
  }
}
