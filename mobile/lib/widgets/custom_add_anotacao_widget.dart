import 'package:flutter/material.dart';

class CustomAddAnotacaoWidget extends StatefulWidget {
  final VoidCallback onClose;

  CustomAddAnotacaoWidget({required this.onClose});

  @override
  _CustomAddAnotacaoWidgetState createState() => _CustomAddAnotacaoWidgetState();
}

class _CustomAddAnotacaoWidgetState extends State<CustomAddAnotacaoWidget> {
  TextEditingController _descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Adicionar Anotação',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 20),
        TextField(
          maxLines: null, // Allows for multiline text input
          controller: _descriptionController,
          decoration: InputDecoration(
            hintText: 'Digite sua descrição aqui...',
            labelText: 'Descrição da anotação',
            border: OutlineInputBorder(),
          ),
        ),
        SizedBox(height: 20),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.orange,
            foregroundColor: Colors.white,
            elevation: 5,
            minimumSize: Size(MediaQuery.of(context).size.width, 50),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            ),
          ),
          onPressed: () {
            String description = _descriptionController.text;
            print('Description: $description');
            _descriptionController.clear();
            widget.onClose(); // Notify the parent to close the widget
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.border_color_rounded,
                color: Colors.white,
              ),
              SizedBox(width: 8),
              Text(
                'Adicionar anotação',
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
