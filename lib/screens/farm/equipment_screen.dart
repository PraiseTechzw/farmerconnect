import 'package:flutter/material.dart';

class EquipmentScreen extends StatefulWidget {
  const EquipmentScreen({super.key});

  @override
  State<EquipmentScreen> createState() => _EquipmentScreenState();
}

class _EquipmentScreenState extends State<EquipmentScreen> {
  final List<Map<String, dynamic>> _equipment = [
    {
      'name': 'Tractor',
      'model': 'John Deere 5075E',
      'status': 'Operational',
      'lastMaintenance': '2024-02-15',
      'nextMaintenance': '2024-04-15',
      'hoursUsed': '250',
      'icon': Icons.agriculture,
    },
    {
      'name': 'Irrigation System',
      'model': 'Rain Bird XFS',
      'status': 'Maintenance Due',
      'lastMaintenance': '2024-01-15',
      'nextMaintenance': '2024-03-15',
      'hoursUsed': '180',
      'icon': Icons.water_drop,
    },
    {
      'name': 'Harvester',
      'model': 'Case IH 8120',
      'status': 'Operational',
      'lastMaintenance': '2024-03-01',
      'nextMaintenance': '2024-05-01',
      'hoursUsed': '120',
      'icon': Icons.agriculture,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Equipment Management'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              // Show filter options
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildEquipmentSummary(),
          const SizedBox(height: 24),
          _buildEquipmentList(),
          const SizedBox(height: 24),
          _buildMaintenanceSchedule(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddEquipmentDialog();
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildEquipmentSummary() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Equipment Summary',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildSummaryItem('Total Equipment', '8', Icons.agriculture),
                _buildSummaryItem('Operational', '6', Icons.check_circle),
                _buildSummaryItem('Maintenance Due', '2', Icons.warning),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryItem(String title, String value, IconData icon) {
    return Column(
      children: [
        Icon(
          icon,
          size: 32,
          color: Colors.blue[700],
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          title,
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildEquipmentList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'All Equipment',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        ..._equipment.map((item) {
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
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item['model'] as String),
                  Text('Hours Used: ${item['hoursUsed']}'),
                ],
              ),
              trailing: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: item['status'] == 'Operational'
                      ? Colors.green[100]
                      : Colors.orange[100],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  item['status'] as String,
                  style: TextStyle(
                    color: item['status'] == 'Operational'
                        ? Colors.green[700]
                        : Colors.orange[700],
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ],
    );
  }

  Widget _buildMaintenanceSchedule() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Maintenance Schedule',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        ..._equipment.map((item) {
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
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Last: ${item['lastMaintenance']}'),
                  Text('Next: ${item['nextMaintenance']}'),
                ],
              ),
              trailing: ElevatedButton(
                onPressed: () {
                  _showMaintenanceDialog(item);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue[700],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text('Schedule'),
              ),
            ),
          );
        }).toList(),
      ],
    );
  }

  void _showAddEquipmentDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add New Equipment'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: const InputDecoration(
                labelText: 'Equipment Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              decoration: const InputDecoration(
                labelText: 'Model',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              decoration: const InputDecoration(
                labelText: 'Hours Used',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              // Add equipment
              Navigator.pop(context);
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  void _showMaintenanceDialog(Map<String, dynamic> equipment) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Schedule Maintenance for ${equipment['name']}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Last Maintenance: ${equipment['lastMaintenance']}'),
            Text('Next Maintenance: ${equipment['nextMaintenance']}'),
            const SizedBox(height: 16),
            TextField(
              decoration: const InputDecoration(
                labelText: 'Maintenance Date',
                border: OutlineInputBorder(),
              ),
              readOnly: true,
              onTap: () {
                // Show date picker
              },
            ),
            const SizedBox(height: 16),
            TextField(
              decoration: const InputDecoration(
                labelText: 'Maintenance Type',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              // Schedule maintenance
              Navigator.pop(context);
            },
            child: const Text('Schedule'),
          ),
        ],
      ),
    );
  }
}
