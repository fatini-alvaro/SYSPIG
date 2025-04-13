import 'package:flutter/material.dart';

class CustomDropdownButtonFormFieldWidget<T> extends StatelessWidget {
  final List<DropdownMenuItem<T>>? items;
  final T? value;
  final String labelText;
  final String? hintText;
  final Icon? prefixIcon;
  final Icon? suffixIcon;
  final void Function(T?)? onChanged;
  final String? Function(T?)? validator;
  final bool? isEnabled;

  const CustomDropdownButtonFormFieldWidget({
    Key? key,
    required this.items,
    this.value,
    required this.labelText,
    this.hintText,
    this.prefixIcon,
    this.suffixIcon,
    this.onChanged,
    this.validator,
    this.isEnabled = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<T>(
      value: value,
      items: items,
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      onChanged: isEnabled == true ? onChanged : null,
      validator: validator != null ? (value) => validator!(value) : null,
    );
  }
}
