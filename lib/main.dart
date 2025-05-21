import 'package:flutter/material.dart';
import 'package:flutter_ukl_2/views/Lagu.dart';
import 'package:flutter_ukl_2/views/Login.dart';
import 'package:flutter_ukl_2/views/home.dart';
import 'package:flutter_ukl_2/views/isiLagu.dart';
import 'package:flutter_ukl_2/views/playlist.dart';
import 'package:flutter_ukl_2/views/tambahPlaylist.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    initialRoute: '/',
    routes: {
      '/':(context) => LoginPage(),
      '/home':(context) => HomePage(userName: 'emilys'),
       '/playlist':(context) => Playlist(),
       '/lagu':(context) => Lagu(playlistId: '',),
       '/lagu2':(context) => IsiLagu(songId: '',),
       '/tambah':(context) => TambahLagu(),
    }
  )
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp();
  }
}
