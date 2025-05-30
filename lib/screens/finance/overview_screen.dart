import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:farmer_connect/providers/finance_provider.dart';
import 'package:fl_chart/fl_chart.dart';

class OverviewScreen extends StatefulWidget {
  const OverviewScreen({super.key});

  @override
  State<OverviewScreen> createState() => _OverviewScreenState();
}

class _OverviewScreenState extends State<OverviewScreen> {
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
                        'Financial Overview',
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
                              const SizedBox(width: 12),
                              _buildSummaryCard(
                                'Net Profit',
                                summary['netProfit'] ?? 0,
                                Colors.blue.shade100,
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

              return SliverList(
                delegate: SliverChildListDelegate([
                  _buildMonthlyTrendsChart(provider),
                  _buildCategoryExpensesChart(provider),
                  _buildRecentTransactions(provider),
                  _buildBudgetProgress(provider),
                ]),
              );
            },
          ),
        ],
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

  Widget _buildMonthlyTrendsChart(FinanceProvider provider) {
    final trends = provider.monthlyTrends;
    if (trends.isEmpty) return const SizedBox.shrink();

    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Monthly Trends',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(show: false),
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    rightTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    topTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          if (value.toInt() >= trends.length) return const Text('');
                          return Text(
                            'M${value.toInt() + 1}',
                            style: const TextStyle(fontSize: 12),
                          );
                        },
                      ),
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                  lineBarsData: [
                    LineChartBarData(
                      spots: trends.asMap().entries.map((entry) {
                        return FlSpot(
                          entry.key.toDouble(),
                          entry.value['income'] ?? 0,
                        );
                      }).toList(),
                      isCurved: true,
                      color: Colors.green,
                      barWidth: 3,
                      dotData: FlDotData(show: false),
                    ),
                    LineChartBarData(
                      spots: trends.asMap().entries.map((entry) {
                        return FlSpot(
                          entry.key.toDouble(),
                          entry.value['expenses'] ?? 0,
                        );
                      }).toList(),
                      isCurved: true,
                      color: Colors.red,
                      barWidth: 3,
                      dotData: FlDotData(show: false),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildLegendItem('Income', Colors.green),
                const SizedBox(width: 16),
                _buildLegendItem('Expenses', Colors.red),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryExpensesChart(FinanceProvider provider) {
    final expenses = provider.categoryExpenses;
    if (expenses.isEmpty) return const SizedBox.shrink();

    final total = expenses.values.fold<double>(0, (sum, amount) => sum + amount);
    final sections = expenses.entries.map((entry) {
      return PieChartSectionData(
        value: entry.value,
        title: '${((entry.value / total) * 100).toStringAsFixed(1)}%',
        color: _getCategoryColor(entry.key),
        radius: 100,
        titleStyle: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      );
    }).toList();

    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Expenses by Category',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: PieChart(
                PieChartData(
                  sections: sections,
                  centerSpaceRadius: 40,
                  sectionsSpace: 2,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 16,
              runSpacing: 8,
              children: expenses.entries.map((entry) {
                return _buildLegendItem(
                  entry.key,
                  _getCategoryColor(entry.key),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentTransactions(FinanceProvider provider) {
    final transactions = provider.transactions.take(5).toList();
    if (transactions.isEmpty) return const SizedBox.shrink();

    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Recent Transactions',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: transactions.length,
              itemBuilder: (context, index) {
                final transaction = transactions[index];
                final isIncome = transaction.type == 'income';
                final color = isIncome ? Colors.green : Colors.red;

                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: color.withOpacity(0.1),
                    child: Icon(
                      isIncome ? Icons.arrow_upward : Icons.arrow_downward,
                      color: color,
                    ),
                  ),
                  title: Text(transaction.title),
                  subtitle: Text(transaction.category),
                  trailing: Text(
                    '${isIncome ? '+' : '-'}\$${transaction.amount.toStringAsFixed(2)}',
                    style: TextStyle(
                      color: color,
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

  Widget _buildBudgetProgress(FinanceProvider provider) {
    final budgets = provider.budgets;
    if (budgets.isEmpty) return const SizedBox.shrink();

    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Budget Progress',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: budgets.length,
              itemBuilder: (context, index) {
                final budget = budgets[index];
                final progress = budget.progress;
                final color = progress > 100 ? Colors.red : Colors.green;

                return Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            budget.category,
                            style: const TextStyle(
                              fontWeight: FontWeight.w500,
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
                      const SizedBox(height: 8),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: progress / 100,
                          backgroundColor: Colors.grey[200],
                          valueColor: AlwaysStoppedAnimation<Color>(color),
                          minHeight: 8,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: const TextStyle(fontSize: 12),
        ),
      ],
    );
  }

  Color _getCategoryColor(String category) {
    final colors = {
      'Food': Colors.orange,
      'Transport': Colors.blue,
      'Utilities': Colors.purple,
      'Entertainment': Colors.pink,
      'Other': Colors.grey,
    };
    return colors[category] ?? Colors.grey;
  }
} 