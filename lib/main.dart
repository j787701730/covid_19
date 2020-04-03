import 'package:covid19/style.dart';
import 'package:flutter/material.dart';
import 'package:covid19/app.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '新型冠状病毒肺炎',
      theme: ThemeData(
        platform: TargetPlatform.iOS,
        textTheme: TextTheme(
          subhead: TextStyle(
            textBaseline: TextBaseline.alphabetic, // TextField hintText 居中
            fontSize: FontSize.content,
          ),
          body1: TextStyle(
            fontSize: FontSize.content,
            color: Color(0xff333333),
          ),
          button: TextStyle(
            fontSize: FontSize.content,
            color: Color(0xff333333),
          ),
        ),
        primaryColor: CColors.primary,
        scaffoldBackgroundColor: Colors.white,
        primaryIconTheme: IconThemeData(
//          color: CColors.primary,
        ),
        iconTheme: IconThemeData(
          color: CColors.white,
        ),
        appBarTheme: AppBarTheme(
          elevation: 1,
          textTheme: TextTheme(
            title: TextStyle(
              fontSize: FontSize.topTitle,
              color: CColors.white,
            ),
          ),
          color: CColors.primary,
        ),
        buttonTheme: ButtonThemeData(
          height: 30,
          minWidth: 56,
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
        cursorColor: CColors.primary,
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: CColors.primary,
            ),
          ),
          prefixStyle: TextStyle(
            color: CColors.text,
          ),
        ),
        dialogTheme: DialogTheme(
          titleTextStyle: TextStyle(
            fontSize: FontSize.topTitle,
            color: CColors.text,
          ),
          contentTextStyle: TextStyle(
            fontSize: FontSize.content,
            color: CColors.text,
          ),
        ),
      ),
      debugShowCheckedModeBanner: false,
      home: MyHomePage(),
    );
  }
}
