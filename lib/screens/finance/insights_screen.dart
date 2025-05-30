import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class InsightsScreen extends StatefulWidget {
  const InsightsScreen({super.key});

  @override
  State<InsightsScreen> createState() => _InsightsScreenState();
}

class _InsightsScreenState extends State<InsightsScreen> {
  final currencyFormat = NumberFormat.currency(symbol: '\$');

  final List<Map<String, dynamic>> _monthlyTrends = [
    {
      'month': 'Jan',
      'income': 8500.00,
      'expenses': 3200.00,
      'profit': 5300.00,
    },
    {
      'month': 'Feb',
      'income': 9200.00,
      'expenses': 3800.00,
      'profit': 5400.00,
    },
    {
      'month': 'Mar',
      'income': 12500.00,
      'expenses': 4200.00,
      'profit': 8300.00,
    },
  ];

  final List<Map<String, dynamic>> _expenseCategories = [
    {
      'category': 'Equipment',
      'amount': 4200.00,
      'percentage': 0.35,
      'icon': Icons.build,
      'color': Colors.blue,
    },
    {
      'category': 'Supplies',
      'amount': 3200.00,
      'percentage': 0.25,
      'icon': Icons.inventory,
      'color': Colors.orange,
    },
    {
      'category': 'Labor',
      'amount': 2800.00,
      'percentage': 0.20,
      'icon': Icons.people,
      'color': Colors.purple,
    },
    {
      'category': 'Utilities',
      'amount': 2000.00,
      'percentage': 0.15,
      'icon': Icons.power,
      'color': Colors.red,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            elevation: 0,
            backgroundColor: Colors.transparent,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.green[700]!,
                      Colors.green[600]!,
                    ],
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    const SizedBox(height: 40),
                    const Text(
                      'Financial Insights',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildInsightFilters(),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                _buildKeyMetrics(),
                const SizedBox(height: 24),
                _buildExpenseBreakdown(),
                const SizedBox(height: 24),
                _buildMonthlyTrends(),
                const SizedBox(height: 24),
                _buildRecommendations(),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInsightFilters() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          _buildFilterChip('This Month', true),
          const SizedBox(width: 8),
          _buildFilterChip('Last 3 Months', false),
          const SizedBox(width: 8),
          _buildFilterChip('This Year', false),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, bool isSelected) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isSelected ? Colors.white : Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
        boxShadow: isSelected ? [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ] : null,
      ),
      child: Text(
        label,
        style: TextStyle(
          color: isSelected ? Colors.green[700] : Colors.white,
          fontSize: 14,
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildKeyMetrics() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Key Metrics',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 16,
            runSpacing: 16,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.4,
                child: _buildMetricCard(
                  'Total Revenue',
                  '\$30,200',
                  Icons.arrow_upward,
                  Colors.green[300]!,
                  '+15% from last month',
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.4,
                child: _buildMetricCard(
                  'Total Expenses',
                  '\$11,200',
                  Icons.arrow_downward,
                  Colors.red[300]!,
                  '-8% from last month',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMetricCard(
      String title, String amount, IconData icon, Color color, String trend) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: color, size: 18),
              const SizedBox(width: 4),
              Flexible(
                child: Text(
                  trend,
                  style: TextStyle(
                    color: color,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            amount,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 13,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildExpenseBreakdown() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Expense Breakdown',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 16),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _expenseCategories.length,
            itemBuilder: (context, index) {
              final category = _expenseCategories[index];
              return _buildExpenseCategoryRow(category);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildExpenseCategoryRow(Map<String, dynamic> category) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: (category['color'] as Color).withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              category['icon'],
              color: category['color'],
              size: 18,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  category['category'],
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: category['percentage'],
                    backgroundColor: Colors.grey[200],
                    valueColor: AlwaysStoppedAnimation<Color>(category['color']),
                    minHeight: 6,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Text(
            currencyFormat.format(category['amount']),
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMonthlyTrends() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Monthly Trends',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 16),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _monthlyTrends.length,
            itemBuilder: (context, index) {
              final trend = _monthlyTrends[index];
              return _buildMonthlyTrendRow(trend);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildMonthlyTrendRow(Map<String, dynamic> trend) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          SizedBox(
            width: 40,
            child: Text(
              trend['month'],
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Income: ${currencyFormat.format(trend['income'])}',
                  style: TextStyle(
                    color: Colors.green[700],
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Expenses: ${currencyFormat.format(trend['expenses'])}',
                  style: TextStyle(
                    color: Colors.red[700],
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          Text(
            currencyFormat.format(trend['profit']),
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecommendations() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Recommendations',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 16),
          _buildRecommendationCard(
            'Optimize Equipment Costs',
            'Consider leasing instead of buying to reduce upfront costs',
            Icons.build,
            Colors.blue,
          ),
          const SizedBox(height: 12),
          _buildRecommendationCard(
            'Energy Efficiency',
            'Switch to solar power to reduce utility expenses',
            Icons.solar_power,
            Colors.orange,
          ),
          const SizedBox(height: 12),
          _buildRecommendationCard(
            'Labor Management',
            'Implement seasonal hiring to optimize labor costs',
            Icons.people,
            Colors.purple,
          ),
        ],
      ),
    );
  }

  Widget _buildRecommendationCard(
      String title, String description, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
