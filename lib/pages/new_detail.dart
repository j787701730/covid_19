import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

class NewDetail extends StatelessWidget {
  final props;
  final index;

  NewDetail({@required this.props, @required this.index});

  @override
  Widget build(BuildContext context) {
    return WebviewScaffold(
      appBar: AppBar(
        title: Text('${props['title']}'),
      ),
      url: props[index],
    );
  }
}
