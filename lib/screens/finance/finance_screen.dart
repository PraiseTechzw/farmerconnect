import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:farmer_connect/screens/finance/reports_screen.dart';
import 'package:farmer_connect/screens/finance/goals_screen.dart';
import 'package:farmer_connect/screens/finance/budget_screen.dart';
import 'package:farmer_connect/screens/finance/insights_screen.dart';
import 'package:farmer_connect/screens/finance/transaction_detail_screen.dart';
import 'package:farmer_connect/screens/finance/transactions_screen.dart';

class FinanceScreen extends StatefulWidget {
  const FinanceScreen({super.key});

  @override
  State<FinanceScreen> createState() => _FinanceScreenState();
}

class _FinanceScreenState extends State<FinanceScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final currencyFormat = NumberFormat.currency(symbol: '\$');

  final List<Widget> _screens = [
    const OverviewScreen(),
    const TransactionsScreen(),
    const ReportsScreen(),
    const GoalsScreen(),
    const BudgetScreen(),
    const InsightsScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 6, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _showAddTransactionDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              margin: const EdgeInsets.only(top: 8),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Add Transaction',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 24),
                  TextField(
                    decoration: InputDecoration(
                      labelText: 'Title',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      prefixIcon: const Icon(Icons.title),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    decoration: InputDecoration(
                      labelText: 'Amount',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      prefixIcon: const Icon(Icons.attach_money),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      labelText: 'Category',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      prefixIcon: const Icon(Icons.category),
                    ),
                    items: const [
                      DropdownMenuItem(value: 'income', child: Text('Income')),
                      DropdownMenuItem(value: 'expense', child: Text('Expense')),
                    ],
                    onChanged: (value) {},
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green[700],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 0,
                      ),
                      child: const Text(
                        'Add Transaction',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.green[700]!,
                  Colors.green[600]!,
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: SafeArea(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Finance',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.notifications_outlined, color: Colors.white),
                          onPressed: () {
                            // Handle notifications
                          },
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: 48,
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: TabBar(
                      controller: _tabController,
                      isScrollable: true,
                      labelColor: Colors.white,
                      unselectedLabelColor: Colors.white70,
                      indicatorColor: Colors.white,
                      indicatorSize: TabBarIndicatorSize.label,
                      indicatorWeight: 3,
                      labelStyle: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.5,
                      ),
                      unselectedLabelStyle: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.5,
                      ),
                      tabs: const [
                        Tab(
                          icon: Icon(Icons.dashboard_rounded, size: 20),
                          text: 'Overview',
                        ),
                        Tab(
                          icon: Icon(Icons.receipt_long_rounded, size: 20),
                          text: 'Transactions',
                        ),
                        Tab(
                          icon: Icon(Icons.bar_chart_rounded, size: 20),
                          text: 'Reports',
                        ),
                        Tab(
                          icon: Icon(Icons.flag_rounded, size: 20),
                          text: 'Goals',
                        ),
                        Tab(
                          icon: Icon(Icons.account_balance_wallet_rounded, size: 20),
                          text: 'Budget',
                        ),
                        Tab(
                          icon: Icon(Icons.lightbulb_rounded, size: 20),
                          text: 'Insights',
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: _screens,
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
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
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
}
