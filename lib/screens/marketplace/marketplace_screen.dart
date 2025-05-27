import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MarketplaceScreen extends StatefulWidget {
  const MarketplaceScreen({Key? key}) : super(key: key);

  @override
  _MarketplaceScreenState createState() => _MarketplaceScreenState();
}

class _MarketplaceScreenState extends State<MarketplaceScreen> with SingleTickerProviderStateMixin {
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
        title: const Text('Marketplace'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Crops'),
            Tab(text: 'Equipment'),
            Tab(text: 'Market Trends'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildCropsMarketplace(),
          _buildEquipmentMarketplace(),
          _buildMarketTrends(),
        ],
      ),
    );
  }

  Widget _buildCropsMarketplace() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 10, // Replace with actual data
      itemBuilder: (context, index) {
        return Card(
          child: ListTile(
            leading: const CircleAvatar(
              child: Icon(Icons.agriculture),
            ),
            title: Text('Crop Item ${index + 1}'),
            subtitle: Text('Price: \$${(index + 1) * 100}'),
            trailing: ElevatedButton(
              onPressed: () {
                // Handle buy action
              },
              child: const Text('Buy'),
            ),
          ),
        );
      },
    );
  }

  Widget _buildEquipmentMarketplace() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 10, // Replace with actual data
      itemBuilder: (context, index) {
        return Card(
          child: ListTile(
            leading: const CircleAvatar(
              child: Icon(Icons.construction),
            ),
            title: Text('Equipment ${index + 1}'),
            subtitle: Text('Daily Rate: \$${(index + 1) * 50}'),
            trailing: ElevatedButton(
              onPressed: () {
                // Handle rent action
              },
              child: const Text('Rent'),
            ),
          ),
        );
      },
    );
  }

  Widget _buildMarketTrends() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
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
                // Add charts and graphs here
                const Text('Coming soon: Price charts and market analysis'),
              ],
            ),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
} 