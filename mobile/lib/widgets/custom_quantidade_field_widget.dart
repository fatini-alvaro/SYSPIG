import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomQuantidadeFormFieldWidget extends StatelessWidget {
  final Function(String) onChanged;
  final String label;
  final String? hintText;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final String? initialValue;
  final int? maxValue;

  const CustomQuantidadeFormFieldWidget({
    Key? key,
    required this.onChanged,
    required this.label,
    this.hintText,
    this.controller,
    this.validator,
    this.initialValue,
    this.maxValue,
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
      onChanged: (value) {
        final parsed = int.tryParse(value) ?? 0;

        if (maxValue != null && parsed > maxValue!) {
          // Limita o valor ao máximo permitido
          final correctedValue = maxValue!.toString();
          controller?.text = correctedValue;
          controller?.selection = TextSelection.fromPosition(
            TextPosition(offset: correctedValue.length),
          );
          onChanged(correctedValue);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Quantidade maior que o disponível')),
          );
        } else {
          onChanged(value);
        }
      },
      validator: validator,
      initialValue: initialValue,
    );
  }
}
