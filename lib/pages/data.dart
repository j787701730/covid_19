import 'dart:async';

import 'package:covid19/primary_button.dart';
import 'package:covid19/style.dart';
import 'package:covid19/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class Data extends StatefulWidget {
  @override
  _DataState createState() => _DataState();
}

class _DataState extends State<Data> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  Map logs = {};
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
    Timer(Duration(milliseconds: 200), () {
      getData();
    });
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  getData({isRefresh: false}) async {
    ajaxSimple('data/getStatisticsService', {}, (res) {
      if (mounted) {
        setState(() {
          logs = res ?? {};
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

  numText(num) {
    Color color;
    if (num == 0) {
      color = Colors.grey;
    } else if (num > 0) {
      color = Colors.red;
    } else {
      color = Colors.green;
    }
    return Text(
      '${num > 0 ? '+$num' : num}',
      style: TextStyle(
        color: color,
      ),
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
        title: Text('统计信息'),
        actions: <Widget>[Container()],
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
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              margin: EdgeInsets.only(bottom: 10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(
                                    '全国统计',
                                    style: TextStyle(
                                      fontSize: FontSize.title,
                                    ),
                                  ),
                                  Text(
                                    '${DateTime.fromMillisecondsSinceEpoch(logs['modifyTime']).toString().substring(0, 19)}',
                                    style: TextStyle(
                                      fontSize: FontSize.title,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              child: Row(
                                children: <Widget>[
                                  Expanded(
                                    child: Column(
                                      children: <Widget>[
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: <Widget>[
                                            Text('较上日 '),
                                            numText(logs['confirmedIncr']),
                                          ],
                                        ),
                                        Text(
                                          '${logs['confirmedCount']}',
                                          style: TextStyle(
                                            color: Colors.red,
                                            fontSize: FontSize.title,
                                          ),
                                        ),
                                        Text('累计确诊'),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: Column(
                                      children: <Widget>[
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: <Widget>[
                                            Text('较上日 '),
                                            numText(logs['currentConfirmedIncr']),
                                          ],
                                        ),
                                        Text(
                                          '${logs['currentConfirmedCount']}',
                                          style: TextStyle(
                                            color: Colors.red,
                                            fontSize: FontSize.title,
                                          ),
                                        ),
                                        Text('当前确诊'),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: Column(
                                      children: <Widget>[
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: <Widget>[
                                            Text('较上日 '),
                                            numText(logs['suspectedIncr']),
                                          ],
                                        ),
                                        Text(
                                          '${logs['suspectedCount']}',
                                          style: TextStyle(
                                            color: Colors.yellow,
                                            fontSize: FontSize.title,
                                          ),
                                        ),
                                        Text('疑似'),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(top: 15),
                              child: Row(
                                children: <Widget>[
                                  Expanded(
                                    child: Column(
                                      children: <Widget>[
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: <Widget>[
                                            Text('较上日 '),
                                            numText(logs['deadIncr']),
                                          ],
                                        ),
                                        Text(
                                          '${logs['deadCount']}',
                                          style: TextStyle(
                                            color: Colors.grey,
                                            fontSize: FontSize.title,
                                          ),
                                        ),
                                        Text('死亡人数'),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: Column(
                                      children: <Widget>[
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: <Widget>[
                                            Text('较上日 '),
                                            numText(logs['seriousIncr']),
                                          ],
                                        ),
                                        Text(
                                          '${logs['seriousCount']}',
                                          style: TextStyle(
                                            color: Colors.red,
                                            fontSize: FontSize.title,
                                          ),
                                        ),
                                        Text('重症'),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: Column(
                                      children: <Widget>[
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: <Widget>[
                                            Text('较上日 '),
                                            numText(logs['curedIncr']),
                                          ],
                                        ),
                                        Text(
                                          '${logs['curedCount']}',
                                          style: TextStyle(
                                            color: Colors.green,
                                            fontSize: FontSize.title,
                                          ),
                                        ),
                                        Text('治愈'),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(
                                bottom: 10,
                                top: 15,
                              ),
                              child: Image.network('${logs['imgUrl']}'),
                            ),
                            Column(
                              children: logs['dailyPics'].map<Widget>(
                                (item) {
                                  return Container(
                                    margin: EdgeInsets.only(bottom: 10),
                                    child: Image.network('$item'),
                                  );
                                },
                              ).toList(),
                            ),
                            Column(
                              children: logs['quanguoTrendChart'].map<Widget>(
                                (item) {
                                  return Column(
                                    children: <Widget>[
                                      Container(
                                        padding: EdgeInsets.symmetric(vertical: 10),
                                        child: Text('${item['title']}'),
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(bottom: 10),
                                        child: Image.network('${item['imgUrl']}'),
                                      )
                                    ],
                                  );
                                },
                              ).toList(),
                            ),
                            Column(
                              children: logs['hbFeiHbTrendChart'].map<Widget>(
                                (item) {
                                  return Column(
                                    children: <Widget>[
                                      Container(
                                        padding: EdgeInsets.symmetric(vertical: 10),
                                        child: Text('${item['title']}'),
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(bottom: 10),
                                        child: Image.network('${item['imgUrl']}'),
                                      )
                                    ],
                                  );
                                },
                              ).toList(),
                            ),
                          ],
                        ),
                      ),
          ],
        ),
      ),
      floatingActionButton: CFFloatingActionButton(
        onPressed: toTop,
        heroTag: 'data',
        child: Icon(Icons.keyboard_arrow_up),
      ),
    );
  }
}
