import 'dart:async';
import 'dart:collection';

import 'package:annicter/api/annict_api.dart';
import 'package:annicter/api/models/programs.dart';
import 'package:annicter/api/models/program.dart';
import 'package:annicter/api/models/work.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProgramsBloc {
  String _accessToken;

  int _programsPerPage = 25;

  int _totalPrograms = -1;

  final _fetchPages = <int, Programs>{};
  final _pagesBeingFetched = Set<int>();

  // ########## STREAM ##########

  PublishSubject<String> _accessTokenController = PublishSubject<String>();
  Sink<String> get inAccessToken => _accessTokenController.sink;

  PublishSubject<List<Program>> _programsController = PublishSubject<List<Program>>();
  Sink<List<Program>> get _inProgramsList => _programsController.sink;
  Stream<List<Program>> get outProgramsList => _programsController.stream;

  PublishSubject<int> _indexController = PublishSubject<int>();
  Sink<int> get inProgramIndex => _indexController.sink;

  BehaviorSubject<int> _totalProgramsController = BehaviorSubject<int>(seedValue: 0);
  Sink<int> get _inTotalPrograms => _totalProgramsController.sink;
  Stream<int> get outTotalPrograms => _totalProgramsController.stream;

  ProgramsBloc(AnnictApi api) {
    _indexController.stream
        .bufferTime(Duration(microseconds: 500))
        .where((batch) => batch.isNotEmpty)
        .listen((indexes) => _handleIndexes(indexes, api));

    _accessTokenController.stream
        .listen((token) => _accessToken = token);

    _loadAccessToken();
  }

  void dispose() {
    _accessTokenController.close();

    _programsController.close();
    _indexController.close();
    _totalProgramsController.close();
  }

  void _loadAccessToken() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    _accessToken = sp.getString('access_token');
  }

  void _handleIndexes(List<int> indexes, AnnictApi api) {
    indexes.forEach((index) {
      final int pageIndex = 1 + ((index + 1) ~/ _programsPerPage);
      if (!_fetchPages.containsKey(pageIndex)) {
        if (!_pagesBeingFetched.contains(pageIndex)) {
          _pagesBeingFetched.add(pageIndex);

          api.programs(
            accessToken: _accessToken,
            sortStartedAt: 'desc',
            page: pageIndex,
            perPage: _programsPerPage,
          ).then((fetchedPage) => _handleFetchedPage(fetchedPage, pageIndex));
        }
      }
    });
  }

  void _handleFetchedPage(Programs page, int pageIndex) {
    _fetchPages[pageIndex] = page;
    _pagesBeingFetched.remove(pageIndex);

    List<Program> programs = <Program>[];
    List<int> pageIndexes = _fetchPages.keys.toList();
    pageIndexes.sort((a, b) => a.compareTo(b));

    final int minPageIndex = pageIndexes[0];
    final int maxPageIndex = pageIndexes[pageIndexes.length - 1];

    if (minPageIndex == 1) {
      for (int i = 1; i <= maxPageIndex; i++) {
        if (!_fetchPages.containsKey(i)) {
          break;
        }

        programs.addAll(_fetchPages[i].programs);
      }
    }

    if (_totalPrograms == -1) {
      _totalPrograms = page.totalCount;
      _inTotalPrograms.add(_totalPrograms);
    }

    if (programs.length > 0) {
      _inProgramsList.add(UnmodifiableListView<Program>(programs));
    }
  }
}