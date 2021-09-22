import 'dart:async';
import 'dart:convert';
// import 'dart:html';

import 'package:http/http.dart' as http;

class UserCard {
  final String adress;
  final String email;
  final int id;
  final String name;
  final String phone;
  final String username;
  final String website;


  UserCard(
      this.adress, this.email, this.id, this.name, this.phone, this.username, this.website);


  UserCard.fromJson(Map<String, dynamic> json, this.username)
      : adress = json['adress'],
        email = json['email'],
        id = json['id'],
        phone = json['phone'],
        name = json['name'],
        website = json['website'];

  Map<String, dynamic> toJson() => {
    'adress': adress,
    'email': email,
    'id': id,
    'phone': phone,
    'name': name,
    'website': website,
  };
}

class Post{
  final int id;
  final int userId;
  final String title;
  final String description;

  Post(this.id, this.title, this.description, this.userId);

  Post.fromJson(Map<String, dynamic> json, this.userId)
      : title = json['title'],
        description = json['description'],
        id = json['id'];

  Map<String, dynamic> toJson() => {
    'title': title,
    'description': description,
    'id': id,

  };
}

class WorkingCompany{
  final int id;
  final int userId;
  final String name;
  final String bs;
  final String catchPhrase;

  WorkingCompany(this.id, this.userId, this.bs, this.catchPhrase, this.name);

  WorkingCompany.fromJson(Map<String, dynamic> json, this.userId)
      : id = json['id'],
        bs = json['bs'],
        name = json['name'],
        catchPhrase = json['catchPhrase'];

  Map<String, dynamic> toJson() => {
    'bs': bs,
    'catchPhrase': catchPhrase,
    'name': name,
    'id': id,
  };
}

class Album{
  final int id;
  final int userId;
  final int numberPhotos;
  final String title;

  Album(this.id, this.userId, this.numberPhotos, this.title);

  Album.fromJson(Map<String, dynamic> json, this.userId)
      : id = json['id'],
        numberPhotos = json['numberPhotos'],
        title = json['title'];

  Map<String, dynamic> toJson() => {
    'title': title,
    'numberPhotos': numberPhotos,
    'id': id,
  };
}

class Comment{
  final int id;
  final int userId;
  final int postId;
  final String text;

  Comment(this.id, this.userId, this.postId, this.text);

  Comment.fromJson(Map<String, dynamic> json, this.userId)
      : id = json['id'],
        postId = json['postId'],
        text = json['text'];

  Map<String, dynamic> toJson() => {
    'text': text,
    'postId': postId,
    'id': id,
  };
}
