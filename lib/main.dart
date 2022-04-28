
import 'dart:ui';

import 'package:expenses_app/widgets/new_transaction.dart';
import 'package:expenses_app/widgets/transaction_list.dart';
import 'package:flutter/material.dart';
import 'package:expenses_app/models/transaction.dart';


void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Expenses App',
      theme: ThemeData(
        primarySwatch: Colors.purple,
            accentColor: Colors.amber,
          //fontFamily: 'OpenSans'
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

  final List<Transaction> _userTransactions = [
    Transaction(
        id: 't1', title: 'New Shoes', amount: 69.99, date: DateTime.now()),
    Transaction(
      id: 't2',
      title: 'Groceries',
      amount: 16.75,
      date: DateTime.now(),
    ),
  ];

  void _addNewTransaction(String txTitle, double txAmount){
    final newTx = Transaction(
      title: txTitle,
      amount: txAmount,
      date: DateTime.now(),
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
                Container(
                  width: double.infinity,
                  child: Card(
                    color: Theme.of(context).primaryColor,
                    child: Text('CHART!'),
                    elevation: 5,
                  ),
                ),
                TransactionList(_userTransactions)
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
