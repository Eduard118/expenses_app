import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expensesapp/models/transaction.dart';
import 'package:expensesapp/widgets/chart.dart';
import 'package:expensesapp/widgets/new_transaction.dart';
import 'package:expensesapp/widgets/transaction_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../services/firebaseCRUD.dart';

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();

}

class _MyHomePageState extends State<MyHomePage> {


  GlobalKey<ChartState> globalKeyChart = GlobalKey<ChartState>();

  List<TransactionModel> _userTransactions = [];

  List<TransactionModel>? get _recentTransations {
    return _userTransactions.where((tx) {
      return tx.date.isAfter(
        DateTime.now().subtract(
            const Duration(days: 7)
        ),
      );
    }).toList();
  }

  void _addNewTransaction(String txTitle, double txAmount, DateTime chosenDate,
      String id) {
    TransactionModel newTx = TransactionModel(
      title: txTitle,
      amount: txAmount,
      date: chosenDate,
      nowDate: DateTime.now(),
    );

    newTx.id = id;
    setState(() {
      _userTransactions.add(newTx);
    });
  }

  Future <void> _startAddNewTransaction(BuildContext ctx) async{
    await showModalBottomSheet(context: ctx, builder: (_) {
      return
        NewTransaction(_addNewTransaction);
    },);
    setState(() {
      globalKeyChart.currentState?.updateRecentTransaction(_userTransactions);
    });
  }

  bool hasPassedInit = false;
  Future<bool> _getdata()async{

    if(!hasPassedInit){
      _userTransactions = [];
      QuerySnapshot res = await FirebaseCRUD.getAllDocumentsFromCollection();
      for(var document in res.docs){
        TransactionModel newTx = TransactionModel.fromJson((document.data() as Map<String, dynamic>));
        newTx.id = document.id;
        _userTransactions.add(newTx);
      }
    hasPassedInit = true;
      await Future.delayed(Duration(milliseconds: 1000));
    }
    return true;
  }
  @override
  Widget build(BuildContext context) {
    return FutureBuilder <bool>(
      future: _getdata(),
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot){

        if(snapshot.hasData){
          return Scaffold(
            appBar: AppBar(
              //automaticallyImplyLeading: false,

            leading: GestureDetector(
                onTap: (){
                  Navigator.of(context).pop();
                },
                child: Icon(Icons.logout)
            ),
              title: Text('Personal Expenses',
              style: TextStyle(
                  color: Theme.of(context).colorScheme.secondary,
                fontWeight: FontWeight.bold
              )),
              actions: <Widget>[
                /*IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () async{
                    await _startAddNewTransaction(context);
                  }
                )*/
              ],
            ),
            body: SingleChildScrollView(
              child: GestureDetector(
                onTap: () {
                  WidgetsBinding.instance?.focusManager.primaryFocus?.unfocus();
                },
                child: Column(
                  //mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Chart(
                        _userTransactions,
                        key: globalKeyChart
                    ),
                    TransactionList(_userTransactions,
                            (List<TransactionModel> localTransactions) {
                          setState(() {
                            _userTransactions = localTransactions;
                            globalKeyChart.currentState?.updateRecentTransaction(
                                _userTransactions);
                          });
                        }
                    )
                  ],
                ),
              ),
            ),
            floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
            floatingActionButton: FloatingActionButton(
                child: const Icon(Icons.add),
                onPressed: () async{

                  await _startAddNewTransaction(context);

                  setState((){
                  });
                }
            ),
          );
        }
        else if (snapshot.hasError){
          return
              Column(
                children: [ const Icon(
                  Icons.error_outline,
                  color: Colors.red,
                  size: 60,
                ),
                  Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: Text('Error: ${snapshot.error}'),
                  )],
              );
        }
        else {
          return Container(
            color: Color(0xffEBE8FC),
            child: Center(
                child:Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    SpinKitChasingDots(
                      color: Theme.of(context).colorScheme.secondary,
                      size: 50,
                    ),

                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Container(
                        //color: Colors.lightBlue[100],
                          child: Text("Loading",
                            style: TextStyle(
                                color: Theme.of(context).colorScheme.primary,
                                fontSize: 16 ,
                                decoration: TextDecoration.none,
                                //decoration: TextDecoration.none,
                                fontWeight: FontWeight.bold
                            ),)
                      ),
                    ),
                  ],
                )
            ),
          );
        }
      },
    );

  }
}