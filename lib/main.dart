
import 'dart:ui';

import 'package:expenses_app/widgets/new_transaction.dart';
import 'package:expenses_app/widgets/transaction_list.dart';
import 'package:flutter/material.dart';
import 'package:expenses_app/models/transaction.dart';
import 'package:expenses_app/widgets/chart.dart';


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
      home: MyHomePage(),
    );
  }
}



class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();

}

class _MyHomePageState extends State<MyHomePage> {


  GlobalKey<ChartState> globalKeyChart = GlobalKey<ChartState>();

  List<Transaction> _userTransactions = [
    /*Transaction(
        id: 't1', title: 'New Shoes', amount: 69.99, date: DateTime.now()),
    Transaction(
      id: 't2',
      title: 'Groceries',
      amount: 16.75,
      date: DateTime.now(),
    ),*/
  ];

  List<Transaction>? get _recentTransations{
    return _userTransactions.where((tx) {
      return tx.date.isAfter(
          DateTime.now().subtract(
              Duration(days: 7)
          ),
      );
    }).toList();
  }

  void _addNewTransaction(String txTitle, double txAmount, DateTime chosenDate){
    final newTx = Transaction(
      title: txTitle,
      amount: txAmount,
      date: chosenDate,
      id: DateTime.now().toString(),
    );

    setState( () {
      _userTransactions.add(newTx);
    });
  }
  void _startAddNewTransaction(BuildContext ctx){
      showModalBottomSheet(context: ctx, builder: (_){
        return NewTransaction(_addNewTransaction);
      },);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Personal Expenses'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () =>_startAddNewTransaction(context),
          )
        ],
      ),
      body:SingleChildScrollView(
        child: GestureDetector(
          onTap: (){
            WidgetsBinding.instance?.focusManager.primaryFocus?.unfocus();

          },
          child: Column(
              //mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Chart(_userTransactions, key: globalKeyChart),
                TransactionList(_userTransactions,
                        (List<Transaction> localTransactions){
                  _userTransactions = localTransactions;
                  globalKeyChart.currentState?.updateRecentTransaction(_userTransactions);
                  setState(() {

                  });
                }
                )
              ],
            ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat ,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
          onPressed: () =>_startAddNewTransaction(context)
      ) ,
    );
  }
}
