import 'package:flutter/material.dart';
import '../models/transaction.dart';
import 'package:intl/intl.dart';
import '../services/firebaseCRUD.dart';

typedef TransactionFunction = void Function(List<TransactionModel>);

class TransactionList extends StatefulWidget {

  final List<TransactionModel> transactions;
  final TransactionFunction switchToSeach;
  TransactionList(this.transactions, this.switchToSeach);

  @override
  State<TransactionList> createState() => _TransactionListState();
}

class _TransactionListState extends State<TransactionList> {

  Widget stackBehindDismiss(Color clr, Icon icn) {
    return Container(
      alignment: Alignment.centerRight,
      padding: EdgeInsets.only(right: 20.0),
      color: clr,
      child: icn,
    );
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 470,
      child: widget.transactions.isEmpty ? Column(children: <Widget>[
        Text(
          'No transactions added yet!',
          style: Theme.of(context).textTheme.headline6,
        ),
        Container(
            height: 200,
            child: Image.asset(
                'assets/images/waiting.png',
                fit: BoxFit.cover
            )
        )
      ],
      )
          :ListView.builder(
        itemBuilder: (ctx, index) {

          return Dismissible(
            background: stackBehindDismiss(Colors.red, Icon(Icons.delete, color: Colors.white,)),
            key: UniqueKey(),
            direction: DismissDirection.endToStart,
            onDismissed: (direction){
              setState((){
                if (direction == DismissDirection.endToStart) {
                  FirebaseCRUD.deleteTransaction(widget.transactions[index].id);
                  widget.transactions.removeAt(index);
                  widget.switchToSeach(widget.transactions);
                }
              });
            },
            child: Card(
              elevation: 5,
              margin: const EdgeInsets.symmetric(
                vertical: 8,
                horizontal: 5,
              ),
              child: ListTile(
                leading: CircleAvatar(
                  radius: 30,
                  child: Padding(
                    padding: EdgeInsets.all(5),
                    child: FittedBox
                      (child: Text('\$${widget.transactions[index].amount}')),
                  ),
                ),
                title: Text(
                  widget.transactions[index].title,
                  style: Theme.of(context).textTheme.headline6,
                ),
                subtitle: Text(
                    DateFormat.yMMMd().format(widget.transactions[index].date)
                ),
              ),
            ),
          );
        },
        itemCount: widget.transactions.length,
      ),
    );

  }
}
