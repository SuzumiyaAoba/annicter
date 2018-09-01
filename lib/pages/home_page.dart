import 'package:annicter/bloc/home_bloc.dart';
import 'package:annicter/pages/works_page.dart';
import 'package:annicter/theme.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new HomeState();
}

class HomeState extends State<HomePage> {
  HomeBloc _bloc;

  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();

    _bloc = HomeBloc();

    _bloc.outCurrentTabIndex.listen((index) =>
        setState(() =>_currentIndex = index));
  }

  @override
  void dispose() {
    _bloc.dispose();

    super.dispose();
  }

  final List<Widget> _children = [
    Icon(Icons.timeline),
    WorksScreen(),
    Icon(Icons.directions_bike),
  ];

  void onTabTapped(int index) {
    _bloc.inCurrentTabIndex.add(index);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: themeData,
      home: DefaultTabController(
        length: 3,
        initialIndex: 0,
        child: Scaffold(
          appBar: AppBar(
            title: Text(
              'Annicter',
            ),
            elevation: 0.0,
          ),
          body: _children[_currentIndex],
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: _currentIndex,
            onTap: onTabTapped,
            items: _buildBottomNavigationBarItems(),
          ),
        ),
      ),
    );
  }

  List<BottomNavigationBarItem> _buildBottomNavigationBarItems() {
    return [
      BottomNavigationBarItem(
        icon: Icon(Icons.timeline),
        title: Text('放送予定'),
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.list),
        title: Text('作品'),
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.local_activity),
        title: Text('アクティビティ',),
      ),
    ];
  }
}
