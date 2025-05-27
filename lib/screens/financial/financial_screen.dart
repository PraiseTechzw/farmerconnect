import 'package:flutter/material.dart';

class FinancialScreen extends StatefulWidget {
  const FinancialScreen({Key? key}) : super(key: key);

  @override
  _FinancialScreenState createState() => _FinancialScreenState();
}

class _FinancialScreenState extends State<FinancialScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Financial Management'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Overview'),
            Tab(text: 'Expenses'),
            Tab(text: 'Income'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildOverview(),
          _buildExpenses(),
          _buildIncome(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Handle new transaction
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildOverview() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildSummaryCard(),
        const SizedBox(height: 16),
        _buildRecentTransactions(),
        const SizedBox(height: 16),
        _buildFinancialGoals(),
      ],
    );
  }

  Widget _buildSummaryCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Financial Summary',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildSummaryItem('Total Income', '\$5,000'),
                _buildSummaryItem('Total Expenses', '\$3,000'),
                _buildSummaryItem('Balance', '\$2,000'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryItem(String label, String value) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.grey[600],
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildRecentTransactions() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Recent Transactions',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 5,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: index % 2 == 0 ? Colors.green[100] : Colors.red[100],
                    child: Icon(
                      index % 2 == 0 ? Icons.arrow_upward : Icons.arrow_downward,
                      color: index % 2 == 0 ? Colors.green : Colors.red,
                    ),
                  ),
                  title: Text('Transaction ${index + 1}'),
                  subtitle: Text('${DateTime.now().toString().split(' ')[0]}'),
                  trailing: Text(
                    '\$${(index + 1) * 100}',
                    style: TextStyle(
                      color: index % 2 == 0 ? Colors.green : Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFinancialGoals() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Financial Goals',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 3,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Goal ${index + 1}'),
                        Text('\$${(index + 1) * 1000}'),
                      ],
                    ),
                    const SizedBox(height: 8),
                    LinearProgressIndicator(
                      value: (index + 1) * 0.3,
                      backgroundColor: Colors.grey[200],
                    ),
                    const SizedBox(height: 16),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExpenses() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 10,
      itemBuilder: (context, index) {
        return Card(
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.red[100],
              child: const Icon(
                Icons.arrow_downward,
                color: Colors.red,
              ),
            ),
            title: Text('Expense ${index + 1}'),
            subtitle: Text('Category: ${_getExpenseCategory(index)}'),
            trailing: Text(
              '\$${(index + 1) * 50}',
              style: const TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        );
      },
    );
  }

  String _getExpenseCategory(int index) {
    final categories = [
      'Equipment',
      'Seeds',
      'Fertilizers',
      'Labor',
      'Utilities',
      'Maintenance',
      'Transportation',
      'Insurance',
      'Marketing',
      'Miscellaneous',
    ];
    return categories[index % categories.length];
  }

  Widget _buildIncome() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 10,
      itemBuilder: (context, index) {
        return Card(
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.green[100],
              child: const Icon(
                Icons.arrow_upward,
                color: Colors.green,
              ),
            ),
            title: Text('Income ${index + 1}'),
            subtitle: Text('Source: ${_getIncomeSource(index)}'),
            trailing: Text(
              '\$${(index + 1) * 100}',
              style: const TextStyle(
                color: Colors.green,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        );
      },
    );
  }

  String _getIncomeSource(int index) {
    final sources = [
      'Crop Sales',
      'Equipment Rental',
      'Consulting',
      'Government Subsidies',
      'Market Sales',
      'Online Sales',
      'Direct Sales',
      'Wholesale',
      'Export',
      'Other',
    ];
    return sources[index % sources.length];
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
} 