import 'dart:async';
import 'package:annicter/api/models/programs.dart';
import 'package:annicter/api/season.dart';
import 'package:annicter/api/models/works.dart';
import 'package:annicter/api/models/access_token.dart';
import 'package:meta/meta.dart';

abstract class AnnictApi {

  Future<AccessToken> authorize(
      { String clientId,
        String clientSecret,
        String code,
        String redirectUri = 'urn:ietf:wg:oauth:2.0:oob'
      });

  Future<Works> works({
    @required String accessToken,
    List<String> fields,
    List<int> filterIds,
    Season filterSeason,
    String filterTitle,
    int page = 1,
    int perPage = 25,
    String sortId,
    String sortSeason,
    String sortWatchersCount,
  });

  Future<Programs> programs({
    @required String accessToken,
    List<String> fields,
    List<int> filterIds,
    List<int> filterChannelIds,
    List<int> filterWorkIds,
    String filterStartedAtGt,
    String filterStartedAtLt,
    bool filterUnwatched = true,
    bool filterRebroadcast = true,
    int page = 1,
    int perPage = 25,
    String sortId,
    String sortStartedAt,
  });
}