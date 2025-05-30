import 'package:cloud_firestore/cloud_firestore.dart';

class FinancialGoal {
  final String id;
  final String title;
  final double targetAmount;
  final double currentAmount;
  final DateTime deadline;
  final String userId;
  final String category;
  final String? description;
  final String? icon;

  FinancialGoal({
    required this.id,
    required this.title,
    required this.targetAmount,
    required this.currentAmount,
    required this.deadline,
    required this.userId,
    required this.category,
    this.description,
    this.icon,
  });

  factory FinancialGoal.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return FinancialGoal(
      id: doc.id,
      title: data['title'] ?? '',
      targetAmount: (data['targetAmount'] ?? 0).toDouble(),
      currentAmount: (data['currentAmount'] ?? 0).toDouble(),
      deadline: (data['deadline'] as Timestamp).toDate(),
      userId: data['userId'] ?? '',
      category: data['category'] ?? '',
      description: data['description'],
      icon: data['icon'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'targetAmount': targetAmount,
      'currentAmount': currentAmount,
      'deadline': Timestamp.fromDate(deadline),
      'userId': userId,
      'category': category,
      'description': description,
      'icon': icon,
    };
  }

  double get progress => (currentAmount / targetAmount) * 100;
  int get daysLeft => deadline.difference(DateTime.now()).inDays;
  bool get isCompleted => currentAmount >= targetAmount;
} 