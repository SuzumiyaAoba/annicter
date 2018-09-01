import 'dart:async';
import 'package:annicter/api/annict_api.dart';
import 'package:annicter/api/season.dart';
import 'package:annicter/api/models/works.dart';
import 'package:annicter/api/models/access_token.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AnnictApiImpl extends AnnictApi {

  static final singleton = new AnnictApiImpl._internal();

  factory AnnictApiImpl() {
    return singleton;
  }

  AnnictApiImpl._internal();

  static const String _API_ROOT = "https://api.annict.com";

  Future<String> _get(String url, {Map<String, String> headers, Map<String, String> query}) async {
    if(query == null) {
      query = Map();
    }
    var queryString = query.keys.toList()
        .where((key) => query[key] != null)
        .map((key) =>'$key=${query[key]}');
    url += '?${queryString.join('&')}';
    print('hoge: $url');
    var response = await http.get(url, headers: headers);
    if(response.statusCode == 200) {
      return response.body;
    }
    return throw(response);
  }

  Future<String> _post(String url, {Map<String, String> headers, Map<String, String> query}) async {
    var response = await http.post(url, headers: headers, body: query);
    if(response.statusCode == 200) {
      return response.body;
    }
    return throw(response);
  }

  Future<AccessToken> authorize(
      { String clientId,
        String clientSecret,
        String code,
        String redirectUri = 'urn:ietf:wg:oauth:2.0:oob'
      }) =>
        _post(
            '$_API_ROOT/oauth/token',
            query: {
                'client_id': clientId,
                'client_secret': clientSecret,
                'grant_type': 'authorization_code',
                'redirect_uri': redirectUri,
                'code': code
            }).then((it) => AccessToken.fromJson(json.decode(it)));

  Future<Works> works(
      String accessToken,
      {
        List<String> fields,
        List<int> filterIds,
        Season filterSeason,
        String filterTitle,
        int page = 1,
        int perPage = 25,
        String sortId,
        String sortSeason,
        String sortWatchersCount,
      }) {
    return _get(
      '$_API_ROOT/v1/works',
      headers: {'Authorization': 'Bearer $accessToken'},
      query: {
        'fields': fields?.join(','),
        'filter_ids': fields?.join(','),
        'filter_season': filterSeason?.toString(),
        'filter_title': filterTitle,
        'page': page.toString(),
        'per_page': perPage.toString(),
        'sort_id': sortId,
        'sort_season': sortSeason,
        'sort_watchers_count': sortWatchersCount,
      },
    ).then((it) => Works.fromJson(json.decode(it)));
  }
}