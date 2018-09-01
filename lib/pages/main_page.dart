import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new MainState();
}

class MainState extends State<MainPage> {

  @override
  void initState() {
    super.initState();

    authorize();
  }

  Future authorize() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if(prefs.getKeys().contains('access_token')) {
      Navigator.of(context).pushNamedAndRemoveUntil(
          '/home', (Route<dynamic> route) => false);
    } else {
      Navigator.of(context).pushNamedAndRemoveUntil(
          '/login', (Route<dynamic> route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold();
  }
}

