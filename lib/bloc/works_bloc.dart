import 'dart:async';
import 'dart:collection';

import 'package:annicter/api/annict_api.dart';
import 'package:annicter/api/annict_api_impl.dart';
import 'package:annicter/api/models/work.dart';
import 'package:annicter/api/models/works.dart';
import 'package:annicter/api/season.dart';
import 'package:rxdart/subjects.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WorksBloc {
  String _accessToken;

  int _worksPerPage = 25;

  int _totalWorks = -1;

  final _fetchPages = <int, Works>{};

  final _pagesBeingFetched = Set<int>();

  // ########## STREAMS ##########

  PublishSubject<String> _accessTokenController = PublishSubject<String>();
  Sink<String> get inAccessToken => _accessTokenController.sink;

  PublishSubject<List<Work>> _worksController = PublishSubject<List<Work>>();
  Sink<List<Work>> get _inWorksList => _worksController.sink;
  Stream<List<Work>> get outWorksList => _worksController.stream;

  PublishSubject<int> _indexController = PublishSubject<int>();
  Sink<int> get inWorkIndex => _indexController.sink;

  BehaviorSubject<int> _totalWorksController =
      BehaviorSubject<int>(seedValue: 0);
  Sink<int> get _inTotalWorks => _totalWorksController.sink;
  Stream<int> get outTotalWorks => _totalWorksController.stream;

  WorksBloc(AnnictApi api) {
    _indexController.stream
        .bufferTime(Duration(microseconds: 500))
        .where((batch) => batch.isNotEmpty)
        .listen((indexes) => _handleIndexes(indexes, api));

    _accessTokenController.stream
        .listen((token) => _accessToken = token);

    _loadAccessToken();
  }

  void dispose() {
    _worksController.close();
    _indexController.close();
    _accessTokenController.close();

    _totalWorksController.close();
  }

  void _loadAccessToken() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    _accessToken = sp.getString('access_token');
  }

  void _handleIndexes(List<int> indexes, AnnictApi api) {
    indexes.forEach((index) {
      final int pageIndex = 1 + ((index + 1) ~/ _worksPerPage);
      if (!_fetchPages.containsKey(pageIndex)) {
        if (!_pagesBeingFetched.contains(pageIndex)) {
          _pagesBeingFetched.add(pageIndex);

          api.works(
            _accessToken,
            filterSeason: Season(2018, FourSeasons.summer),
            sortWatchersCount: 'desc',
            page: pageIndex,
            perPage: _worksPerPage,
          ).then((fetchedPage) => _handleFetchedPage(fetchedPage, pageIndex));
        }
      }
    });
  }

  void _handleFetchedPage(Works page, int pageIndex) {
    _fetchPages[pageIndex] = page;
    _pagesBeingFetched.remove(pageIndex);

    List<Work> works = <Work>[];
    List<int> pageIndexes = _fetchPages.keys.toList();
    pageIndexes.sort((a, b) => a.compareTo(b));

    final int minPageIndex = pageIndexes[0];
    final int maxPageIndex = pageIndexes[pageIndexes.length - 1];

    if (minPageIndex == 1) {
      for (int i = 1; i <= maxPageIndex; i++) {
        if (!_fetchPages.containsKey(i)) {
          break;
        }

        works.addAll(_fetchPages[i].works);
      }
    }

    if (_totalWorks == -1) {
      _totalWorks = page.totalCount;
      _inTotalWorks.add(_totalWorks);
    }

    if (works.length > 0) {
      _inWorksList.add(UnmodifiableListView<Work>(works));
    }
  }
}
