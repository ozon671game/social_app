import 'package:http/http.dart' as http;
import 'dart:convert';

import 'profile.dart';

Future<List<UserCard>> updateData() async {
  var a = await http.get(Uri.parse('https://my-json-server.typicode.com/ozon671game/demo/db'));
  return _processResponse(a);
}

List<UserCard> _processResponse(http.Response response) {
  if (response.statusCode == 200) {
    var users = jsonDecode(response.body)['profile'];
    var u = users.map((user) => UserCard.fromJson(user, user['name'])).whereType<UserCard>().toList();
    return u;
  }
  return [];
}

