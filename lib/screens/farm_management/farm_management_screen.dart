import 'package:flutter/material.dart';

class FarmManagementScreen extends StatefulWidget {
  const FarmManagementScreen({Key? key}) : super(key: key);

  @override
  _FarmManagementScreenState createState() => _FarmManagementScreenState();
}

class _FarmManagementScreenState extends State<FarmManagementScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Farm Management'),
      ),
      body: _buildBody(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.agriculture),
            label: 'Crops',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.inventory),
            label: 'Inventory',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.construction),
            label: 'Equipment',
          ),
        ],
      ),
    );
  }

  Widget _buildBody() {
    switch (_selectedIndex) {
      case 0:
        return _buildCropManagement();
      case 1:
        return _buildInventoryManagement();
      case 2:
        return _buildEquipmentManagement();
      default:
        return _buildCropManagement();
    }
  }

  Widget _buildCropManagement() {
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
                  'Current Crops',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                _buildCropList(),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        ElevatedButton.icon(
          onPressed: () {
            // Handle add new crop
          },
          icon: const Icon(Icons.add),
          label: const Text('Add New Crop'),
        ),
      ],
    );
  }

  Widget _buildCropList() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 5, // Replace with actual data
      itemBuilder: (context, index) {
        return ListTile(
          leading: const CircleAvatar(
            child: Icon(Icons.agriculture),
          ),
          title: Text('Crop ${index + 1}'),
          subtitle: Text('Planted: ${DateTime.now().toString().split(' ')[0]}'),
          trailing: IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {
              // Show crop options
            },
          ),
        );
      },
    );
  }

  Widget _buildInventoryManagement() {
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
                  'Inventory Items',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                _buildInventoryList(),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        ElevatedButton.icon(
          onPressed: () {
            // Handle add new inventory item
          },
          icon: const Icon(Icons.add),
          label: const Text('Add New Item'),
        ),
      ],
    );
  }

  Widget _buildInventoryList() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 5, // Replace with actual data
      itemBuilder: (context, index) {
        return ListTile(
          leading: const CircleAvatar(
            child: Icon(Icons.inventory),
          ),
          title: Text('Item ${index + 1}'),
          subtitle: Text('Quantity: ${(index + 1) * 10}'),
          trailing: IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {
              // Show inventory options
            },
          ),
        );
      },
    );
  }

  Widget _buildEquipmentManagement() {
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
                  'Equipment',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                _buildEquipmentList(),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        ElevatedButton.icon(
          onPressed: () {
            // Handle add new equipment
          },
          icon: const Icon(Icons.add),
          label: const Text('Add New Equipment'),
        ),
      ],
    );
  }

  Widget _buildEquipmentList() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 5, // Replace with actual data
      itemBuilder: (context, index) {
        return ListTile(
          leading: const CircleAvatar(
            child: Icon(Icons.construction),
          ),
          title: Text('Equipment ${index + 1}'),
          subtitle: Text('Status: ${index % 2 == 0 ? 'Available' : 'In Use'}'),
          trailing: IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {
              // Show equipment options
            },
          ),
        );
      },
    );
  }
} 