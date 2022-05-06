import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expensesapp/services/globals.dart';

import '../models/transaction.dart';
import 'auth.dart';

class FirebaseCRUD {
  var databaseReference = FirebaseFirestore.instance;

  static Future createTransaction(String nameOfDoc, TransactionModel transaction) async {

    //await AuthService().signInWithEmailAndPassword(Globals.email, Globals.password);

    var databaseReference = FirebaseFirestore.instance;



      DocumentReference ref;
      try{
        ref = await databaseReference.collection(nameOfDoc).add(transaction.toJson());
        transaction.id = ref.id;
      }
      catch(_){
        print(_.toString());
      }
    return transaction;
  }


  static Future<QuerySnapshot> getAllDocumentsFromCollection ()async{


    var databaseReference = FirebaseFirestore.instance;

    QuerySnapshot querySnapshot = await databaseReference.collection(Globals.email).get();
    return querySnapshot;
  }

  static Future<void> deleteTransaction(String id)async {
    var databaseReference = FirebaseFirestore.instance;
    await databaseReference.collection(Globals.email).doc(id).delete();
  }
}