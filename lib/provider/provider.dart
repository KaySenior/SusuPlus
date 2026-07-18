import 'package:cloud_firestore/cloud_firestore.dart' hide Transaction;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import '../models/transaction.dart';

class TransactionsProvider extends ChangeNotifier {
  List<Transaction> _transactions = [];
  double _balance = 0.0;

  List<Transaction> get transactions => _transactions;
  bool get hasTransactions => _transactions.isNotEmpty;
  double get balance => _balance;

  TransactionsProvider() {
    FirebaseAuth.instance.authStateChanges().listen((user) {
      if (user != null) {
        fetchTransactions();
      } else {
        loadTransactions([]);
      }
    });
  }

  void loadTransactions(List<Transaction> txs) {
    _transactions = txs;
    _balance = txs.fold(0.0, (total, tx) => total + tx.amount);
    notifyListeners();
  }

  Future<void> addTransaction(Transaction tx) async {
    _transactions = [..._transactions, tx];
    _balance += tx.amount;
    notifyListeners();

    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('transactions')
          .doc(tx.id)
          .set({
        'id': tx.id,
        'title': tx.title,
        'amount': tx.amount,
        'date': tx.date.toIso8601String(),
      });
    }
  }

  Future<void> fetchTransactions() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('transactions')
          .orderBy('date', descending: true)
          .get();

      final txs = snapshot.docs.map((doc) {
        final data = doc.data();
        return Transaction(
          id: data['id'] as String,
          title: data['title'] as String,
          amount: (data['amount'] as num).toDouble(),
          date: DateTime.parse(data['date'] as String),
        );
      }).toList();

      loadTransactions(txs);
    } catch (e) {
      debugPrint('fetchTransactions error: $e');
    }
  }
}
