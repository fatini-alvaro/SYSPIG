import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';

class CustomDateTimeFieldWidget extends StatefulWidget {
  final String? labelText;
  final ValueChanged<DateTime?> onChanged;
  final DateTime? initialValue;
  final bool showTime;

  const CustomDateTimeFieldWidget({
    Key? key,
    this.labelText,
    required this.onChanged,
    this.initialValue,
    this.showTime = false,
  }) : super(key: key);

  @override
  State<CustomDateTimeFieldWidget> createState() =>
      _CustomDateTimeFieldWidgetState();
}

class _CustomDateTimeFieldWidgetState extends State<CustomDateTimeFieldWidget> {
  DateTime? selectedDate;

  @override
  void initState() {
    super.initState();
    selectedDate = widget.initialValue;
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(2015),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      if (widget.showTime) {
        final TimeOfDay? pickedTime = await showTimePicker(
          context: context,
          initialTime: TimeOfDay.fromDateTime(selectedDate ?? DateTime.now()),
        );

        if (pickedTime != null) {
          final DateTime combined = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          );
          setState(() {
            selectedDate = combined;
            widget.onChanged(combined);
          });
        }
      } else {
        setState(() {
          selectedDate = pickedDate;
          widget.onChanged(pickedDate);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final displayText = selectedDate != null
        ? widget.showTime
            ? '${selectedDate!.day.toString().padLeft(2, '0')}/${selectedDate!.month.toString().padLeft(2, '0')}/${selectedDate!.year} ${selectedDate!.hour.toString().padLeft(2, '0')}:${selectedDate!.minute.toString().padLeft(2, '0')}'
            : '${selectedDate!.day.toString().padLeft(2, '0')}/${selectedDate!.month.toString().padLeft(2, '0')}/${selectedDate!.year}'
        : '';

    return TextField(
      controller: TextEditingController(text: displayText),
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
