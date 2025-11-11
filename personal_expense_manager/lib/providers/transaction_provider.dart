import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../models/transaction_model.dart';

class TransactionProvider extends ChangeNotifier {
  late Box<TransactionModel> _transactionBox;
  List<TransactionModel> _transactions = [];

  List<TransactionModel> get transactions => _transactions;

  Future<void> initialize() async {
    _transactionBox = await Hive.openBox<TransactionModel>('transactions');
    _loadTransactions();
    
    // Thêm dữ liệu mẫu nếu chưa có
    if (_transactions.isEmpty) {
      await _addSampleData();
    }
  }

  void _loadTransactions() {
    _transactions = _transactionBox.values.toList();
    _transactions.sort((a, b) => b.date.compareTo(a.date));
    notifyListeners();
  }

  Future<void> _addSampleData() async {
    final now = DateTime.now();
    final samples = [
      TransactionModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: 'Lương tháng',
        amount: 15000000,
        date: DateTime(now.year, now.month, 1),
        category: 'Lương',
        isIncome: true,
      ),
      TransactionModel(
        id: (DateTime.now().millisecondsSinceEpoch + 1).toString(),
        name: 'Ăn trưa',
        amount: 50000,
        date: now.subtract(const Duration(days: 1)),
        category: 'Ăn uống',
        isIncome: false,
      ),
      TransactionModel(
        id: (DateTime.now().millisecondsSinceEpoch + 2).toString(),
        name: 'Xăng xe',
        amount: 200000,
        date: now.subtract(const Duration(days: 2)),
        category: 'Đi lại',
        isIncome: false,
      ),
      TransactionModel(
        id: (DateTime.now().millisecondsSinceEpoch + 3).toString(),
        name: 'Mua quần áo',
        amount: 500000,
        date: now.subtract(const Duration(days: 3)),
        category: 'Mua sắm',
        isIncome: false,
      ),
      TransactionModel(
        id: (DateTime.now().millisecondsSinceEpoch + 4).toString(),
        name: 'Xem phim',
        amount: 150000,
        date: now.subtract(const Duration(days: 5)),
        category: 'Giải trí',
        isIncome: false,
      ),
    ];

    for (var transaction in samples) {
      await _transactionBox.add(transaction);
    }
    _loadTransactions();
  }

  Future<void> addTransaction(TransactionModel transaction) async {
    await _transactionBox.add(transaction);
    _loadTransactions();
  }

  Future<void> deleteTransaction(TransactionModel transaction) async {
    await transaction.delete();
    _loadTransactions();
  }

  double get totalBalance {
    double balance = 0;
    for (var transaction in _transactions) {
      if (transaction.isIncome) {
        balance += transaction.amount;
      } else {
        balance -= transaction.amount;
      }
    }
    return balance;
  }

  double get totalIncome {
    return _transactions
        .where((t) => t.isIncome)
        .fold(0, (sum, t) => sum + t.amount);
  }

  double get totalExpense {
    return _transactions
        .where((t) => !t.isIncome)
        .fold(0, (sum, t) => sum + t.amount);
  }

  Map<String, double> getExpensesByCategory() {
    Map<String, double> categoryExpenses = {};
    for (var transaction in _transactions) {
      if (!transaction.isIncome) {
        categoryExpenses[transaction.category] =
            (categoryExpenses[transaction.category] ?? 0) + transaction.amount;
      }
    }
    return categoryExpenses;
  }

  Map<String, double> getMonthlyExpenses() {
    Map<String, double> monthlyExpenses = {};
    for (var transaction in _transactions) {
      if (!transaction.isIncome) {
        String monthKey = '${transaction.date.month}/${transaction.date.year}';
        monthlyExpenses[monthKey] =
            (monthlyExpenses[monthKey] ?? 0) + transaction.amount;
      }
    }
    return monthlyExpenses;
  }

  List<TransactionModel> getTransactionsByDate(DateTime date) {
    return _transactions.where((t) {
      return t.date.year == date.year &&
          t.date.month == date.month &&
          t.date.day == date.day;
    }).toList();
  }

  Map<String, List<TransactionModel>> getTransactionsGroupedByDate() {
    Map<String, List<TransactionModel>> grouped = {};
    for (var transaction in _transactions) {
      String dateKey =
          '${transaction.date.day}/${transaction.date.month}/${transaction.date.year}';
      if (!grouped.containsKey(dateKey)) {
        grouped[dateKey] = [];
      }
      grouped[dateKey]!.add(transaction);
    }
    return grouped;
  }
}
