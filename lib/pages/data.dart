import 'dart:async';

import 'package:covid19/pages/guo_wai_data.dart';
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

  getData({isRefresh: false}) {
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

  numCard(incr, count, name) {
    Color color;
    if (name == '累计治愈') {
      color = Colors.green;
    } else if (name == '累计死亡') {
      color = Colors.grey;
    } else if (name == '累计疑似') {
      color = Colors.amber;
    } else {
      color = Colors.red;
    }
    return Container(
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(
          Radius.circular(4),
        ),
      ),
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text('较上日'),
              numText(incr),
            ],
          ),
          Container(
            padding: EdgeInsets.all(4),
            child: Text(
              '$count',
              style: TextStyle(
                color: color,
                fontSize: FontSize.topTitle,
              ),
            ),
          ),
          Text(name),
        ],
      ),
    );
  }

  int type = 1; // 1 国内, 2 国外

  @override
  Widget build(BuildContext context) {
    super.build(context);
//    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top - 56 * 2;
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('数据'),
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
                        child: Column(
                          children: <Widget>[
                            Container(
                              padding: EdgeInsets.all(8),
                              alignment: Alignment.center,
                              child: Text(
                                '全球疫情统计',
                                style: TextStyle(
                                  fontSize: FontSize.title,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                              alignment: Alignment.centerRight,
                              child: Text(
                                '更新时间：${DateTime.fromMillisecondsSinceEpoch(logs['modifyTime']).toString().substring(0, 19)}',
                                style: TextStyle(
                                  fontSize: FontSize.title,
                                ),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 16),
                              margin: EdgeInsets.only(bottom: 10),
                              child: Row(
                                children: <Widget>[
                                  Expanded(
                                    child: numCard(logs['globalStatistics']['confirmedIncr'],
                                        logs['globalStatistics']['confirmedCount'], '累计确诊'),
                                  ),
                                  Container(
                                    width: 10,
                                  ),
                                  Expanded(
                                    child: numCard(logs['globalStatistics']['currentConfirmedIncr'],
                                        logs['globalStatistics']['currentConfirmedCount'], '当前确诊'),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 16),
                              margin: EdgeInsets.only(bottom: 16),
                              child: Row(
                                children: <Widget>[
                                  Expanded(
                                    child: numCard(logs['globalStatistics']['curedIncr'],
                                        logs['globalStatistics']['curedCount'], '累计治愈'),
                                  ),
                                  Container(
                                    width: 10,
                                  ),
                                  Expanded(
                                    child: numCard(logs['globalStatistics']['deadIncr'],
                                        logs['globalStatistics']['deadCount'], '累计死亡'),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              color: Color(0xfff5f5f5),
                              padding: EdgeInsets.only(
                                bottom: 25,
                              ),
                              child: PrimaryButton(
                                onPressed: () {
                                  Navigator.push(
                                    _context,
                                    MaterialPageRoute(
                                      builder: (context) => GuoWaiData(),
                                    ),
                                  );
                                },
                                child: Text('全球国家具体数据'),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 16),
                              child: Row(
                                children: <Widget>[
                                  Expanded(
                                    child: GestureDetector(
                                      behavior: HitTestBehavior.opaque,
                                      child: Container(
                                        alignment: Alignment.center,
                                        padding: EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                            color: type == 1 ? CColors.white : Color(0xfff5f5f5),
                                            borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(6),
                                            )),
                                        child: Text(
                                          '国内疫情',
                                          style: TextStyle(
                                            color: type == 1 ? CColors.primary : CColors.text,
                                          ),
                                        ),
                                      ),
                                      onTap: () {
                                        setState(() {
                                          type = 1;
                                        });
                                      },
                                    ),
                                  ),
                                  Expanded(
                                    child: GestureDetector(
                                      behavior: HitTestBehavior.opaque,
                                      child: Container(
                                        decoration: BoxDecoration(
                                            color: type == 2 ? CColors.white : Color(0xfff5f5f5),
                                            borderRadius: BorderRadius.only(
                                              topRight: Radius.circular(6),
                                            )),
                                        alignment: Alignment.center,
                                        padding: EdgeInsets.all(8),
                                        child: Text(
                                          '国外疫情',
                                          style: TextStyle(
                                            color: type == 2 ? CColors.primary : CColors.text,
                                          ),
                                        ),
                                      ),
                                      onTap: () {
                                        setState(() {
                                          type = 2;
                                        });
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Offstage(
                              // 国内
                              offstage: type != 1,
                              child: Container(
                                color: Colors.white,
                                padding: EdgeInsets.symmetric(vertical: 6),
                                margin: EdgeInsets.symmetric(horizontal: 16),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    Container(
                                      color: Color(0xfff5f5f5),
                                      padding: EdgeInsets.symmetric(vertical: 6),
                                      child: Container(
                                        child: Row(
                                          children: <Widget>[
                                            Expanded(
                                              child: numCard(logs['confirmedIncr'], logs['confirmedCount'], '累计确诊'),
                                            ),
                                            Container(
                                              width: 10,
                                            ),
                                            Expanded(
                                              child: numCard(
                                                  logs['currentConfirmedIncr'], logs['currentConfirmedCount'], '当前确诊'),
                                            ),
                                            Container(
                                              width: 10,
                                            ),
                                            Expanded(
                                              child: numCard(logs['suspectedIncr'], logs['suspectedCount'], '累计疑似'),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Container(
                                      color: Color(0xfff5f5f5),
                                      padding: EdgeInsets.only(bottom: 10),
                                      child: Container(
                                        child: Row(
                                          children: <Widget>[
                                            Expanded(
                                              child: numCard(logs['seriousIncr'], logs['seriousCount'], '累计重症'),
                                            ),
                                            Container(
                                              width: 10,
                                            ),
                                            Expanded(
                                              child: numCard(logs['curedIncr'], logs['curedCount'], '累计治愈'),
                                            ),
                                            Container(
                                              width: 10,
                                            ),
                                            Expanded(
                                              child: numCard(logs['deadIncr'], logs['deadCount'], '累计死亡'),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Container(
                                      color: Color(0xfff5f5f5),
                                      margin: EdgeInsets.only(
                                        bottom: 10,
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
                                                margin: EdgeInsets.only(top: 10),
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
                                                margin: EdgeInsets.only(top: 10),
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
                            ),
                            Offstage(
                              // 国外
                              offstage: type != 2,
                              child: Container(
                                color: Colors.white,
                                padding: EdgeInsets.symmetric(vertical: 6),
                                margin: EdgeInsets.symmetric(horizontal: 16),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    Container(
                                      color: Color(0xfff5f5f5),
                                      padding: EdgeInsets.symmetric(vertical: 6),
                                      child: Row(
                                        children: <Widget>[
                                          Expanded(
                                            child: numCard(logs['foreignStatistics']['confirmedIncr'],
                                                logs['foreignStatistics']['confirmedCount'], '累计确诊'),
                                          ),
                                          Container(
                                            width: 10,
                                          ),
                                          Expanded(
                                            child: numCard(logs['foreignStatistics']['currentConfirmedIncr'],
                                                logs['foreignStatistics']['currentConfirmedCount'], '当前确诊'),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      color: Color(0xfff5f5f5),
                                      padding: EdgeInsets.only(bottom: 10),
                                      child: Row(
                                        children: <Widget>[
                                          Expanded(
                                            child: numCard(logs['foreignStatistics']['curedIncr'],
                                                logs['foreignStatistics']['curedCount'], '累计治愈'),
                                          ),
                                          Container(
                                            width: 10,
                                          ),
                                          Expanded(
                                            child: numCard(logs['foreignStatistics']['deadIncr'],
                                                logs['foreignStatistics']['deadCount'], '当前死亡'),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Column(
                                      children: logs['foreignTrendChart'].map<Widget>(
                                        (item) {
                                          return Column(
                                            children: <Widget>[
                                              Container(
                                                padding: EdgeInsets.symmetric(vertical: 10),
                                                child: Text('${item['title']}'),
                                              ),
                                              Container(
                                                margin: EdgeInsets.only(bottom: 15),
                                                child: Image.network('${item['imgUrl']}'),
                                              )
                                            ],
                                          );
                                        },
                                      ).toList(),
                                    ),
                                    Column(
                                      children: logs['importantForeignTrendChart'].map<Widget>(
                                        (item) {
                                          return Column(
                                            children: <Widget>[
                                              Container(
                                                padding: EdgeInsets.symmetric(vertical: 10),
                                                child: Text('${item['title']}'),
                                              ),
                                              Container(
                                                margin: EdgeInsets.only(bottom: 15),
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
