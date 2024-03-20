import 'package:flutter/material.dart';

class CustomTextFormFieldWidget extends StatelessWidget {
  final Function(String) onChanged;
  final String label;
  final TextInputType keyboardType;
  final bool obscureText;
  final String? errorText;
  final String? Function(String?)? validator;

  const CustomTextFormFieldWidget({
    Key? key, 
    required this.onChanged, 
    required this.label,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    this.errorText,
    this.validator,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(),
        errorText: errorText, // Exibe a mensagem de erro
      ),
      onChanged: onChanged,
      obscureText:obscureText,   
      validator: validator,   
    );
  }
}
