import 'package:flutter/material.dart';
import 'package:farmer_connect/screens/farm/crop_planning_screen.dart';
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

class _FarmManagementScreenState extends State<FarmManagementScreen> with SingleTickerProviderStateMixin {
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
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        ListTile(
          leading: const Icon(Icons.grass, color: Colors.green),
          title: const Text('Crop Planning'),
          subtitle: const Text('Manage crop schedules, planting, and harvest.'),
          trailing: const Icon(Icons.arrow_forward_ios),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const CropPlanningScreen()),
            );
          },
        ),
        ListTile(
          leading: const Icon(Icons.calendar_today, color: Colors.blue),
          title: const Text('Calendar View'),
          subtitle: const Text('Visualize farm events and tasks.'),
          trailing: const Icon(Icons.arrow_forward_ios),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const CalendarScreen()),
            );
          },
        ),
        ListTile(
          leading: const Icon(Icons.cloud, color: Colors.lightBlue),
          title: const Text('Weather Information'),
          subtitle: const Text('Detailed weather data for your farm.'),
          trailing: const Icon(Icons.arrow_forward_ios),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const WeatherScreen()),
            );
          },
        ),
        ListTile(
          leading: const Icon(Icons.task, color: Colors.purple),
          title: const Text('Task Management'),
          subtitle: const Text('Create, assign, and track farm tasks.'),
          trailing: const Icon(Icons.arrow_forward_ios),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const TaskManagementScreen()),
            );
          },
        ),
      ],
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
          subtitle: const Text('View performance, yield, and financial metrics.'),
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
}