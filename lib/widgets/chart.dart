import 'dart:async';

import 'package:expensesapp/models/transaction.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'chart_bar.dart';

class Chart extends StatefulWidget {
  List<TransactionModel> recentTransactions;

  Chart(this.recentTransactions, {required Key key}) : super(key: key);

  @override
  State<Chart> createState() => ChartState();
}

class ChartState extends State<Chart> {

  late List<TransactionModel> recentTransactions;

  late Timer t;
  @override
  void initState() {
    recentTransactions = widget.recentTransactions;

    t = Timer.periodic(Duration(seconds: 1), (timer) {
      callSetState();
    });
  }


  @override
  void dispose(){
    super.dispose();
    t.cancel();
  }

  void updateRecentTransaction(List<TransactionModel> auxTrans){
    setState((){
      recentTransactions = auxTrans;
    });
  }
  void callSetState(){
    setState((){
      print(recentTransactions.length.toString());
    });
  }

  List<Map<String, dynamic>> get groupedTrnsactionValues{
    return List.generate(7, (index) {
      final weekDay = DateTime.now().subtract(
          Duration(days: index)
      );
      double totalSum = 0.0;

      for( var i = 0; i < recentTransactions.length; i++){
        if(recentTransactions[i].date.day == weekDay.day &&
            recentTransactions[i].date.month == weekDay.month &&
            recentTransactions[i].date.year == weekDay.year){
          totalSum += recentTransactions[i].amount;
        }
      }

      return {
        'day': DateFormat.E().format(weekDay).substring(0, 1),
        'amount': totalSum};
    }).reversed.toList();
  }

  double get totalSpending{
    return groupedTrnsactionValues.fold(0.0, (sum, item){
      return sum + item['amount'];
    });
  }



  @override
  Widget build(BuildContext context) {
    print(groupedTrnsactionValues);

    return Card(
      elevation: 6,
      margin: EdgeInsets.all(20),
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: groupedTrnsactionValues.map((data){
             double spendingPctOfTotal = 0.00;
               if(totalSpending != 0.00){
                 spendingPctOfTotal = data['amount'] / totalSpending;
               }
            //return  Container(
             // width: 25,
               // height: 100,
                return Flexible(
                  fit: FlexFit.tight,
                    child: ChartBar(
                        data['day'],
                        data['amount'],
                        spendingPctOfTotal
                    )
                );
           // );
          }).toList(),
        ),
      ),
    );
  }
}
