import 'dart:async';

import 'package:covid19/primary_button.dart';
import 'package:covid19/style.dart';
import 'package:covid19/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class GuoWaiData extends StatefulWidget {
  @override
  _GuoWaiDataState createState() => _GuoWaiDataState();
}

class _GuoWaiDataState extends State<GuoWaiData> {
  List logs = [];
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
    ajaxSimple('data/getListByCountryTypeService2true', {}, (res) {
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
        color: Color(0xfff5f5f5),
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

  @override
  Widget build(BuildContext context) {
//    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top - 56 * 2;
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('全球国家具体数据'),
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
          padding: EdgeInsets.symmetric(vertical: 10),
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
                          children: logs.map<Widget>((item) {
                            return Container(
                              color: Colors.white,
                              margin: EdgeInsets.only(left: 16, right: 10, bottom: 10),
                              child: Column(
                                children: <Widget>[
                                  Container(
                                    padding: EdgeInsets.only(left: 12, right: 12, top: 12),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Text(
                                          '${item['provinceName']}',
                                          style: TextStyle(
                                            fontSize: FontSize.title,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          '${item['modifyTime'] == null ? '无' : DateTime.fromMillisecondsSinceEpoch(item['modifyTime']).toString().substring(0, 19)}',
                                          style: TextStyle(
                                            fontSize: FontSize.title,
                                            color: Colors.grey,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.symmetric(vertical: 6),
                                    margin: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                    child: Row(
                                      children: <Widget>[
                                        Expanded(
                                          child: numCard(
                                              item['incrVo'] == null || item['incrVo'].isEmpty
                                                  ? 0
                                                  : item['incrVo']['currentConfirmedIncr'],
                                              item['confirmedCount'],
                                              '累计确诊'),
                                        ),
                                        Container(
                                          width: 10,
                                        ),
                                        Expanded(
                                          child: numCard(
                                              item['incrVo'] == null || item['incrVo'].isEmpty
                                                  ? 0
                                                  : item['incrVo']['confirmedIncr'],
                                              item['currentConfirmedCount'],
                                              '当前确诊'),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(left: 12, right: 12, bottom: 6),
                                    child: Row(
                                      children: <Widget>[
                                        Expanded(
                                          child: numCard(
                                              item['incrVo'] == null || item['incrVo'].isEmpty
                                                  ? 0
                                                  : item['incrVo']['curedIncr'],
                                              item['curedCount'],
                                              '累计治愈'),
                                        ),
                                        Container(
                                          width: 10,
                                        ),
                                        Expanded(
                                          child: numCard(
                                              item['incrVo'] == null || item['incrVo'].isEmpty
                                                  ? 0
                                                  : item['incrVo']['deadIncr'],
                                              item['deadCount'],
                                              '累计死亡'),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(left: 12, right: 12, bottom: 12, top: 6),
                                    child: Row(
                                      children: <Widget>[
                                        Expanded(
                                          child: Container(
                                            padding: EdgeInsets.all(8),
                                            decoration: BoxDecoration(
                                              color: Color(0xfff5f5f5),
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(4),
                                              ),
                                            ),
                                            child: Column(
                                              children: <Widget>[
                                                Container(
                                                  padding: EdgeInsets.only(bottom: 4),
                                                  child: Text(
                                                    '${item['deadRate']}',
                                                    style: TextStyle(
                                                      color: Colors.grey,
                                                      fontSize: FontSize.topTitle,
                                                    ),
                                                  ),
                                                ),
                                                Text('死亡率'),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        ),
                      ),
          ],
        ),
      ),
      floatingActionButton: CFFloatingActionButton(
        onPressed: toTop,
        heroTag: 'guo_wai_data',
        child: Icon(Icons.keyboard_arrow_up),
      ),
    );
  }
}
