import 'package:flutter/material.dart';
import 'package:farmer_connect/models/transaction.dart';
import 'package:farmer_connect/models/budget.dart';
import 'package:farmer_connect/models/financial_goal.dart';
import 'package:farmer_connect/services/finance_service.dart';

class FinanceProvider with ChangeNotifier {
  final FinanceService _financeService = FinanceService();
  
  // State variables
  List<Transaction> _transactions = [];
  List<Budget> _budgets = [];
  List<FinancialGoal> _goals = [];
  Map<String, double> _financialSummary = {};
  Map<String, double> _categoryExpenses = {};
  List<Map<String, dynamic>> _monthlyTrends = [];
  bool _isLoading = false;
  String? _error;

  // Getters
  List<Transaction> get transactions => _transactions;
  List<Budget> get budgets => _budgets;
  List<FinancialGoal> get goals => _goals;
  Map<String, double> get financialSummary => _financialSummary;
  Map<String, double> get categoryExpenses => _categoryExpenses;
  List<Map<String, dynamic>> get monthlyTrends => _monthlyTrends;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Initialize data
  Future<void> initializeData() async {
    _setLoading(true);
    try {
      // Load all data streams
      _financeService.getTransactions().listen((transactions) {
        _transactions = transactions;
        notifyListeners();
      });

      _financeService.getBudgets().listen((budgets) {
        _budgets = budgets;
        notifyListeners();
      });

      _financeService.getGoals().listen((goals) {
        _goals = goals;
        notifyListeners();
      });

      // Load analytics data
      await _loadAnalyticsData();
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  // Load analytics data
  Future<void> _loadAnalyticsData() async {
    try {
      _financialSummary = await _financeService.getFinancialSummary();
      _categoryExpenses = await _financeService.getCategoryWiseExpenses();
      _monthlyTrends = await _financeService.getMonthlyTrends();
      notifyListeners();
    } catch (e) {
      _setError(e.toString());
    }
  }

  // Transaction methods
  Future<void> addTransaction(Transaction transaction) async {
    _setLoading(true);
    try {
      await _financeService.addTransaction(transaction);
      await _loadAnalyticsData();
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  Future<void> updateTransaction(String id, Map<String, dynamic> data) async {
    _setLoading(true);
    try {
      await _financeService.updateTransaction(id, data);
      await _loadAnalyticsData();
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  Future<void> deleteTransaction(String id) async {
    _setLoading(true);
    try {
      await _financeService.deleteTransaction(id);
      await _loadAnalyticsData();
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  // Budget methods
  Future<void> addBudget(Budget budget) async {
    _setLoading(true);
    try {
      await _financeService.addBudget(budget);
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  Future<void> updateBudget(String id, Map<String, dynamic> data) async {
    _setLoading(true);
    try {
      await _financeService.updateBudget(id, data);
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  Future<void> deleteBudget(String id) async {
    _setLoading(true);
    try {
      await _financeService.deleteBudget(id);
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  // Goal methods
  Future<void> addGoal(FinancialGoal goal) async {
    _setLoading(true);
    try {
      await _financeService.addGoal(goal);
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  Future<void> updateGoal(String id, Map<String, dynamic> data) async {
    _setLoading(true);
    try {
      await _financeService.updateGoal(id, data);
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  Future<void> deleteGoal(String id) async {
    _setLoading(true);
    try {
      await _financeService.deleteGoal(id);
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  // Helper methods
  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _setError(String? value) {
    _error = value;
    notifyListeners();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
} 