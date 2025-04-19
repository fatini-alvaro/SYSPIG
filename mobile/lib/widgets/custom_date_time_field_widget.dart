import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';

class CustomDateTimeFieldWidget extends StatefulWidget {
  final String? labelText;
  final ValueChanged<DateTime?> onChanged;
  final DateTime? initialValue;
  final bool showTime;
  final FormFieldValidator<DateTime?>? validator;  
  final bool? enabled;

  const CustomDateTimeFieldWidget({
    Key? key,
    this.labelText,
    required this.onChanged,
    this.initialValue,
    this.showTime = false,
    this.validator,
    this.enabled = true,
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

  Future<void> _selectDate(BuildContext context, FormFieldState<DateTime?> state) async {
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
            state.didChange(combined); // Atualiza o valor do FormField
            widget.onChanged(combined);
          });
        }
      } else {
        setState(() {
          selectedDate = pickedDate;
          state.didChange(pickedDate);
          widget.onChanged(pickedDate);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return FormField<DateTime?>(
      initialValue: selectedDate,
      validator: widget.validator,
      builder: (state) {
        final displayText = state.value != null
            ? widget.showTime
                ? '${state.value!.day.toString().padLeft(2, '0')}/${state.value!.month.toString().padLeft(2, '0')}/${state.value!.year} ${state.value!.hour.toString().padLeft(2, '0')}:${state.value!.minute.toString().padLeft(2, '0')}'
                : '${state.value!.day.toString().padLeft(2, '0')}/${state.value!.month.toString().padLeft(2, '0')}/${state.value!.year}'
            : '';

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: TextEditingController(text: displayText),
              onTap: widget.enabled! ? () => _selectDate(context, state) : null,
              decoration: InputDecoration(
                labelText: widget.labelText,
                suffixIcon: Icon(Icons.calendar_today),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                errorText: state.errorText,
              ),
              readOnly: true,
              enabled: widget.enabled,
            ),
          ],
        );
      },
    );
  }
}
