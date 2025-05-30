import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:farmer_connect/models/transaction.dart';
import 'package:farmer_connect/providers/finance_provider.dart';

class TransactionsScreen extends StatefulWidget {
  const TransactionsScreen({super.key});

  @override
  State<TransactionsScreen> createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends State<TransactionsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _selectedSort = 'Date';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    // Initialize data
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<FinanceProvider>().initializeData();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
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
                        'Transactions',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Consumer<FinanceProvider>(
                        builder: (context, provider, child) {
                          final summary = provider.financialSummary;
                          return Row(
                            children: [
                              _buildSummaryCard(
                                'Income',
                                summary['totalIncome'] ?? 0,
                                Colors.green.shade100,
                              ),
                              const SizedBox(width: 12),
                              _buildSummaryCard(
                                'Expenses',
                                summary['totalExpenses'] ?? 0,
                                Colors.red.shade100,
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
            bottom: TabBar(
              controller: _tabController,
              indicatorColor: Colors.white,
              labelColor: Colors.white,
              unselectedLabelColor: Colors.white70,
              tabs: const [
                Tab(text: 'All'),
                Tab(text: 'Income'),
                Tab(text: 'Expenses'),
              ],
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  const Text(
                    'Sort by:',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(width: 8),
                  DropdownButton<String>(
                    value: _selectedSort,
                    items: ['Date', 'Amount', 'Category']
                        .map((e) => DropdownMenuItem(
                              value: e,
                              child: Text(e),
                            ))
                        .toList(),
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          _selectedSort = value;
                        });
                      }
                    },
                  ),
                ],
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

              List<Transaction> transactions = provider.transactions;
              
              // Filter transactions based on selected tab
              if (_tabController.index == 1) {
                transactions = transactions.where((t) => t.type == 'income').toList();
              } else if (_tabController.index == 2) {
                transactions = transactions.where((t) => t.type == 'expense').toList();
              }

              // Sort transactions
              switch (_selectedSort) {
                case 'Amount':
                  transactions.sort((a, b) => b.amount.compareTo(a.amount));
                  break;
                case 'Category':
                  transactions.sort((a, b) => a.category.compareTo(b.category));
                  break;
                default: // Date
                  transactions.sort((a, b) => b.date.compareTo(a.date));
              }

              if (transactions.isEmpty) {
                return const SliverFillRemaining(
                  child: Center(
                    child: Text(
                      'No transactions found',
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
                    final transaction = transactions[index];
                    return _buildTransactionCard(transaction);
                  },
                  childCount: transactions.length,
                ),
              );
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddTransactionDialog(context),
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

  Widget _buildTransactionCard(Transaction transaction) {
    final isIncome = transaction.type == 'income';
    final color = isIncome ? Colors.green : Colors.red;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color.withOpacity(0.1),
          child: Icon(
            isIncome ? Icons.arrow_upward : Icons.arrow_downward,
            color: color,
          ),
        ),
        title: Text(
          transaction.title,
          style: const TextStyle(
            fontWeight: FontWeight.w500,
          ),
        ),
        subtitle: Text(
          '${transaction.category} • ${DateFormat('MMM d, y').format(transaction.date)}',
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 12,
          ),
        ),
        trailing: Text(
          '${isIncome ? '+' : '-'}\$${transaction.amount.toStringAsFixed(2)}',
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        onTap: () => _showTransactionDetails(context, transaction),
      ),
    );
  }

  void _showAddTransactionDialog(BuildContext context) {
    final titleController = TextEditingController();
    final amountController = TextEditingController();
    String selectedType = 'expense';
    String selectedCategory = 'Other';

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
                'Add Transaction',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: titleController,
                decoration: const InputDecoration(
                  labelText: 'Title',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: amountController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Amount',
                  border: OutlineInputBorder(),
                  prefixText: '\$',
                ),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: selectedType,
                decoration: const InputDecoration(
                  labelText: 'Type',
                  border: OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem(value: 'income', child: Text('Income')),
                  DropdownMenuItem(value: 'expense', child: Text('Expense')),
                ],
                onChanged: (value) {
                  if (value != null) {
                    selectedType = value;
                  }
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: selectedCategory,
                decoration: const InputDecoration(
                  labelText: 'Category',
                  border: OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem(value: 'Other', child: Text('Other')),
                  DropdownMenuItem(value: 'Food', child: Text('Food')),
                  DropdownMenuItem(value: 'Transport', child: Text('Transport')),
                  DropdownMenuItem(value: 'Utilities', child: Text('Utilities')),
                  DropdownMenuItem(value: 'Entertainment', child: Text('Entertainment')),
                ],
                onChanged: (value) {
                  if (value != null) {
                    selectedCategory = value;
                  }
                },
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  if (titleController.text.isNotEmpty &&
                      amountController.text.isNotEmpty) {
                    final transaction = Transaction(
                      id: '', // Will be set by Firestore
                      title: titleController.text,
                      amount: double.parse(amountController.text),
                      type: selectedType,
                      category: selectedCategory,
                      date: DateTime.now(),
                      userId: '', // Will be set by the service
                    );

                    context.read<FinanceProvider>().addTransaction(transaction);
                    Navigator.pop(context);
                  }
                },
                child: const Text('Add Transaction'),
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  void _showTransactionDetails(BuildContext context, Transaction transaction) {
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
                transaction.title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              _buildDetailRow('Amount', '\$${transaction.amount.toStringAsFixed(2)}'),
              _buildDetailRow('Type', transaction.type.toUpperCase()),
              _buildDetailRow('Category', transaction.category),
              _buildDetailRow('Date', DateFormat('MMM d, y').format(transaction.date)),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        context.read<FinanceProvider>().deleteTransaction(transaction.id);
                        Navigator.pop(context);
                      },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.red,
                      ),
                      child: const Text('Delete'),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        // TODO: Implement edit functionality
                        Navigator.pop(context);
                      },
                      child: const Text('Edit'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 16,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
} 