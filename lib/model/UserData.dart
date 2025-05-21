import 'package:flutter_ukl_2/service/url.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserData {
  bool? status = false;
  int? id;
  String? username;
  String? email;
  String? firstName;
  String? lastName;
  String? gender;
  String? image;
  String? accessToken;
  String? refreshToken;
  String? password;

  UserData({
    this.status,
    this.password,
    this.id,
    this.username,
    this.email,
    this.firstName,
    this.lastName,
    this.gender,
    this.image,
    this.accessToken,
    this.refreshToken,
  });

  Future<void> saveToPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt('id', id ?? 0);
    prefs.setString('username', username ?? '');
    prefs.setString('password', password ?? '');
    prefs.setString('email', email ?? '');
    prefs.setString('firstName', firstName ?? '');
    prefs.setString('lastName', lastName ?? '');
    prefs.setString('gender', gender ?? '');
    prefs.setString('image', image ?? '');
    prefs.setString('accessToken', accessToken ?? '');
    prefs.setString('refreshToken', refreshToken ?? '');
  }

  static Future<UserData> getFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    return UserData(
      id: prefs.getInt('id'),
      username: prefs.getString('username'),
      password: prefs.getString('password'),
      email: prefs.getString('email'),
      firstName: prefs.getString('firstName'),
      lastName: prefs.getString('lastName'),
      gender: prefs.getString('gender'),
      image: prefs.getString('image'),
      accessToken: prefs.getString('accessToken'),
      refreshToken: prefs.getString('refreshToken'),
    );
  }

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      id: json['id'],
      username: json['username'],
      email: json['email'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      gender: json['gender'],
      image: json['image'],
      accessToken: json['token'] ?? json['accessToken'],
      refreshToken: json['refreshToken'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      'gender': gender,
      'image': image,
      'accessToken': accessToken,
      'refreshToken': refreshToken,
    };
  }
}
