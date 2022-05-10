import 'package:expensesapp/services/notification_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'loginPages/login.dart';
import 'package:expensesapp/services/notification_service_implmnt.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await NotificationService().init();
  runApp(MyApp());
}

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




