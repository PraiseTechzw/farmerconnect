import 'package:flutter/material.dart';
import 'package:farmer_connect/screens/farm/crop_planning_screen.dart';
import 'package:farmer_connect/screens/farm/crop_recommendations_screen.dart';
import 'package:farmer_connect/screens/farm/crop_details_screen.dart';
import 'package:farmer_connect/screens/farm/inventory_screen.dart';
import 'package:farmer_connect/screens/farm/equipment_screen.dart';
import 'package:farmer_connect/screens/farm/analytics_screen.dart';
import 'package:farmer_connect/screens/farm/weather_screen.dart';
import 'package:farmer_connect/screens/farm/calendar_screen.dart';
import 'package:farmer_connect/screens/farm/task_management_screen.dart';

class FarmManagementScreen extends StatefulWidget {
  const FarmManagementScreen({super.key});

  @override
  State<FarmManagementScreen> createState() => _FarmManagementScreenState();
}

class _FarmManagementScreenState extends State<FarmManagementScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final List<Map<String, dynamic>> _quickStats = [
    {
      'title': 'Active Crops',
      'value': '12',
      'icon': Icons.grass,
      'color': Colors.green,
    },
    {
      'title': 'Equipment',
      'value': '8',
      'icon': Icons.agriculture,
      'color': Colors.orange,
    },
    {
      'title': 'Inventory',
      'value': '24',
      'icon': Icons.inventory,
      'color': Colors.blue,
    },
    {
      'title': 'Tasks',
      'value': '5',
      'icon': Icons.task_alt,
      'color': Colors.purple,
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
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
                      const Text(
                        'Farm Management',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildQuickStats(),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
              bottom: TabBar(
                controller: _tabController,
                indicatorColor: Colors.white,
                tabs: const [
                  Tab(text: 'Crops'),
                  Tab(text: 'Inventory'),
                  Tab(text: 'Equipment'),
                  Tab(text: 'Analytics'),
                ],
              ),
            ),
          ];
        },
        body: TabBarView(
          controller: _tabController,
          children: [
            _buildCropsTab(context),
            _buildInventoryTab(context),
            _buildEquipmentTab(context),
            _buildAnalyticsTab(context),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddItemDialog();
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildQuickStats() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: _quickStats.map((stat) {
          return _buildStatCard(stat);
        }).toList(),
      ),
    );
  }

  Widget _buildStatCard(Map<String, dynamic> stat) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(
            stat['icon'] as IconData,
            color: Colors.white,
            size: 24,
          ),
          const SizedBox(height: 8),
          Text(
            stat['value'],
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            stat['title'],
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCropsTab(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildSection(
            context,
            'AI-Powered Features',
            [
              _buildFeatureCard(
                context,
                'Crop Recommendations',
                'Get AI-powered crop recommendations based on your local weather and conditions',
                Icons.eco,
                () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CropRecommendationsScreen(),
                  ),
                ),
              ),
              _buildFeatureCard(
                context,
                'Crop Details',
                'Get detailed information about specific crops in your area',
                Icons.info,
                () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CropDetailsScreen(),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          _buildSection(
            context,
            'Farm Planning',
            [
              _buildFeatureCard(
                context,
                'Crop Planning',
                'Plan and manage your crops',
                Icons.calendar_today,
                () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CropPlanningScreen(),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInventoryTab(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        ListTile(
          leading: const Icon(Icons.inventory, color: Colors.orange),
          title: const Text('Inventory Management'),
          subtitle: const Text('Track supplies, stock levels, and reordering.'),
          trailing: const Icon(Icons.arrow_forward_ios),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const InventoryScreen()),
            );
          },
        ),
      ],
    );
  }

  Widget _buildEquipmentTab(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        ListTile(
          leading: const Icon(Icons.agriculture, color: Colors.blue),
          title: const Text('Equipment Management'),
          subtitle: const Text('Track machinery, maintenance, and usage.'),
          trailing: const Icon(Icons.arrow_forward_ios),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const EquipmentScreen()),
            );
          },
        ),
      ],
    );
  }

  Widget _buildAnalyticsTab(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        ListTile(
          leading: const Icon(Icons.analytics, color: Colors.teal),
          title: const Text('Farm Analytics'),
          subtitle:
              const Text('View performance, yield, and financial metrics.'),
          trailing: const Icon(Icons.arrow_forward_ios),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AnalyticsScreen()),
            );
          },
        ),
      ],
    );
  }

  void _showAddItemDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add New Item'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.grass),
              title: const Text('Add Crop'),
              onTap: () {
                Navigator.pop(context);
                // Navigate to add crop screen
              },
            ),
            ListTile(
              leading: const Icon(Icons.inventory),
              title: const Text('Add Inventory Item'),
              onTap: () {
                Navigator.pop(context);
                // Navigate to add inventory screen
              },
            ),
            ListTile(
              leading: const Icon(Icons.agriculture),
              title: const Text('Add Equipment'),
              onTap: () {
                Navigator.pop(context);
                // Navigate to add equipment screen
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(BuildContext context, String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 16),
        ...children,
      ],
    );
  }

  Widget _buildFeatureCard(
    BuildContext context,
    String title,
    String description,
    IconData icon,
    VoidCallback onTap,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  icon,
                  color: Theme.of(context).primaryColor,
                  size: 32,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right),
            ],
          ),
        ),
      ),
    );
  }
}
