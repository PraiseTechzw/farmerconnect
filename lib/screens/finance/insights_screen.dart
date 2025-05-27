import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class InsightsScreen extends StatefulWidget {
  const InsightsScreen({super.key});

  @override
  State<InsightsScreen> createState() => _InsightsScreenState();
}

class _InsightsScreenState extends State<InsightsScreen> {
  final currencyFormat = NumberFormat.currency(symbol: '\$');

  final List<Map<String, dynamic>> _insights = [
    {
      'title': 'Cost Optimization',
      'description':
          'Your equipment maintenance costs are 15% higher than similar farms. Consider preventive maintenance to reduce long-term costs.',
      'type': 'cost',
      'icon': Icons.trending_down,
      'color': Colors.red,
    },
    {
      'title': 'Revenue Opportunity',
      'description':
          'Market prices for tomatoes are expected to rise by 20% in the next quarter. Consider increasing production.',
      'type': 'revenue',
      'icon': Icons.trending_up,
      'color': Colors.green,
    },
    {
      'title': 'Efficiency Improvement',
      'description':
          'Your water usage efficiency is below average. Implementing drip irrigation could save up to 30% on water costs.',
      'type': 'efficiency',
      'icon': Icons.water_drop,
      'color': Colors.blue,
    },
  ];

  final List<Map<String, dynamic>> _marketTrends = [
    {
      'crop': 'Tomatoes',
      'currentPrice': 2.50,
      'trend': 'up',
      'change': 0.30,
      'forecast': 'Expected to remain high for next 2 months',
    },
    {
      'crop': 'Lettuce',
      'currentPrice': 1.80,
      'trend': 'down',
      'change': 0.20,
      'forecast': 'Prices may stabilize in coming weeks',
    },
    {
      'crop': 'Cucumbers',
      'currentPrice': 1.50,
      'trend': 'stable',
      'change': 0.00,
      'forecast': 'Stable market conditions expected',
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
                      'Financial Insights',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildInsightStats(),
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
                  _buildInsightsSection(),
                  const SizedBox(height: 24),
                  _buildMarketTrendsSection(),
                  const SizedBox(height: 24),
                  _buildRecommendationsSection(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInsightStats() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: _buildStatCard(
              'Cost Savings',
              '15%',
              Icons.savings,
              Colors.white,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: _buildStatCard(
              'Revenue Growth',
              '20%',
              Icons.trending_up,
              Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(
      String title, String value, IconData icon, Color color) {
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
            value,
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

  Widget _buildInsightsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Key Insights',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _insights.length,
          itemBuilder: (context, index) {
            final insight = _insights[index];
            return _buildInsightCard(insight);
          },
        ),
      ],
    );
  }

  Widget _buildInsightCard(Map<String, dynamic> insight) {
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
                  backgroundColor: (insight['color'] as Color).withOpacity(0.1),
                  child: Icon(
                    insight['icon'] as IconData,
                    color: insight['color'] as Color,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    insight['title'],
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: (insight['color'] as Color).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    insight['type'].toString().toUpperCase(),
                    style: TextStyle(
                      color: insight['color'] as Color,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              insight['description'],
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMarketTrendsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Market Trends',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _marketTrends.length,
          itemBuilder: (context, index) {
            final trend = _marketTrends[index];
            return _buildMarketTrendCard(trend);
          },
        ),
      ],
    );
  }

  Widget _buildMarketTrendCard(Map<String, dynamic> trend) {
    final isUp = trend['trend'] == 'up';
    final isDown = trend['trend'] == 'down';

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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  trend['crop'],
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: isUp
                        ? Colors.green[100]
                        : isDown
                            ? Colors.red[100]
                            : Colors.grey[100],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        isUp
                            ? Icons.arrow_upward
                            : isDown
                                ? Icons.arrow_downward
                                : Icons.remove,
                        size: 16,
                        color: isUp
                            ? Colors.green[700]
                            : isDown
                                ? Colors.red[700]
                                : Colors.grey[700],
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '\$${trend['change'].toStringAsFixed(2)}',
                        style: TextStyle(
                          color: isUp
                              ? Colors.green[700]
                              : isDown
                                  ? Colors.red[700]
                                  : Colors.grey[700],
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Current Price',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
                Text(
                  '\$${trend['currentPrice'].toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              trend['forecast'],
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecommendationsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Recommendations',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        _buildRecommendationCard(
          'Optimize Water Usage',
          'Implement drip irrigation system to reduce water costs by 30%',
          Icons.water_drop,
          Colors.blue,
        ),
        _buildRecommendationCard(
          'Equipment Maintenance',
          'Schedule preventive maintenance to reduce repair costs',
          Icons.build,
          Colors.orange,
        ),
        _buildRecommendationCard(
          'Crop Diversification',
          'Consider adding high-value crops to increase revenue',
          Icons.agriculture,
          Colors.green,
        ),
      ],
    );
  }

  Widget _buildRecommendationCard(
    String title,
    String description,
    IconData icon,
    Color color,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: color.withOpacity(0.1),
              child: Icon(icon, color: color),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    description,
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.arrow_forward),
              onPressed: () {
                // Implementation for viewing recommendation details
              },
            ),
          ],
        ),
      ),
    );
  }
}
