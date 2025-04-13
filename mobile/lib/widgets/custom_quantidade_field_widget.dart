import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomQuantidadeFormFieldWidget extends StatelessWidget {
  final Function(String) onChanged;
  final String label;
  final String? hintText;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final String? initialValue;

  const CustomQuantidadeFormFieldWidget({
    Key? key,
    required this.onChanged,
    required this.label,
    this.hintText,
    this.controller,
    this.validator,
    this.initialValue,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: TextInputType.number,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly, // <- isso limita a números inteiros
      ],
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        hintText: hintText,
        contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      onChanged: onChanged,
      validator: validator,
      initialValue: initialValue,
    );
  }
}
