import 'package:covid19/pages/data.dart';
import 'package:covid19/pages/home.dart';
import 'package:flutter/material.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _tabIndex = 0;
  List pages = [
    Home(),
    Data(),
    Home(),
    Home(),
    Home(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[_tabIndex],
      bottomNavigationBar: BottomNavigationBar(
        elevation: 1,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title: Text('首页'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assessment),
            title: Text('数据'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_alert),
            title: Text('辟谣'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.security),
            title: Text('防护'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.map),
            title: Text('百科'),
          ),
        ],
        type: BottomNavigationBarType.fixed,
        currentIndex: _tabIndex,
        onTap: (val) {
          setState(() {
            _tabIndex = val;
          });
        },
      ),
    );
  }
}
