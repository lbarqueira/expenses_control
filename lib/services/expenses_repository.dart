import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expenses_control/models/expense.dart';
import 'package:flutter/foundation.dart';

class ExpensesRepository {
//TODO this repository depends on the user.Id so we have to have a constructer
//! Very important: the queryByCategory has been acomplished by
//! using Firestore Indexes, more speficically because we have an
//! oderBy() with a where()
  Stream<QuerySnapshot> queryByCategory(
      {@required int year, int month, String categoryName, String userUid}) {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(userUid)
        .collection('expenses')
        .where('year', isEqualTo: year)
        .where('month', isEqualTo: month)
        .where('category', isEqualTo: categoryName)
        .orderBy('day', descending: true)
        .snapshots();
  }

  Stream<QuerySnapshot> queryByMonth(
      {@required int year, int month, String userUid}) {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(userUid)
        .collection('expenses')
        .where('year', isEqualTo: year)
        .where('month', isEqualTo: month)
        .snapshots();
  }

  Stream<QuerySnapshot> queryByYear({@required int year, String userUid}) {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(userUid)
        .collection('expenses')
        .where('year', isEqualTo: year)
        .snapshots();
  }

  delete({String documentId, String userUid}) {
    FirebaseFirestore.instance
        .collection('users')
        .doc(userUid)
        .collection('expenses')
        .doc(documentId)
        .delete();
  }

  add(String categoryName, double value, DateTime date, String userUid) {
    FirebaseFirestore.instance
        .collection('users')
        .doc(userUid)
        .collection('expenses')
        .doc()
        .set(
      {
        'category': categoryName,
        'value': value,
        'year': date.year,
        'month': date.month,
        'day': date.day,
      },
    );
  }

  updateExpense(
      String categoryName, double value, String userUid, String documentId) {
    FirebaseFirestore.instance
        .collection('users')
        .doc(userUid)
        .collection('expenses')
        .doc(documentId)
        .update(
      {
        'category': categoryName,
        'value': value,
      },
    );
  }

  //Get one record from Id as Future
  Future<Expense> getOneFuture(String documentId, String userUid) {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(userUid)
        .collection('expenses')
        .doc(documentId)
        .get()
        .then(
          (snapshot) => Expense.fromJson(snapshot.data()),
        );
  }
}
