import 'package:flutter/material.dart';
import 'package:syspig/model/post_model.dart';

class DetailsPage extends StatelessWidget {
  const DetailsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    PostModel args = ModalRoute.of(context)!.settings.arguments as PostModel;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: Text(args.title),
      ), 
      body: Container(
        padding: EdgeInsets.all(28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              args.title, 
              style: TextStyle(
                fontSize: 22, 
                fontWeight: FontWeight.bold, 
                fontStyle: FontStyle.italic
              ),
            ),
            SizedBox(height: 24),
            Text(
              args.body,
              style: TextStyle(
                fontSize: 16
              ),
            ),
            SizedBox(height: 24),
            Text(
              'Noticia: ${args.id.toString()}, Autor: ${args.userId}',
              style: TextStyle(
                fontSize: 16
              ),
            ),
          ]
        ),
      ),
    );
  } 

}