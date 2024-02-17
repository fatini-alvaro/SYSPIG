import 'package:flutter/material.dart';

class CustomMovimentarAnimalWidget extends StatefulWidget {
  final VoidCallback onClose;

  CustomMovimentarAnimalWidget({required this.onClose});

  @override
  _CustomMovimentarAnimalWidgetState createState() => _CustomMovimentarAnimalWidgetState();
}

class _CustomMovimentarAnimalWidgetState extends State<CustomMovimentarAnimalWidget> {
  TextEditingController _descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        
      ],
    );
  }
}
