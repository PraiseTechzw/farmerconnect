import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:farmer_connect/screens/finance/reports_screen.dart';
import 'package:farmer_connect/screens/finance/goals_screen.dart';
import 'package:farmer_connect/screens/finance/budget_screen.dart';
import 'package:farmer_connect/screens/finance/insights_screen.dart';
import 'package:farmer_connect/screens/finance/transaction_detail_screen.dart';

class FinanceScreen extends StatefulWidget {
  const FinanceScreen({super.key});

  @override
  State<FinanceScreen> createState() => _FinanceScreenState();
}

class _FinanceScreenState extends State<FinanceScreen> {
  int _currentIndex = 0;
  final currencyFormat = NumberFormat.currency(symbol: '\$');

  final List<Widget> _screens = [
    const OverviewScreen(),
    const ReportsScreen(),
    const GoalsScreen(),
    const BudgetScreen(),
    const InsightsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.dashboard),
            label: 'Overview',
          ),
          NavigationDestination(
            icon: Icon(Icons.bar_chart),
            label: 'Reports',
          ),
          NavigationDestination(
            icon: Icon(Icons.flag),
            label: 'Goals',
          ),
          NavigationDestination(
            icon: Icon(Icons.account_balance_wallet),
            label: 'Budget',
          ),
          NavigationDestination(
            icon: Icon(Icons.lightbulb),
            label: 'Insights',
          ),
        ],
      ),
    );
  }
}

class OverviewScreen extends StatefulWidget {
  const OverviewScreen({super.key});

  @override
  State<OverviewScreen> createState() => _OverviewScreenState();
}

class _OverviewScreenState extends State<OverviewScreen> {
  final currencyFormat = NumberFormat.currency(symbol: '\$');

  final List<Map<String, dynamic>> _recentTransactions = [
    {
      'title': 'Tomato Harvest Sale',
      'amount': 2500.00,
      'date': '2024-03-15',
      'type': 'income',
      'category': 'Crop Sales',
      'icon': Icons.shopping_cart,
    },
    {
      'title': 'Equipment Maintenance',
      'amount': -450.00,
      'date': '2024-03-14',
      'type': 'expense',
      'category': 'Equipment',
      'icon': Icons.build,
    },
    {
      'title': 'Organic Fertilizer',
      'amount': -320.00,
      'date': '2024-03-13',
      'type': 'expense',
      'category': 'Supplies',
      'icon': Icons.eco,
    },
  ];

  final List<Map<String, dynamic>> _financialGoals = [
    {
      'title': 'New Irrigation System',
      'target': 5000.00,
      'current': 3500.00,
      'deadline': '2024-06-30',
      'icon': Icons.water_drop,
    },
    {
      'title': 'Farm Expansion',
      'target': 15000.00,
      'current': 8000.00,
      'deadline': '2024-12-31',
      'icon': Icons.agriculture,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
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
                      'Farm Finance',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildFinancialOverview(),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildRecentTransactions(),
                  const SizedBox(height: 24),
                  _buildFinancialGoals(),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          _showAddTransactionDialog(context);
        },
        icon: const Icon(Icons.add),
        label: const Text('New Transaction'),
        backgroundColor: Colors.green[700],
      ),
    );
  }

  Widget _buildFinancialOverview() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildOverviewCard(
            'Total Income',
            '\$12,500',
            Icons.arrow_upward,
            Colors.green[300]!,
          ),
          _buildOverviewCard(
            'Total Expenses',
            '\$4,200',
            Icons.arrow_downward,
            Colors.red[300]!,
          ),
          _buildOverviewCard(
            'Net Profit',
            '\$8,300',
            Icons.account_balance,
            Colors.blue[300]!,
          ),
        ],
      ),
    );
  }

  Widget _buildOverviewCard(
      String title, String amount, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            amount,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            title,
            style: TextStyle(
              color: Colors.white.withOpacity(0.8),
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentTransactions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Recent Transactions',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextButton(
              onPressed: () {
                // Navigate to transactions screen
              },
              child: const Text('View All'),
            ),
          ],
        ),
        const SizedBox(height: 16),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: 3,
          itemBuilder: (context, index) {
            return _buildTransactionCard(index);
          },
        ),
      ],
    );
  }

  Widget _buildTransactionCard(int index) {
    final transaction = _recentTransactions[index];
    final isIncome = transaction['type'] == 'income';
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: isIncome ? Colors.green[100] : Colors.red[100],
          child: Icon(
            transaction['icon'],
            color: isIncome ? Colors.green[700] : Colors.red[700],
          ),
        ),
        title: Text(transaction['title']),
        subtitle: Text(transaction['category']),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              currencyFormat.format(transaction['amount']),
              style: TextStyle(
                color: isIncome ? Colors.green[700] : Colors.red[700],
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              transaction['date'],
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 12,
              ),
            ),
          ],
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TransactionDetailScreen(
                transaction: transaction,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildFinancialGoals() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Financial Goals',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextButton(
              onPressed: () {
                // Navigate to goals screen
              },
              child: const Text('View All'),
            ),
          ],
        ),
        const SizedBox(height: 16),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _financialGoals.length,
          itemBuilder: (context, index) {
            return _buildGoalCard(index);
          },
        ),
      ],
    );
  }

  Widget _buildGoalCard(int index) {
    final goal = _financialGoals[index];
    final progress = goal['current'] / goal['target'];
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
                  backgroundColor: Colors.green[100],
                  child: Icon(goal['icon'], color: Colors.green[700]),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        goal['title'],
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Target: ${currencyFormat.format(goal['target'])}',
                        style: TextStyle(
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            LinearProgressIndicator(
              value: progress,
              backgroundColor: Colors.grey[200],
              valueColor: AlwaysStoppedAnimation<Color>(Colors.green[700]!),
              minHeight: 8,
              borderRadius: BorderRadius.circular(4),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${(progress * 100).toStringAsFixed(1)}%',
                  style: TextStyle(
                    color: Colors.green[700],
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Due: ${goal['deadline']}',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showAddTransactionDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
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
                decoration: const InputDecoration(
                  labelText: 'Title',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Amount',
                  border: OutlineInputBorder(),
                  prefixText: '\$',
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Category',
                  border: OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem(value: 'income', child: Text('Income')),
                  DropdownMenuItem(value: 'expense', child: Text('Expense')),
                ],
                onChanged: (value) {},
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  // Handle transaction creation
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green[700],
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: const Text('Add Transaction'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
