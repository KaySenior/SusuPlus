import 'package:flutter/foundation.dart';
import '../models/transaction.dart';

class TransactionsProvider extends ChangeNotifier {
  List<Transaction> _transactions = [];

  List<Transaction> get transactions => _transactions;
  bool get hasTransactions => _transactions.isNotEmpty;

  void addTransaction(Transaction tx) {
    _transactions = [..._transactions, tx];
    notifyListeners();
  }

  void setTransactions(List<Transaction> txs) {
    _transactions = txs;
    notifyListeners();
  }
}