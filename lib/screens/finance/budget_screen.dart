import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class BudgetScreen extends StatefulWidget {
  const BudgetScreen({super.key});

  @override
  State<BudgetScreen> createState() => _BudgetScreenState();
}

class _BudgetScreenState extends State<BudgetScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final currencyFormat = NumberFormat.currency(symbol: '\$');

  final List<Map<String, dynamic>> _budgetCategories = [
    {
      'name': 'Equipment',
      'budget': 5000.00,
      'spent': 3200.00,
      'icon': Icons.agriculture,
      'color': Colors.blue,
    },
    {
      'name': 'Supplies',
      'budget': 3000.00,
      'spent': 1800.00,
      'icon': Icons.inventory,
      'color': Colors.green,
    },
    {
      'name': 'Labor',
      'budget': 4000.00,
      'spent': 2500.00,
      'icon': Icons.people,
      'color': Colors.orange,
    },
    {
      'name': 'Utilities',
      'budget': 2000.00,
      'spent': 1200.00,
      'icon': Icons.power,
      'color': Colors.purple,
    },
  ];

  final List<Map<String, dynamic>> _recentTransactions = [
    {
      'title': 'Tractor Maintenance',
      'amount': 850.00,
      'date': DateTime.now().subtract(const Duration(days: 2)),
      'category': 'Equipment',
      'type': 'expense',
    },
    {
      'title': 'Seed Purchase',
      'amount': 450.00,
      'date': DateTime.now().subtract(const Duration(days: 3)),
      'category': 'Supplies',
      'type': 'expense',
    },
    {
      'title': 'Crop Sale',
      'amount': 2500.00,
      'date': DateTime.now().subtract(const Duration(days: 5)),
      'category': 'Income',
      'type': 'income',
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              expandedHeight: 200,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                background: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.green[700]!,
                        Colors.green[500]!,
                      ],
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      const SizedBox(height: 40),
                      const Text(
                        'Budget Planning',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildBudgetSummary(),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
              bottom: TabBar(
                controller: _tabController,
                indicatorColor: Colors.white,
                indicatorWeight: 3,
                labelStyle: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                tabs: const [
                  Tab(text: 'Categories'),
                  Tab(text: 'Transactions'),
                ],
              ),
            ),
          ];
        },
        body: TabBarView(
          controller: _tabController,
          children: [
            _buildCategoriesTab(),
            _buildTransactionsTab(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Implementation for adding new transaction
        },
        backgroundColor: Colors.green[700],
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildBudgetSummary() {
    final totalBudget = _budgetCategories.fold<double>(
      0,
      (sum, category) => sum + (category['budget'] as double),
    );
    final totalSpent = _budgetCategories.fold<double>(
      0,
      (sum, category) => sum + (category['spent'] as double),
    );
    final remaining = totalBudget - totalSpent;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: _buildSummaryCard(
              'Total Budget',
              currencyFormat.format(totalBudget),
              Icons.account_balance_wallet,
              Colors.white,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: _buildSummaryCard(
              'Remaining',
              currencyFormat.format(remaining),
              Icons.savings,
              Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard(
      String title, String amount, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            amount,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            title,
            style: TextStyle(
              color: Colors.white.withOpacity(0.8),
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoriesTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Budget Categories',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _budgetCategories.length,
            itemBuilder: (context, index) {
              final category = _budgetCategories[index];
              return _buildCategoryCard(category);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryCard(Map<String, dynamic> category) {
    final progress = category['spent'] / category['budget'];
    final remaining = category['budget'] - category['spent'];

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor:
                      (category['color'] as Color).withOpacity(0.1),
                  child: Icon(
                    category['icon'] as IconData,
                    color: category['color'] as Color,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        category['name'],
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Remaining: ${currencyFormat.format(remaining)}',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.more_vert),
                  onPressed: () => _showCategoryOptions(category),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Progress',
                  style: TextStyle(
                    color: Colors.grey[600],
                  ),
                ),
                Text(
                  '${(progress * 100).toStringAsFixed(1)}%',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            LinearProgressIndicator(
              value: progress,
              backgroundColor: Colors.grey[200],
              valueColor:
                  AlwaysStoppedAnimation<Color>(category['color'] as Color),
              minHeight: 8,
              borderRadius: BorderRadius.circular(4),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Budget',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 12,
                      ),
                    ),
                    Text(
                      currencyFormat.format(category['budget']),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Spent',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 12,
                      ),
                    ),
                    Text(
                      currencyFormat.format(category['spent']),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTransactionsTab() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _recentTransactions.length,
      itemBuilder: (context, index) {
        final transaction = _recentTransactions[index];
        return _buildTransactionCard(transaction);
      },
    );
  }

  Widget _buildTransactionCard(Map<String, dynamic> transaction) {
    final isExpense = transaction['type'] == 'expense';

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: CircleAvatar(
          backgroundColor: isExpense ? Colors.red[100] : Colors.green[100],
          child: Icon(
            isExpense ? Icons.remove : Icons.add,
            color: isExpense ? Colors.red[700] : Colors.green[700],
          ),
        ),
        title: Text(
          transaction['title'],
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          '${transaction['category']} • ${DateFormat('MMM d, y').format(transaction['date'])}',
          style: TextStyle(
            color: Colors.grey[600],
          ),
        ),
        trailing: Text(
          '${isExpense ? '-' : '+'}${currencyFormat.format(transaction['amount'])}',
          style: TextStyle(
            color: isExpense ? Colors.red[700] : Colors.green[700],
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        onTap: () {
          // Implementation for viewing transaction details
        },
      ),
    );
  }

  void _showCategoryOptions(Map<String, dynamic> category) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.edit),
              title: const Text('Edit Budget'),
              onTap: () {
                Navigator.pop(context);
                _showEditBudgetDialog(category);
              },
            ),
            ListTile(
              leading: const Icon(Icons.add),
              title: const Text('Add Transaction'),
              onTap: () {
                Navigator.pop(context);
                _showAddTransactionDialog(category);
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete, color: Colors.red),
              title: const Text('Delete Category',
                  style: TextStyle(color: Colors.red)),
              onTap: () {
                Navigator.pop(context);
                _showDeleteConfirmation(category);
              },
            ),
          ],
        );
      },
    );
  }

  void _showEditBudgetDialog(Map<String, dynamic> category) {
    // Implementation for editing budget
  }

  void _showAddTransactionDialog(Map<String, dynamic> category) {
    // Implementation for adding transaction
  }

  void _showDeleteConfirmation(Map<String, dynamic> category) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete Category'),
          content:
              Text('Are you sure you want to delete "${category['name']}"?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  _budgetCategories.remove(category);
                });
                Navigator.pop(context);
              },
              child: const Text('Delete', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }
}
