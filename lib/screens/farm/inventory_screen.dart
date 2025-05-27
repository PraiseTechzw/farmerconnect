import 'package:flutter/material.dart';

class InventoryScreen extends StatefulWidget {
  const InventoryScreen({super.key});

  @override
  State<InventoryScreen> createState() => _InventoryScreenState();
}

class _InventoryScreenState extends State<InventoryScreen> {
  final List<Map<String, dynamic>> _inventoryItems = [
    {
      'name': 'Organic Fertilizer',
      'quantity': '500 kg',
      'status': 'In Stock',
      'icon': Icons.spa,
      'category': 'Fertilizers',
      'lastRestock': '2024-02-15',
      'minQuantity': '100 kg',
    },
    {
      'name': 'Wheat Seeds',
      'quantity': '100 kg',
      'status': 'In Stock',
      'icon': Icons.grain,
      'category': 'Seeds',
      'lastRestock': '2024-03-01',
      'minQuantity': '50 kg',
    },
    {
      'name': 'Pesticides',
      'quantity': '50 L',
      'status': 'Low Stock',
      'icon': Icons.eco,
      'category': 'Chemicals',
      'lastRestock': '2024-01-15',
      'minQuantity': '100 L',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inventory Management'),
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
          _buildInventorySummary(),
          const SizedBox(height: 24),
          _buildInventoryList(),
          const SizedBox(height: 24),
          _buildLowStockItems(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddItemDialog();
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildInventorySummary() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Inventory Summary',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildSummaryItem('Total Items', '24', Icons.inventory),
                _buildSummaryItem('Low Stock', '3', Icons.warning),
                _buildSummaryItem('Categories', '5', Icons.category),
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

  Widget _buildInventoryList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'All Items',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        ..._inventoryItems.map((item) {
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
                  Text('${item['category']} • ${item['quantity']}'),
                  Text('Last Restock: ${item['lastRestock']}'),
                ],
              ),
              trailing: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: item['status'] == 'In Stock'
                      ? Colors.green[100]
                      : Colors.orange[100],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  item['status'] as String,
                  style: TextStyle(
                    color: item['status'] == 'In Stock'
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

  Widget _buildLowStockItems() {
    final lowStockItems =
        _inventoryItems.where((item) => item['status'] == 'Low Stock').toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Low Stock Items',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        ...lowStockItems.map((item) {
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
              subtitle: Text(
                  'Current: ${item['quantity']} • Min: ${item['minQuantity']}'),
              trailing: ElevatedButton(
                onPressed: () {
                  _showReorderDialog(item);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red[700],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text('Reorder'),
              ),
            ),
          );
        }).toList(),
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
            TextField(
              decoration: const InputDecoration(
                labelText: 'Item Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              decoration: const InputDecoration(
                labelText: 'Category',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              decoration: const InputDecoration(
                labelText: 'Quantity',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            TextField(
              decoration: const InputDecoration(
                labelText: 'Minimum Quantity',
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
              // Add item
              Navigator.pop(context);
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  void _showReorderDialog(Map<String, dynamic> item) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Reorder ${item['name']}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Current Stock: ${item['quantity']}'),
            Text('Minimum Required: ${item['minQuantity']}'),
            const SizedBox(height: 16),
            TextField(
              decoration: const InputDecoration(
                labelText: 'Reorder Quantity',
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
              // Place reorder
              Navigator.pop(context);
            },
            child: const Text('Place Order'),
          ),
        ],
      ),
    );
  }
}
