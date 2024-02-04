import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:mobile/model/post/posts_model.dart';
import 'package:http/http.dart' as http;

class PostsController {
  ValueNotifier<List<Post>> posts = ValueNotifier<List<Post>>([]);
  ValueNotifier<bool> inLoader = ValueNotifier<bool>(false);

  callAPI() async {
    var client = http.Client();
    try {  
      inLoader.value = true;    
      var response = await client.get(
        Uri.parse('https://jsonplaceholder.typicode.com/posts'),
      );
      var decodedResponse = jsonDecode(response.body) as List;     
      posts.value = decodedResponse.map((e) => Post.fromJson(e)).toList();
    } finally {
      client.close();
      inLoader.value = false;  
    }
  }
}