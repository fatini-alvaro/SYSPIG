import 'package:flutter/material.dart';

class CustomPreVisualizacaoAnotacaoCard extends StatefulWidget {
  @override
  _CustomPreVisualizacaoAnotacaoCardState createState() => _CustomPreVisualizacaoAnotacaoCardState();
}

class _CustomPreVisualizacaoAnotacaoCardState extends State<CustomPreVisualizacaoAnotacaoCard> with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.grey[300],
      elevation: 5,
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                border: Border(
                  left: BorderSide(
                    width: 10,
                    color: Colors.green,
                  ),
                ),
              ),
              padding: EdgeInsets.only(left: 16),
              constraints: BoxConstraints(maxWidth: 285),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                  'Marcos Paulo Tal',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                  '22/01/2024 15:21',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                  Card(
                    color: Colors.white,
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Text(
                        'Lorem ipsum dolor sit amet',
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}