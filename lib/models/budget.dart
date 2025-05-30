import 'package:cloud_firestore/cloud_firestore.dart';

class Budget {
  final String id;
  final String category;
  final double amount;
  final double spent;
  final DateTime startDate;
  final DateTime endDate;
  final String userId;
  final String? description;

  Budget({
    required this.id,
    required this.category,
    required this.amount,
    required this.spent,
    required this.startDate,
    required this.endDate,
    required this.userId,
    this.description,
  });

  factory Budget.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Budget(
      id: doc.id,
      category: data['category'] ?? '',
      amount: (data['amount'] ?? 0).toDouble(),
      spent: (data['spent'] ?? 0).toDouble(),
      startDate: (data['startDate'] as Timestamp).toDate(),
      endDate: (data['endDate'] as Timestamp).toDate(),
      userId: data['userId'] ?? '',
      description: data['description'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'category': category,
      'amount': amount,
      'spent': spent,
      'startDate': Timestamp.fromDate(startDate),
      'endDate': Timestamp.fromDate(endDate),
      'userId': userId,
      'description': description,
    };
  }

  double get remaining => amount - spent;
  double get progress => (spent / amount) * 100;
} 