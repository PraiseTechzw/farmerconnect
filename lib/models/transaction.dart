import 'package:cloud_firestore/cloud_firestore.dart';

class Transaction {
  final String id;
  final String title;
  final double amount;
  final String type; // 'income' or 'expense'
  final String category;
  final DateTime date;
  final String userId;
  final String? description;
  final String? receiptUrl;

  Transaction({
    required this.id,
    required this.title,
    required this.amount,
    required this.type,
    required this.category,
    required this.date,
    required this.userId,
    this.description,
    this.receiptUrl,
  });

  factory Transaction.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Transaction(
      id: doc.id,
      title: data['title'] ?? '',
      amount: (data['amount'] ?? 0).toDouble(),
      type: data['type'] ?? 'expense',
      category: data['category'] ?? '',
      date: (data['date'] as Timestamp).toDate(),
      userId: data['userId'] ?? '',
      description: data['description'],
      receiptUrl: data['receiptUrl'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'amount': amount,
      'type': type,
      'category': category,
      'date': Timestamp.fromDate(date),
      'userId': userId,
      'description': description,
      'receiptUrl': receiptUrl,
    };
  }
} 