import 'package:annicter/client_id.dart';

class Constants {
  static const redirectUri = "https://annict.jp/oauth/authorize/native?code=";
  static const authUri = "https://annict.jp/oauth/authorize?client_id=$client_id&redirect_uri=urn%3Aietf%3Awg%3Aoauth%3A2.0%3Aoob&response_type=code&scope=read+write";
}