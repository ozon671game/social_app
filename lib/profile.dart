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
  final String website;

  late Map<String, dynamic> _valueMap;

  UserCard(
      this.adress, this.email, this.id, this.name, this.phone, this.website);


  UserCard.fromJson(Map<String, dynamic> _valueMap, this.name)
      : adress = _valueMap['adress'],
        email = _valueMap['email'],
        id = _valueMap['id'],
        phone = _valueMap['phone'],
        website = _valueMap['website'];

  Map<String, dynamic> toJson() => {
    'adress': adress,
    'email': email,
    'id': id,
    'phone': phone,
    'website': website,
  };
}
