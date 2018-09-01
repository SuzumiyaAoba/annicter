import 'dart:async';
import 'package:annicter/api/annict_api.dart';
import 'package:annicter/api/annict_api_impl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:annicter/constatns.dart';

class LoginPage extends StatefulWidget {

  LoginPage({
    Key key,
    @required this.annict,
    @required this.clientId,
    @required this.clientSecret,
  });

  final AnnictApi annict;
  final String clientId;
  final String clientSecret;

  @override
  State<StatefulWidget> createState() => new _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final flutterWebViewPlugin = new FlutterWebviewPlugin();

  StreamSubscription<String> _onUrlChanged;

  @override
  void dispose() {
    _onUrlChanged.cancel();
    flutterWebViewPlugin.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    flutterWebViewPlugin.close();

    _onUrlChanged = flutterWebViewPlugin.onUrlChanged
        .listen(_handleOnUrlChanged);
  }

  void saveToken(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('access_token', token);
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(routes: {
      '/': (_) => new WebviewScaffold(
        url: Constants.authUri,
        appBar: new AppBar(
          title: new Text('アプリと連携'),
        ),
      )
    });
  }

  void _handleOnUrlChanged(String url) {
    if (mounted) {
      setState(() {
        if(url.startsWith(Constants.redirectUri)) {
          RegExp regExp = new RegExp('code=(.*)');
          var code = regExp.firstMatch(url)?.group(1);

          widget.annict.authorize(
              clientId: widget.clientId,
              clientSecret: widget.clientSecret,
              code: code
          ).then((it) => saveToken(it.accessToken));

          Navigator.of(context).pushNamedAndRemoveUntil(
              '/home', (Route<dynamic> route) => false);
          flutterWebViewPlugin.close();
        }
      });
    }
  }
}