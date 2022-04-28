import 'dart:ui';
import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:flutter/services.dart';
class NewTransaction extends StatefulWidget {

  final Function addTx;

  NewTransaction(this.addTx);

  @override
  State<NewTransaction> createState() => _NewTransactionState();
}

class _NewTransactionState extends State<NewTransaction> {
  final titleController = TextEditingController();

  final amountController = TextEditingController();

  FocusNode amountFocusNode = FocusNode();

  void submitDada(){
    final enteredTitle = titleController.text;
    double enteredAmount = 0.00;

    try{
      enteredAmount = double.parse(amountController.text);
    }catch(_){

    }
    if(enteredTitle.isEmpty || enteredAmount <= 0){
      ///Reminder: try add a Snackbar message for invalid inputs

        return;
    }

      widget.addTx(
        enteredTitle,
        enteredAmount,
      );
    Navigator.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Theme.of(context).primaryColorDark,
        duration: Duration(seconds: 3),
         content: Text('Item added!'),
    ));

  }

  bool functieVerificareValiditate(){
    final enteredTitle = titleController.text;
    double enteredAmount = 0.00;

    try{
      enteredAmount = double.parse(amountController.text);
    }catch(_){

    }
    if(enteredTitle.isNotEmpty && enteredAmount > 0){
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
              controller: titleController,
            ),
            TextField(
              decoration: InputDecoration(labelText: 'Amount'),
              focusNode: amountFocusNode,
              controller: amountController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true, signed: false),

              onSubmitted: (_) => submitDada(),
              onChanged: (_){
                setState(() {

                });
              },
              inputFormatters: [
                FilteringTextInputFormatter.deny(RegExp("[^0-9.-]")), DecimalTextInputFormatter(decimalRange: 2)]

            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  primary: (functieVerificareValiditate())?Theme.of(context).primaryColorDark : Theme.of(context).primaryColorLight),
              child: Text('Add Transaction'),

              onPressed: () => submitDada(),
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