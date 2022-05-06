import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

class TransactionModel{
  late String id = "";
  late String title;
  late double amount;
  late DateTime date;
  late DateTime nowDate = DateTime.now();

  TransactionModel({
    required this.title,
    required this.amount,
    required this.date,
    required this.nowDate
  });

  Map <String, dynamic> toJson(){
    Map<String, dynamic> addToFbMap ={
      'date': date,
      'title': title,
      'amount' : amount,
      'nowDate': nowDate
    };

    return addToFbMap;
  }

  TransactionModel.fromJson(Map <String, dynamic> val){
    title = val['title'];
    amount = val['amount'];
    try{
      date = DateTime.fromMillisecondsSinceEpoch((val['date'] as Timestamp).millisecondsSinceEpoch);
      nowDate = DateTime.fromMillisecondsSinceEpoch((val['nowDate'] as Timestamp).millisecondsSinceEpoch);

    } catch(_){
        print(_);
    }

  }
}