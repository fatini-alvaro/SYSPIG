import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class CustomValorMonetarioFormFieldWidget extends StatefulWidget {
  final Function(double) onChanged;
  final String label;
  final String? hintText;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final double? maxValue;
  final String? initialValue;

  const CustomValorMonetarioFormFieldWidget({
    Key? key,
    required this.onChanged,
    required this.label,
    this.hintText,
    this.controller,
    this.validator,
    this.maxValue,
    this.initialValue,
  }) : super(key: key);

  @override
  State<CustomValorMonetarioFormFieldWidget> createState() =>
      _CustomValorMonetarioFormFieldWidgetState();
}

class _CustomValorMonetarioFormFieldWidgetState
    extends State<CustomValorMonetarioFormFieldWidget> {
  late final TextEditingController _internalController;
  final _currencyFormatter = NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');

  @override
  void initState() {
    super.initState();
    _internalController = widget.controller ?? TextEditingController();

    if (widget.initialValue != null) {
      final initialDouble = double.tryParse(widget.initialValue!) ?? 0.0;
      _internalController.text = _currencyFormatter.format(initialDouble);
    }
  }

  String _onlyNumbers(String value) {
    return value.replaceAll(RegExp(r'[^\d]'), '');
  }

  void _onChanged(String value) {
    final cleaned = _onlyNumbers(value);

    if (cleaned.isEmpty) {
      widget.onChanged(0.0);
      return;
    }

    final doubleValue = double.parse(cleaned) / 100;

    if (widget.maxValue != null && doubleValue > widget.maxValue!) {
      final correctedValue = widget.maxValue!;
      _internalController.text = _currencyFormatter.format(correctedValue);
      _internalController.selection = TextSelection.fromPosition(
        TextPosition(offset: _internalController.text.length),
      );
      widget.onChanged(correctedValue);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Valor maior que o permitido')),
      );
    } else {
      _internalController.text = _currencyFormatter.format(doubleValue);
      _internalController.selection = TextSelection.fromPosition(
        TextPosition(offset: _internalController.text.length),
      );
      widget.onChanged(doubleValue);
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: _internalController,
      keyboardType: TextInputType.number,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
      ],
      decoration: InputDecoration(
        labelText: widget.label,
        hintText: widget.hintText ?? 'Ex: R\$ 25,50',
        contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      onChanged: _onChanged,
      validator: widget.validator,
    );
  }
}
