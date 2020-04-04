import 'package:covid19/pages/data.dart';
import 'package:covid19/pages/home.dart';
import 'package:covid19/pages/recommend_list.dart';
import 'package:covid19/pages/rumor_list.dart';
import 'package:covid19/pages/wiki_list.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _tabIndex = 0;
  PageController _pageController;
  DateTime _lastPressedAt; // 上次点击时间
  List pages = [
    Home(),
    Data(),
    RumorList(),
    RecommendList(),
    WikiList(),
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Fluttertoast.showToast(
          msg: '再按一次退出app',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
        );
        if (_lastPressedAt == null || DateTime.now().difference(_lastPressedAt) > Duration(seconds: 1)) {
          // 两次点击间隔超过1秒则重新计时
          _lastPressedAt = DateTime.now();
          return false;
        }
        return true;
      },
      child: Scaffold(
        body: PageView.builder(
            //要点1
            physics: NeverScrollableScrollPhysics(), //禁止页面左右滑动切换
            controller: _pageController,
//          onPageChanged: _pageChanged,//回调函数
            itemCount: pages.length,
            itemBuilder: (context, index) => pages[index]),
        bottomNavigationBar: BottomNavigationBar(
//        elevation: 1,
          selectedFontSize: 12,
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
              _pageController.jumpToPage(val);
            });
          },
        ),
      ),
    );
  }
}
