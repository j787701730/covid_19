import 'dart:async';

import 'package:covid19/pages/new_detail.dart';
import 'package:covid19/primary_button.dart';
import 'package:covid19/style.dart';
import 'package:covid19/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class WikiList extends StatefulWidget {
  @override
  _WikiListState createState() => _WikiListState();
}

class _WikiListState extends State<WikiList> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

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
    ajaxSimple('data/getWikiList', {}, (res) {
      if (mounted) {
        setState(() {
          // todo 分页
          logs = res['result'] ?? [];
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
        title: Text('知识百科'),
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
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: logs.map<Widget>((item) {
                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  _context,
                                  MaterialPageRoute(
                                    builder: (context) => NewDetail(
                                      props: item,
                                      index: 'linkUrl',
                                    ),
                                  ),
                                );
                              },
                              behavior: HitTestBehavior.opaque,
                              child: Container(
                                margin: EdgeInsets.only(bottom: 16),
                                padding: EdgeInsets.symmetric(horizontal: 10),
                                decoration: BoxDecoration(
                                  color: Colors.white,
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
                                    item['description'] == ''
                                        ? Container()
                                        : Container(
                                      padding: EdgeInsets.symmetric(vertical: 6),
                                      child: Text(
                                        '${item['description']}',
                                        style: TextStyle(
                                          fontSize: FontSize.tabBar,
                                          color: CColors.gray,
                                        ),
                                      ),
                                    ),
                                    item['imgUrl'] == '' || item['imgUrl'] == null
                                        ? Container()
                                        : Image.network('${item['imgUrl']}'),
                                    Container(
                                      padding: EdgeInsets.symmetric(vertical: 10),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Text(
                                            ' ',
                                            style: TextStyle(
                                              fontSize: FontSize.content,
                                              color: CColors.gray,
                                            ),
                                          ),
                                          Text(
                                            '评分：${item['sort']}',
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
                      ),
          ],
        ),
      ),
      floatingActionButton: CFFloatingActionButton(
        onPressed: toTop,
        heroTag: 'wiki',
        child: Icon(Icons.keyboard_arrow_up),
      ),
    );
  }
}
