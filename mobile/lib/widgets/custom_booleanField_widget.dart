import 'package:flutter/material.dart';

class CustomBooleanFieldWidget extends StatelessWidget {
  final String label;
  final bool? value;
  final ValueChanged<bool?> onChanged;
  final String? trueLabel;
  final String? falseLabel;
  final FormFieldValidator<bool?>? validator;
  final bool isExpanded;

  const CustomBooleanFieldWidget({
    Key? key,
    required this.label,
    required this.onChanged,
    this.value,
    this.trueLabel = 'Sim',
    this.falseLabel = 'Não',
    this.validator,
    this.isExpanded = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<bool>(
      value: value,
      onChanged: onChanged,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      ),
      isExpanded: isExpanded,
      items: [
        DropdownMenuItem(
          value: true,
          child: Text(trueLabel ?? 'Sim'),
        ),
        DropdownMenuItem(
          value: false,
          child: Text(falseLabel ?? 'Não'),
        ),
      ],
    );
  }
}
