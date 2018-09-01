import 'package:annicter/api/annict_api_impl.dart';
import 'package:annicter/client_id.dart';
import 'package:annicter/client_secret.dart';
import 'package:annicter/pages/home_page.dart';
import 'package:annicter/pages/login_page.dart';
import 'package:annicter/pages/main_page.dart';
import 'package:annicter/theme.dart';
import 'package:flutter/material.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Annicter',
      theme: themeData,
      initialRoute: '/',
      routes: {
        '/': (_) => MainPage(),
        '/login': (_) => LoginPage(
          annict: AnnictApiImpl.singleton,
          clientId: client_id,
          clientSecret: client_secret,
        ),
        '/home': (_) => HomePage(),
      },
    );
  }
}

