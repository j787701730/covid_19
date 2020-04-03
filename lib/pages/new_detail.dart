import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

class NewDetail extends StatelessWidget {
  final props;

  NewDetail(this.props);

  @override
  Widget build(BuildContext context) {
    print(props['sourceUrl']);
    return WebviewScaffold(
      appBar: AppBar(
        title: Text('${props['title']}'),
      ),
      url: props['sourceUrl'],
    );
  }
}
