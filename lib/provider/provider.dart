import 'package:flutter/foundation.dart';
import '../models/transaction.dart';

class TransactionsProvider extends ChangeNotifier {
  List<Transaction> _transactions = [];
  double _balance = 0.0;

  List<Transaction> get transactions => _transactions;
  bool get hasTransactions => _transactions.isNotEmpty;
  double get balance => _balance;

  void addTransaction(Transaction tx) {
    _transactions = [..._transactions, tx];
    _balance += tx.amount;
    notifyListeners();
  }

  void setTransactions(List<Transaction> txs) {
    _transactions = txs;
    notifyListeners();
  }
}
