import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomPesoFormFieldWidget extends StatelessWidget {
  final Function(String) onChanged;
  final String label;
  final String? hintText;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final String? initialValue;
  final double? maxValue;

  const CustomPesoFormFieldWidget({
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
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
      ],
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        hintText: hintText ?? 'Ex: 7.5',
        contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      onChanged: (value) {
        final parsed = double.tryParse(value) ?? 0.0;

        if (maxValue != null && parsed > maxValue!) {
          final correctedValue = maxValue!.toStringAsFixed(2);
          controller?.text = correctedValue;
          controller?.selection = TextSelection.fromPosition(
            TextPosition(offset: correctedValue.length),
          );
          onChanged(correctedValue);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Peso maior que o permitido')),
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
