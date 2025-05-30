import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:farmer_connect/models/budget.dart';
import 'package:farmer_connect/providers/finance_provider.dart';

class BudgetScreen extends StatefulWidget {
  const BudgetScreen({super.key});

  @override
  State<BudgetScreen> createState() => _BudgetScreenState();
}

class _BudgetScreenState extends State<BudgetScreen> {
  @override
  void initState() {
    super.initState();
    // Initialize data
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<FinanceProvider>().initializeData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            floating: true,
            pinned: true,
            expandedHeight: 200,
            backgroundColor: Colors.green,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.green.shade700,
                      Colors.green.shade500,
                    ],
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Budget',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Consumer<FinanceProvider>(
                        builder: (context, provider, child) {
                          final budgets = provider.budgets;
                          final totalBudget = budgets.fold<double>(
                              0, (sum, budget) => sum + budget.amount);
                          final totalSpent = budgets.fold<double>(
                              0, (sum, budget) => sum + budget.spent);
                          final progress = totalBudget > 0
                              ? (totalSpent / totalBudget) * 100
                              : 0.0;

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  _buildSummaryCard(
                                    'Total Budget',
                                    totalBudget,
                                    Colors.green.shade100,
                                  ),
                                  const SizedBox(width: 12),
                                  _buildSummaryCard(
                                    'Total Spent',
                                    totalSpent,
                                    Colors.red.shade100,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'Overall Progress',
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.9),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 8),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: LinearProgressIndicator(
                                  value: progress / 100,
                                  backgroundColor: Colors.white.withOpacity(0.2),
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    progress > 100
                                        ? Colors.red
                                        : Colors.green.shade300,
                                  ),
                                  minHeight: 8,
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Consumer<FinanceProvider>(
            builder: (context, provider, child) {
              if (provider.isLoading) {
                return const SliverFillRemaining(
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              }

              if (provider.error != null) {
                return SliverFillRemaining(
                  child: Center(
                    child: Text(
                      'Error: ${provider.error}',
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),
                );
              }

              final budgets = provider.budgets;

              if (budgets.isEmpty) {
                return const SliverFillRemaining(
                  child: Center(
                    child: Text(
                      'No budgets found',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                );
              }

              return SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final budget = budgets[index];
                    return _buildBudgetCard(budget);
                  },
                  childCount: budgets.length,
                ),
              );
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddBudgetDialog(context),
        backgroundColor: Colors.green,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildSummaryCard(String title, double amount, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.2),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                color: color.withOpacity(0.8),
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '\$${amount.toStringAsFixed(2)}',
              style: TextStyle(
                color: color.withOpacity(0.8),
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBudgetCard(Budget budget) {
    final progress = budget.progress;
    final color = progress > 100 ? Colors.red : Colors.green;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  budget.category,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '${progress.toStringAsFixed(1)}%',
                  style: TextStyle(
                    color: color,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: progress / 100,
                backgroundColor: Colors.grey[200],
                valueColor: AlwaysStoppedAnimation<Color>(color),
                minHeight: 8,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Spent',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      '\$${budget.spent.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'Remaining',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      '\$${budget.remaining.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total Budget: \$${budget.amount.toStringAsFixed(2)}',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
                TextButton(
                  onPressed: () => _showUpdateBudgetDialog(context, budget),
                  child: const Text('Update Budget'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showAddBudgetDialog(BuildContext context) {
    final categoryController = TextEditingController();
    final amountController = TextEditingController();
    final startDateController = TextEditingController();
    final endDateController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 16,
            right: 16,
            top: 16,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Add Budget',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: categoryController,
                decoration: const InputDecoration(
                  labelText: 'Category',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: amountController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Budget Amount',
                  border: OutlineInputBorder(),
                  prefixText: '\$',
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: startDateController,
                decoration: const InputDecoration(
                  labelText: 'Start Date',
                  border: OutlineInputBorder(),
                  suffixIcon: Icon(Icons.calendar_today),
                ),
                readOnly: true,
                onTap: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(const Duration(days: 365)),
                  );
                  if (date != null) {
                    startDateController.text =
                        '${date.month}/${date.day}/${date.year}';
                  }
                },
              ),
              const SizedBox(height: 16),
              TextField(
                controller: endDateController,
                decoration: const InputDecoration(
                  labelText: 'End Date',
                  border: OutlineInputBorder(),
                  suffixIcon: Icon(Icons.calendar_today),
                ),
                readOnly: true,
                onTap: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now().add(const Duration(days: 30)),
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(const Duration(days: 365)),
                  );
                  if (date != null) {
                    endDateController.text =
                        '${date.month}/${date.day}/${date.year}';
                  }
                },
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  if (categoryController.text.isNotEmpty &&
                      amountController.text.isNotEmpty &&
                      startDateController.text.isNotEmpty &&
                      endDateController.text.isNotEmpty) {
                    final budget = Budget(
                      id: '', // Will be set by Firestore
                      category: categoryController.text,
                      amount: double.parse(amountController.text),
                      spent: 0,
                      startDate: DateTime.parse(startDateController.text),
                      endDate: DateTime.parse(endDateController.text),
                      userId: '', // Will be set by the service
                    );

                    context.read<FinanceProvider>().addBudget(budget);
                    Navigator.pop(context);
                  }
                },
                child: const Text('Add Budget'),
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  void _showUpdateBudgetDialog(BuildContext context, Budget budget) {
    final spentController = TextEditingController(
      text: budget.spent.toString(),
    );

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Update ${budget.category} Budget',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: spentController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Amount Spent',
                  border: OutlineInputBorder(),
                  prefixText: '\$',
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  if (spentController.text.isNotEmpty) {
                    final spent = double.parse(spentController.text);
                    context.read<FinanceProvider>().updateBudget(
                          budget.id,
                          {'spent': spent},
                        );
                    Navigator.pop(context);
                  }
                },
                child: const Text('Update Budget'),
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }
}
