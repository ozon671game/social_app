import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'profile.dart';

Future<List<UserCard>> updateDataUserList() async {
  var a = await http.get(Uri.parse('https://my-json-server.typicode.com/ozon671game/demo/db'));
  return _processResponse(a);
}

Future<List<Post>> updateDataPostList() async {
  var a = await http.get(Uri.parse('https://my-json-server.typicode.com/ozon671game/demo/db'));
  return _processResponseForPost(a);
}

List<UserCard> _processResponse(http.Response response) {
  if (response.statusCode == 200) {
    var users = jsonDecode(response.body)['profile'];
    var u = users.map((user) => UserCard.fromJson(user, user['username'])).whereType<UserCard>().toList();
    return u;
  }
  return [];
}

List<Post> _processResponseForPost(http.Response response){
  if (response.statusCode == 200) {
    var post = jsonDecode(response.body)['posts'];
    var u = post.map((post) => Post.fromJson(post, post['userId'])).whereType<Post>().toList();
    return u;
  }
  return [];
}

List<Post> definePosts(int id, List<Post> listPost){
  List<Post> myListPost = [];
  listPost.forEach((post) {
    if(post.userId == id) {
      myListPost.add(post);
    }
  });
  return myListPost;
}