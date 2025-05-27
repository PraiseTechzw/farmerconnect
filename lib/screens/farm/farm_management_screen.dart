import 'package:flutter/material.dart';
import 'package:farmer_connect/screens/farm/crop_planning_screen.dart';
import 'package:farmer_connect/screens/farm/inventory_screen.dart';
import 'package:farmer_connect/screens/farm/equipment_screen.dart';
import 'package:farmer_connect/screens/farm/analytics_screen.dart';

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
            _buildCropsTab(),
            _buildInventoryTab(),
            _buildEquipmentTab(),
            _buildAnalyticsTab(),
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

  Widget _buildCropsTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildSectionHeader('Active Crops', 'View All'),
        const SizedBox(height: 16),
        _buildCropList(),
        const SizedBox(height: 24),
        _buildSectionHeader('Upcoming Tasks', 'View All'),
        const SizedBox(height: 16),
        _buildTaskList(),
      ],
    );
  }

  Widget _buildInventoryTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildSectionHeader('Inventory Items', 'View All'),
        const SizedBox(height: 16),
        _buildInventoryList(),
        const SizedBox(height: 24),
        _buildSectionHeader('Low Stock Items', 'View All'),
        const SizedBox(height: 16),
        _buildLowStockList(),
      ],
    );
  }

  Widget _buildEquipmentTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildSectionHeader('Equipment', 'View All'),
        const SizedBox(height: 16),
        _buildEquipmentList(),
        const SizedBox(height: 24),
        _buildSectionHeader('Maintenance Schedule', 'View All'),
        const SizedBox(height: 16),
        _buildMaintenanceList(),
      ],
    );
  }

  Widget _buildAnalyticsTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildSectionHeader('Farm Overview', 'View Details'),
        const SizedBox(height: 16),
        _buildAnalyticsCards(),
        const SizedBox(height: 24),
        _buildSectionHeader('Recent Activities', 'View All'),
        const SizedBox(height: 16),
        _buildActivityList(),
      ],
    );
  }

  Widget _buildSectionHeader(String title, String action) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        TextButton(
          onPressed: () {},
          child: Text(action),
        ),
      ],
    );
  }

  Widget _buildCropList() {
    final crops = [
      {
        'name': 'Wheat',
        'area': '5 acres',
        'status': 'Growing',
        'progress': 0.7,
        'icon': Icons.grain,
      },
      {
        'name': 'Corn',
        'area': '3 acres',
        'status': 'Growing',
        'progress': 0.4,
        'icon': Icons.eco,
      },
      {
        'name': 'Soybeans',
        'area': '4 acres',
        'status': 'Growing',
        'progress': 0.6,
        'icon': Icons.spa,
      },
    ];

    return Column(
      children: crops.map((crop) {
        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.green[100],
              child: Icon(
                crop['icon'] as IconData,
                color: Colors.green[700],
              ),
            ),
            title: Text(
              crop['name'] as String,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Text(crop['area'] as String),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  crop['status'] as String,
                  style: TextStyle(
                    color: Colors.green[700],
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                SizedBox(
                  width: 100,
                  child: LinearProgressIndicator(
                    value: crop['progress'] as double,
                    backgroundColor: Colors.grey[200],
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.green[700]!),
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildTaskList() {
    final tasks = [
      {
        'title': 'Fertilize Wheat Field',
        'date': 'Tomorrow',
        'priority': 'High',
        'icon': Icons.agriculture,
      },
      {
        'title': 'Irrigate Corn Field',
        'date': 'Today',
        'priority': 'Medium',
        'icon': Icons.water_drop,
      },
      {
        'title': 'Harvest Soybeans',
        'date': 'Next Week',
        'priority': 'Low',
        'icon': Icons.agriculture,
      },
    ];

    return Column(
      children: tasks.map((task) {
        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.orange[100],
              child: Icon(
                task['icon'] as IconData,
                color: Colors.orange[700],
              ),
            ),
            title: Text(
              task['title'] as String,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Text(task['date'] as String),
            trailing: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 8,
                vertical: 4,
              ),
              decoration: BoxDecoration(
                color: Colors.orange[100],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                task['priority'] as String,
                style: TextStyle(
                  color: Colors.orange[700],
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildInventoryList() {
    final items = [
      {
        'name': 'Organic Fertilizer',
        'quantity': '500 kg',
        'status': 'In Stock',
        'icon': Icons.spa,
      },
      {
        'name': 'Seeds',
        'quantity': '100 kg',
        'status': 'In Stock',
        'icon': Icons.grain,
      },
      {
        'name': 'Pesticides',
        'quantity': '50 L',
        'status': 'Low Stock',
        'icon': Icons.eco,
      },
    ];

    return Column(
      children: items.map((item) {
        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.blue[100],
              child: Icon(
                item['icon'] as IconData,
                color: Colors.blue[700],
              ),
            ),
            title: Text(
              item['name'] as String,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Text(item['quantity'] as String),
            trailing: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 8,
                vertical: 4,
              ),
              decoration: BoxDecoration(
                color: item['status'] == 'In Stock' ? Colors.green[100] : Colors.orange[100],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                item['status'] as String,
                style: TextStyle(
                  color: item['status'] == 'In Stock' ? Colors.green[700] : Colors.orange[700],
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildLowStockList() {
    final items = [
      {
        'name': 'Pesticides',
        'quantity': '5 L',
        'reorder': '10 L',
        'icon': Icons.eco,
      },
      {
        'name': 'Fertilizer',
        'quantity': '50 kg',
        'reorder': '100 kg',
        'icon': Icons.spa,
      },
    ];

    return Column(
      children: items.map((item) {
        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.red[100],
              child: Icon(
                item['icon'] as IconData,
                color: Colors.red[700],
              ),
            ),
            title: Text(
              item['name'] as String,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Text('Current: ${item['quantity']}'),
            trailing: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red[700],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text('Reorder ${item['reorder']}'),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildEquipmentList() {
    final equipment = [
      {
        'name': 'Tractor',
        'status': 'Operational',
        'lastMaintenance': '2 weeks ago',
        'icon': Icons.agriculture,
      },
      {
        'name': 'Irrigation System',
        'status': 'Maintenance Due',
        'lastMaintenance': '1 month ago',
        'icon': Icons.water_drop,
      },
      {
        'name': 'Harvester',
        'status': 'Operational',
        'lastMaintenance': '3 weeks ago',
        'icon': Icons.agriculture,
      },
    ];

    return Column(
      children: equipment.map((item) {
        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.purple[100],
              child: Icon(
                item['icon'] as IconData,
                color: Colors.purple[700],
              ),
            ),
            title: Text(
              item['name'] as String,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Text('Last Maintenance: ${item['lastMaintenance']}'),
            trailing: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 8,
                vertical: 4,
              ),
              decoration: BoxDecoration(
                color: item['status'] == 'Operational' ? Colors.green[100] : Colors.orange[100],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                item['status'] as String,
                style: TextStyle(
                  color: item['status'] == 'Operational' ? Colors.green[700] : Colors.orange[700],
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildMaintenanceList() {
    final maintenance = [
      {
        'equipment': 'Irrigation System',
        'date': 'Tomorrow',
        'type': 'Regular Check',
        'icon': Icons.water_drop,
      },
      {
        'equipment': 'Tractor',
        'date': 'Next Week',
        'type': 'Oil Change',
        'icon': Icons.agriculture,
      },
    ];

    return Column(
      children: maintenance.map((item) {
        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.blue[100],
              child: Icon(
                item['icon'] as IconData,
                color: Colors.blue[700],
              ),
            ),
            title: Text(
              item['equipment'] as String,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Text(item['type'] as String),
            trailing: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 8,
                vertical: 4,
              ),
              decoration: BoxDecoration(
                color: Colors.blue[100],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                item['date'] as String,
                style: TextStyle(
                  color: Colors.blue[700],
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildAnalyticsCards() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildAnalyticsCard(
                'Total Area',
                '12 acres',
                Icons.crop_square,
                Colors.green,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildAnalyticsCard(
                'Yield',
                '85%',
                Icons.trending_up,
                Colors.blue,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildAnalyticsCard(
                'Revenue',
                '\$12,500',
                Icons.attach_money,
                Colors.orange,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildAnalyticsCard(
                'Efficiency',
                '92%',
                Icons.speed,
                Colors.purple,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildAnalyticsCard(String title, String value, IconData icon, Color color) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              icon,
              color: color,
              size: 32,
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActivityList() {
    final activities = [
      {
        'title': 'Wheat Harvested',
        'time': '2 hours ago',
        'icon': Icons.agriculture,
        'color': Colors.green,
      },
      {
        'title': 'New Equipment Added',
        'time': '5 hours ago',
        'icon': Icons.agriculture,
        'color': Colors.blue,
      },
      {
        'title': 'Inventory Updated',
        'time': '1 day ago',
        'icon': Icons.inventory,
        'color': Colors.orange,
      },
    ];

    return Column(
      children: activities.map((activity) {
        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: (activity['color'] as Color).withOpacity(0.1),
              child: Icon(
                activity['icon'] as IconData,
                color: activity['color'] as Color,
              ),
            ),
            title: Text(
              activity['title'] as String,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Text(activity['time'] as String),
          ),
        );
      }).toList(),
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