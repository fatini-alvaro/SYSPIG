import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';

class CustomDateTimeFieldWidget extends StatefulWidget {
  final String? labelText;
  final ValueChanged<DateTime?> onChanged;

  const CustomDateTimeFieldWidget({
    Key? key,
    this.labelText,
    required this.onChanged,
  }) : super(key: key);

  @override
  State<CustomDateTimeFieldWidget> createState() =>
      _CustomDateTimeFieldWidgetState();
}

class _CustomDateTimeFieldWidgetState extends State<CustomDateTimeFieldWidget> {
  DateTime? selectedDate;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(2015),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        widget.onChanged(picked);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: TextEditingController(
        text: selectedDate != null ? '${selectedDate!.toLocal()}' : '',
      ),
      onTap: () => _selectDate(context),
      decoration: InputDecoration(
        labelText: widget.labelText,
        suffixIcon: Icon(Icons.calendar_today),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      readOnly: true,
    );
  }
}