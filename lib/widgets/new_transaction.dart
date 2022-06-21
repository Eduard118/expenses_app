import 'dart:ui';
import 'package:expensesapp/models/transaction.dart';
import 'package:expensesapp/services/firebaseCRUD.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import '../services/globals.dart';

class NewTransaction extends StatefulWidget {

  final Function addTx;

  NewTransaction(this.addTx);

  get transactions => null;

  @override
  State<NewTransaction> createState() => _NewTransactionState();
}

class _NewTransactionState extends State<NewTransaction> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();


  FocusNode amountFocusNode = FocusNode();

  bool dateWasSelectedFlag = false;
  DateTime? _selectedDate;

  Future<void> _submitData() async{
    final enteredTitle = _titleController.text;
    double enteredAmount = 0.00;

    try{
      enteredAmount = double.parse(_amountController.text);
    }catch(_){
      if (kDebugMode) {
        print(_.toString());
      }
    }
    if(enteredTitle.isEmpty || enteredAmount <= 0 || _selectedDate == null){
      return;
    }

    try{
      TransactionModel transaction = await FirebaseCRUD.createTransaction(Globals.email,
          TransactionModel(title: enteredTitle, amount: enteredAmount, date: _selectedDate!, nowDate: DateTime.now()));

      await widget.addTx(
          transaction.title,
          transaction.amount,
          transaction.date,
          transaction.id
      );
    }catch(_){
      if (kDebugMode) {
        print(_.toString());
      }
    }


    Navigator.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
      backgroundColor: Theme.of(context).primaryColorDark,
      duration: Duration(seconds: 3),
      content: Text('Item added!'),
          action: SnackBarAction(
            label: 'UNDO',
              textColor: Theme.of(context).colorScheme.secondary,
              onPressed: () {

              }
          ),
    ));


  }

  Future<void> _presentDatePicker()async{
    DateTime? res = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2050),
    );

    if(res == null){
      return;
    }
    setState(() {
      _selectedDate = res;
      dateWasSelectedFlag = true;
    });
  }

  bool functieVerificareValiditate(){
    final enteredTitle = _titleController.text;
    double enteredAmount = 0.00;

    try{
      enteredAmount = double.parse(_amountController.text);
    }catch(_){

    }
    if(enteredTitle.isNotEmpty && enteredAmount > 0 && dateWasSelectedFlag == true){
      return true;
    }
    return false;
  }



  @override
  Widget build(BuildContext context) {
    return  Card(
      elevation: 5,
      child: Container(
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            TextField(
              decoration: InputDecoration(labelText: 'Title'),
              onSubmitted: (_) => amountFocusNode.requestFocus(),
              onChanged: (_){
                setState(() {

                });
              },
              controller: _titleController,
            ),
            TextField(
                decoration: InputDecoration(labelText: 'Amount'),
                focusNode: amountFocusNode,
                controller: _amountController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true, signed: false),

               /* onSubmitted: (_) async{
                  await _submitData();
                },*/
              /*  onChanged: (_)async{
                  await _submitData();
                },*/
                inputFormatters: [
                  FilteringTextInputFormatter.deny(RegExp("[^0-9.-]")), DecimalTextInputFormatter(decimalRange: 2)]
            ),
            Container(
              padding: const EdgeInsets.only(top: 10, bottom: 10),

              child: Row(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 10, 0, 5),
                    child: Text(_selectedDate == null
                        ? 'No date chosen!'
                        : 'Picked date: ${DateFormat("dd MMM yyyy").format(_selectedDate!)}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Row(
              children: [
                ElevatedButton(
                  child: const Text('Choose a date',
                    style: TextStyle(
                        fontWeight: FontWeight.bold),
                  ),
                  onPressed: () async{
                    await _presentDatePicker();
                    setState(() {

                    });
                    ///Cod alegere data cu return type pe .pop({"flag" : date != null, "retVal" : date})
                    // var res;
                    // try{
                    //   dateWasSelectedFlag = res["flag"];
                    // }
                    // catch(_){
                    //   dateWasSelectedFlag = false;
                    // }
                    //
                    // if(dateWasSelectedFlag){
                    //   ///Move date of "retVal" in class variable
                    // }
                  },
                ),
                const Expanded(child: SizedBox(
                ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      primary: (functieVerificareValiditate())?Theme.of(context).primaryColorDark : Theme.of(context).primaryColorLight),
                  child: Text('Add Transaction'),
                  onPressed: () async{
                    await _submitData();
                       setState(() {

                    });
                  },
                ),
              ],
            ),

          ],
        ),
      ),
    );
  }
}



class DecimalTextInputFormatter extends TextInputFormatter {
  DecimalTextInputFormatter({required this.decimalRange})
      : assert(decimalRange == null || decimalRange > 0);

  final int decimalRange;

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, // unused.
      TextEditingValue newValue,
      ) {
    TextSelection newSelection = newValue.selection;
    String truncated = newValue.text;

    if (decimalRange != null) {
      String value = newValue.text;

      if (value.contains(".") &&
          value.substring(value.indexOf(".") + 1).length > decimalRange) {
        truncated = oldValue.text;
        newSelection = oldValue.selection;
      } else if (value == ".") {
        truncated = "0.";

        newSelection = newValue.selection.copyWith(
          baseOffset: math.min(truncated.length, truncated.length + 1),
          extentOffset: math.min(truncated.length, truncated.length + 1),
        );
      }

      return TextEditingValue(
        text: truncated,
        selection: newSelection,
        composing: TextRange.empty,
      );
    }
    return newValue;
  }
}