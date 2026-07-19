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
    _balance = txs.fold(0.0, (total, tx) => total + (tx.status == 'completed' ? tx.amount : 0));
    notifyListeners();
  }

  Future<void> addTransaction(Transaction tx) async {
    _transactions = [..._transactions, tx];
    if (tx.status == 'completed') {
      _balance += tx.amount;
    }
    notifyListeners();

    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        final batch = FirebaseFirestore.instance.batch();

        batch.set(
          FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .collection('transactions')
              .doc(tx.id),
          {
            'id': tx.id,
            'title': tx.title,
            'amount': tx.amount,
            'date': tx.date.toIso8601String(),
            'status': tx.status,
          },
        );

        batch.set(
          FirebaseFirestore.instance.collection('users').doc(user.uid),
          {'balance': _balance},
          SetOptions(merge: true),
        );

        await batch.commit();
      } catch (e) {
        _transactions = _transactions.where((t) => t.id != tx.id).toList();
        if (tx.status == 'completed') {
          _balance -= tx.amount;
        }
        notifyListeners();
        debugPrint('addTransaction error: $e');
      }
    }
  }

  Future<void> fetchTransactions() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

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
          status: data['status'] as String? ?? 'completed',
        );
      }).toList();

      final balance = (userDoc.data()?['balance'] as num?)?.toDouble() ?? txs.fold<double>(0.0, (total, tx) => total + (tx.status == 'completed' ? tx.amount : 0));
      _balance = balance;
      _transactions = txs;
      notifyListeners();
    } catch (e) {
      debugPrint('fetchTransactions error: $e');
    }
  }
}
