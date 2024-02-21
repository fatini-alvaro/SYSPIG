import 'package:flutter/material.dart';

class CustomTextFieldWidget extends StatelessWidget {
  final Function(String) onChanged;
  final String label;
  final TextInputType keyboardType;
  final bool obscureText;
  final String? errorText;

  const CustomTextFieldWidget({
    Key? key, 
    required this.onChanged, 
    required this.label,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    this.errorText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(),
        errorText: errorText, // Exibe a mensagem de erro
      ),
      onChanged: onChanged,
      obscureText:obscureText
    );
  }
}
