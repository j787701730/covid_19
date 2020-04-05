import 'package:covid19/style.dart';
import 'package:dio/dio.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';

final baseUrl = 'http://49.232.173.220:3001/';

ajaxSimple(String url, data, Function fun, {Function netError}) async {
  var dio = Dio();
  try {
    Response res = await dio.get(
      "$baseUrl$url",
//      data: data,
      options: Options(
        contentType: Headers.formUrlEncodedContentType,
        headers: {
          'X-Requested-With': 'XMLHttpRequest',
        },
      ),
    );
    fun(res.data);
  } on DioError catch (e) {
    if (netError != null) {
      netError(e);
    }
//    print(e);
    Fluttertoast.showToast(
      msg: '$e',
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
    );
    if (e.response != null) {
//        print(e.response.data);
//        print(e.response.headers);
//        print(e.response.request);
//        print(e.response.statusCode);
      //  this.data,
      //  this.headers,
      //  this.request,
      //  this.isRedirect,
      //  this.statusCode,
      //  this.statusMessage,
      //  this.redirects,
      //  this.extra,
    } else {
      // Something happened in setting up or sending the request that triggered an Error
//       print(e.request.connectTimeout);
//       print(e.message);
    }

    // Toast.show('$e', _context, duration: Toast.LENGTH_LONG, gravity: Toast.CENTER);
  }
}

numText(num) {
  Color color;
  if (!(num is int)) {
    num = 0;
  }
  if (num == 0) {
    color = Colors.grey;
  } else if (num > 0) {
    color = Colors.red;
  } else {
    color = Colors.green;
  }
  return Text(
    '${num >= 0 ? '+$num' : num}',
    style: TextStyle(
      color: color,
    ),
  );
}
