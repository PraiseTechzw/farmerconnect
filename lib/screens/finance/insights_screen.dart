import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:farmer_connect/providers/finance_provider.dart';
import 'package:intl/intl.dart';

class InsightsScreen extends StatefulWidget {
  const InsightsScreen({super.key});

  @override
  State<InsightsScreen> createState() => _InsightsScreenState();
}

class _InsightsScreenState extends State<InsightsScreen> {
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
            expandedHeight: 120,
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
                child: const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Financial Insights',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
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
                  _buildFinancialHealth(provider),
                  _buildSpendingInsights(provider),
                  _buildBudgetInsights(provider),
                  _buildRecommendations(provider),
                ]),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildFinancialHealth(FinanceProvider provider) {
    final summary = provider.financialSummary;
    final totalIncome = summary['totalIncome'] ?? 0;
    final totalExpenses = summary['totalExpenses'] ?? 0;
    final netProfit = summary['netProfit'] ?? 0;
    final savingsRate = totalIncome > 0 ? (netProfit / totalIncome) * 100 : 0;

    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Financial Health',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildHealthMetric(
                    'Savings Rate',
                    '${savingsRate.toStringAsFixed(1)}%',
                    savingsRate >= 20 ? Colors.green : Colors.orange,
                    Icons.savings,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildHealthMetric(
                    'Expense Ratio',
                    '${((totalExpenses / totalIncome) * 100).toStringAsFixed(1)}%',
                    totalExpenses / totalIncome <= 0.7 ? Colors.green : Colors.red,
                    Icons.pie_chart,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildHealthMetric(
              'Net Profit',
              '\$${netProfit.toStringAsFixed(2)}',
              netProfit >= 0 ? Colors.green : Colors.red,
              Icons.trending_up,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSpendingInsights(FinanceProvider provider) {
    final expenses = provider.categoryExpenses;
    if (expenses.isEmpty) return const SizedBox.shrink();

    final total = expenses.values.fold<double>(0, (sum, amount) => sum + amount);
    final sortedExpenses = expenses.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    final topCategory = sortedExpenses.first;
    final topCategoryPercentage = (topCategory.value / total) * 100;

    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Spending Insights',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildInsightCard(
              'Top Spending Category',
              '$topCategoryPercentage% of your expenses are in ${topCategory.key}',
              Icons.category,
              Colors.blue,
            ),
            const SizedBox(height: 12),
            _buildInsightCard(
              'Expense Distribution',
              'Your expenses are spread across ${expenses.length} categories',
              Icons.pie_chart,
              Colors.purple,
            ),
            if (topCategoryPercentage > 50) ...[
              const SizedBox(height: 12),
              _buildInsightCard(
                'Spending Concentration',
                'Consider diversifying your spending across categories',
                Icons.warning,
                Colors.orange,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildBudgetInsights(FinanceProvider provider) {
    final budgets = provider.budgets;
    if (budgets.isEmpty) return const SizedBox.shrink();

    final overBudgetCount = budgets.where((b) => b.progress > 100).length;
    final underBudgetCount = budgets.where((b) => b.progress < 80).length;
    final onTrackCount = budgets.length - overBudgetCount - underBudgetCount;

    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Budget Insights',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildInsightCard(
              'Budget Status',
              '$onTrackCount budgets are on track, $overBudgetCount are over budget',
              Icons.assessment,
              Colors.green,
            ),
            if (overBudgetCount > 0) ...[
              const SizedBox(height: 12),
              _buildInsightCard(
                'Over Budget Categories',
                '$overBudgetCount categories are exceeding their budget limits',
                Icons.warning,
                Colors.red,
              ),
            ],
            if (underBudgetCount > 0) ...[
              const SizedBox(height: 12),
              _buildInsightCard(
                'Under Budget Categories',
                '$underBudgetCount categories are under budget',
                Icons.check_circle,
                Colors.blue,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildRecommendations(FinanceProvider provider) {
    final summary = provider.financialSummary;
    final totalIncome = summary['totalIncome'] ?? 0;
    final totalExpenses = summary['totalExpenses'] ?? 0;
    final netProfit = summary['netProfit'] ?? 0;
    final savingsRate = totalIncome > 0 ? (netProfit / totalIncome) * 100 : 0;

    final List<Map<String, dynamic>> recommendations = [];

    if (savingsRate < 20) {
      recommendations.add({
        'title': 'Increase Savings',
        'description': 'Try to save at least 20% of your income each month',
        'icon': Icons.savings,
        'color': Colors.green,
      });
    }

    if (totalExpenses / totalIncome > 0.7) {
      recommendations.add({
        'title': 'Reduce Expenses',
        'description': 'Your expenses are high relative to income. Look for areas to cut back.',
        'icon': Icons.trending_down,
        'color': Colors.red,
      });
    }

    final budgets = provider.budgets;
    final overBudgetCount = budgets.where((b) => b.progress > 100).length;
    if (overBudgetCount > 0) {
      recommendations.add({
        'title': 'Review Budgets',
        'description': 'Adjust budgets for categories that are consistently over limit',
        'icon': Icons.edit,
        'color': Colors.orange,
      });
    }

    if (recommendations.isEmpty) {
      recommendations.add({
        'title': 'Great Job!',
        'description': 'Your finances are in good shape. Keep up the good work!',
        'icon': Icons.emoji_events,
        'color': Colors.blue,
      });
    }

    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Recommendations',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ...recommendations.map((rec) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: _buildInsightCard(
                    rec['title'],
                    rec['description'],
                    rec['icon'],
                    rec['color'],
                  ),
                )),
          ],
        ),
      ),
    );
  }

  Widget _buildHealthMetric(
      String title, String value, Color color, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 20),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  color: color,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              color: color,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInsightCard(
      String title, String description, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: color,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    color: color.withOpacity(0.8),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
