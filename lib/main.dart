
import 'dart:ui';
import 'package:expensesapp/main.dart';
import 'package:flutter/material.dart';

import 'LoginPages/login.dart';



void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Expenses App',
      theme: ThemeData(
        primarySwatch: Colors.purple,
        accentColor: Colors.amber,
        fontFamily: 'Quicksand',
          textTheme: ThemeData.light().textTheme.copyWith(
            headline6: TextStyle(
              fontFamily: 'OpenSans',
              fontWeight: FontWeight.bold,
              fontSize: 18,
            )
          ),
          appBarTheme: AppBarTheme(
            toolbarTextStyle: ThemeData.light().textTheme.copyWith(
                headline6: const TextStyle(
                    fontFamily: 'OpenSans',
                    fontSize:20,
                    fontWeight: FontWeight.bold
                )
            ).bodyText2, titleTextStyle: ThemeData.light().textTheme.copyWith(
                headline6: const TextStyle(
                    fontFamily: 'OpenSans',
                    fontSize:20,
                  fontWeight: FontWeight.bold

                )
            ).headline6,
          ),
      ),
      home: const Login(),
    );
  }
}




