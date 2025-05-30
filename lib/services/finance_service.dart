import 'package:cloud_firestore/cloud_firestore.dart' as firestore;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:farmer_connect/models/transaction.dart';
import 'package:farmer_connect/models/budget.dart';
import 'package:farmer_connect/models/financial_goal.dart';

class FinanceService {
  final firestore.FirebaseFirestore _firestore = firestore.FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Get current user ID
  String get _userId => _auth.currentUser?.uid ?? '';

  // Collection References
  firestore.CollectionReference get _transactionsCollection =>
      _firestore.collection('users').doc(_userId).collection('transactions');
  
  firestore.CollectionReference get _budgetsCollection =>
      _firestore.collection('users').doc(_userId).collection('budgets');
  
  firestore.CollectionReference get _goalsCollection =>
      _firestore.collection('users').doc(_userId).collection('goals');

  // Transaction Methods
  Future<void> addTransaction(Transaction transaction) async {
    try {
      await _transactionsCollection.add(transaction.toMap());
    } catch (e) {
      throw Exception('Failed to add transaction: $e');
    }
  }

  Stream<List<Transaction>> getTransactions() {
    return _transactionsCollection
        .orderBy('date', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => Transaction.fromFirestore(doc))
          .toList();
    });
  }

  Stream<List<Transaction>> getTransactionsByType(String type) {
    return _transactionsCollection
        .where('type', isEqualTo: type)
        .orderBy('date', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => Transaction.fromFirestore(doc))
          .toList();
    });
  }

  Stream<List<Transaction>> getTransactionsByCategory(String category) {
    return _transactionsCollection
        .where('category', isEqualTo: category)
        .orderBy('date', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => Transaction.fromFirestore(doc))
          .toList();
    });
  }

  Stream<List<Transaction>> getTransactionsByDateRange(
      DateTime startDate, DateTime endDate) {
    return _transactionsCollection
        .where('date',
            isGreaterThanOrEqualTo: firestore.Timestamp.fromDate(startDate),
            isLessThanOrEqualTo: firestore.Timestamp.fromDate(endDate))
        .orderBy('date', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => Transaction.fromFirestore(doc))
          .toList();
    });
  }

  Future<void> updateTransaction(String id, Map<String, dynamic> data) async {
    try {
      await _transactionsCollection.doc(id).update(data);
    } catch (e) {
      throw Exception('Failed to update transaction: $e');
    }
  }

  Future<void> deleteTransaction(String id) async {
    try {
      await _transactionsCollection.doc(id).delete();
    } catch (e) {
      throw Exception('Failed to delete transaction: $e');
    }
  }

  // Budget Methods
  Future<void> addBudget(Budget budget) async {
    try {
      await _budgetsCollection.add(budget.toMap());
    } catch (e) {
      throw Exception('Failed to add budget: $e');
    }
  }

  Stream<List<Budget>> getBudgets() {
    return _budgetsCollection
        .orderBy('startDate', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => Budget.fromFirestore(doc))
          .toList();
    });
  }

  Future<void> updateBudget(String id, Map<String, dynamic> data) async {
    try {
      await _budgetsCollection.doc(id).update(data);
    } catch (e) {
      throw Exception('Failed to update budget: $e');
    }
  }

  Future<void> deleteBudget(String id) async {
    try {
      await _budgetsCollection.doc(id).delete();
    } catch (e) {
      throw Exception('Failed to delete budget: $e');
    }
  }

  // Financial Goals Methods
  Future<void> addGoal(FinancialGoal goal) async {
    try {
      await _goalsCollection.add(goal.toMap());
    } catch (e) {
      throw Exception('Failed to add goal: $e');
    }
  }

  Stream<List<FinancialGoal>> getGoals() {
    return _goalsCollection
        .orderBy('deadline')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => FinancialGoal.fromFirestore(doc))
          .toList();
    });
  }

  Future<void> updateGoal(String id, Map<String, dynamic> data) async {
    try {
      await _goalsCollection.doc(id).update(data);
    } catch (e) {
      throw Exception('Failed to update goal: $e');
    }
  }

  Future<void> deleteGoal(String id) async {
    try {
      await _goalsCollection.doc(id).delete();
    } catch (e) {
      throw Exception('Failed to delete goal: $e');
    }
  }

  // Analytics Methods
  Future<Map<String, double>> getFinancialSummary() async {
    try {
      final transactions = await _transactionsCollection.get();
      double totalIncome = 0;
      double totalExpenses = 0;

      for (var doc in transactions.docs) {
        final transaction = Transaction.fromFirestore(doc);
        if (transaction.type == 'income') {
          totalIncome += transaction.amount;
        } else {
          totalExpenses += transaction.amount;
        }
      }

      return {
        'totalIncome': totalIncome,
        'totalExpenses': totalExpenses,
        'netProfit': totalIncome - totalExpenses,
      };
    } catch (e) {
      throw Exception('Failed to get financial summary: $e');
    }
  }

  Future<Map<String, double>> getCategoryWiseExpenses() async {
    try {
      final transactions = await _transactionsCollection
          .where('type', isEqualTo: 'expense')
          .get();
      
      Map<String, double> categoryExpenses = {};
      
      for (var doc in transactions.docs) {
        final transaction = Transaction.fromFirestore(doc);
        categoryExpenses[transaction.category] =
            (categoryExpenses[transaction.category] ?? 0) + transaction.amount;
      }

      return categoryExpenses;
    } catch (e) {
      throw Exception('Failed to get category-wise expenses: $e');
    }
  }

  Future<List<Map<String, dynamic>>> getMonthlyTrends() async {
    try {
      final now = DateTime.now();
      final startOfYear = DateTime(now.year, 1, 1);
      
      final transactions = await _transactionsCollection
          .where('date', isGreaterThanOrEqualTo: firestore.Timestamp.fromDate(startOfYear))
          .get();

      Map<String, Map<String, double>> monthlyData = {};

      for (var doc in transactions.docs) {
        final transaction = Transaction.fromFirestore(doc);
        final month = transaction.date.month.toString();
        
        if (!monthlyData.containsKey(month)) {
          monthlyData[month] = {
            'income': 0,
            'expenses': 0,
            'profit': 0,
          };
        }

        if (transaction.type == 'income') {
          monthlyData[month]!['income'] =
              (monthlyData[month]!['income'] ?? 0) + transaction.amount;
        } else {
          monthlyData[month]!['expenses'] =
              (monthlyData[month]!['expenses'] ?? 0) + transaction.amount;
        }

        monthlyData[month]!['profit'] =
            (monthlyData[month]!['income'] ?? 0) - (monthlyData[month]!['expenses'] ?? 0);
      }

      return monthlyData.entries.map((entry) {
        return {
          'month': entry.key,
          'income': entry.value['income'] ?? 0,
          'expenses': entry.value['expenses'] ?? 0,
          'profit': entry.value['profit'] ?? 0,
        };
      }).toList();
    } catch (e) {
      throw Exception('Failed to get monthly trends: $e');
    }
  }
} 