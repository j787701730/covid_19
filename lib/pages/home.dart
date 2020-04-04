import 'dart:async';

import 'package:covid19/pages/new_detail.dart';
import 'package:covid19/primary_button.dart';
import 'package:covid19/style.dart';
import 'package:covid19/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  List logs = [];
  int count = 0;
  BuildContext _context;
  ScrollController _controller;
  bool loading = true;
  RefreshController _refreshController = RefreshController(initialRefresh: false);
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  void _onRefresh() async {
    setState(() {
      getData(isRefresh: true);
    });
  }

//  void _onLoading() async{
//    // monitor network fetch
//    await Future.delayed(Duration(milliseconds: 1000));
//    // if failed,use loadFailed(),if no data return,use LoadNodata()
////    items.add((items.length+1).toString());
//    if(mounted)
//      setState(() {
//
//      });
//    _refreshController.loadComplete();
//  }

  @override
  void initState() {
    super.initState();
    _controller = ScrollController();
    _context = context;
//    Timer(Duration(milliseconds: 200), () {
    getData();
//    });
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  getData({isRefresh: false}) async {
    ajaxSimple('data/getTimelineService', {}, (res) {
      if (mounted) {
        setState(() {
          logs = res ?? [];
          toTop();
          loading = false;
        });
        if (isRefresh) {
          _refreshController.refreshCompleted();
        }
      }
    });
  }

  toTop() {
    _controller.animateTo(
      0,
      duration: new Duration(milliseconds: 300), // 300ms
      curve: Curves.bounceIn, // 动画方式
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
//    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top - 56 * 2;
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('新闻'),
      ),
      backgroundColor: Color(0xffF7F7F7),
      body: SmartRefresher(
        enablePullDown: true,
        enablePullUp: false,
        header: WaterDropHeader(
          complete: Text(
            '加载成功',
            style: TextStyle(
              color: CColors.gray,
            ),
          ),
          failed: Text(
            '加载失败',
            style: TextStyle(
              color: CColors.gray,
            ),
          ),
        ),
        controller: _refreshController,
        onRefresh: _onRefresh,
//          onLoading: _onLoading,
        child: ListView(
          controller: _controller,
          children: <Widget>[
            loading
                ? Container(
                    height: height,
                    child: CupertinoActivityIndicator(),
                  )
                : logs.isEmpty
                    ? Container(
                        color: Colors.white,
                        alignment: Alignment.topCenter,
                        child: Text('无数据'),
                      )
                    //
                    : Container(
                        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        child: Column(
                          children: <Widget>[
                            Container(
                              padding: EdgeInsets.symmetric(vertical: 6),
                              alignment: Alignment.centerRight,
                              child: Text('更新于：${DateTime.now().toString().substring(0, 19)}'),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: logs.map<Widget>((item) {
                                return GestureDetector(
                                  behavior: HitTestBehavior.opaque,
                                  onTap: () {
                                    Navigator.push(
                                      _context,
                                      MaterialPageRoute(
                                        builder: (context) => NewDetail(
                                          props: item,
                                          index: 'sourceUrl',
                                        ),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    margin: EdgeInsets.only(bottom: 16),
                                    padding: EdgeInsets.symmetric(horizontal: 10),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
//                                border: Border.all(
//                                  color: Color(0xffdddddd),
//                                  width: 0.5,
//                                ),
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(2),
                                      ),
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Container(
                                          padding: EdgeInsets.symmetric(vertical: 10),
                                          child: Text(
                                            '${item['title']}',
                                            style: TextStyle(
                                              fontSize: FontSize.title,
                                            ),
                                          ),
                                        ),
                                        Text(
                                          '${item['summary']}',
                                          style: TextStyle(
                                            fontSize: FontSize.content,
                                            color: CColors.gray,
                                          ),
                                        ),
                                        Container(
                                          padding: EdgeInsets.symmetric(vertical: 10),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: <Widget>[
                                              Text(
                                                '时间：${item['pubDateStr']}',
                                                style: TextStyle(
                                                  fontSize: FontSize.content,
                                                  color: CColors.gray,
                                                ),
                                              ),
                                              Text(
                                                '来源：${item['infoSource']}',
                                                style: TextStyle(
                                                  fontSize: FontSize.content,
                                                  color: CColors.gray,
                                                ),
                                              ),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          ],
                        ),
                      ),
          ],
        ),
      ),
      floatingActionButton: CFFloatingActionButton(
        onPressed: toTop,
        heroTag: 'home',
        child: Icon(Icons.keyboard_arrow_up),
      ),
    );
  }
}
