import 'dart:async';

import 'package:rxdart/rxdart.dart';

class HomeBloc {

  BehaviorSubject<int> _currentTabIndexController = BehaviorSubject(seedValue: 0);
  Sink<int> get inCurrentTabIndex => _currentTabIndexController.sink;
  Stream<int> get outCurrentTabIndex => _currentTabIndexController.stream;

  void dispose() {
    _currentTabIndexController.close();
  }
}