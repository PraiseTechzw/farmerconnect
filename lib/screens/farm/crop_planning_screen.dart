import 'package:flutter/material.dart';
import 'package:farmer_connect/database/database_helper.dart';
import 'package:farmer_connect/screens/farm/calendar_screen.dart';

class CropPlanningScreen extends StatefulWidget {
  const CropPlanningScreen({super.key});

  @override
  State<CropPlanningScreen> createState() => _CropPlanningScreenState();
}

class _CropPlanningScreenState extends State<CropPlanningScreen> {
  final DatabaseHelper _databaseHelper = DatabaseHelper();
  List<Map<String, dynamic>> _crops = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCrops();
  }

  Future<void> _loadCrops() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final crops = await _databaseHelper.getCrops();
      setState(() {
        _crops = crops;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading crops: $e')),
      );
    }
  }

  Future<void> _addCrop(Map<String, dynamic> crop) async {
    try {
      await _databaseHelper.insertCrop(crop);
      await _loadCrops();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Crop added successfully')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error adding crop: $e')),
        );
      }
    }
  }

  Future<void> _updateCrop(Map<String, dynamic> crop) async {
    try {
      await _databaseHelper.updateCrop(crop);
      await _loadCrops();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Crop updated successfully')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error updating crop: $e')),
        );
      }
    }
  }

  Future<void> _deleteCrop(int id) async {
    try {
      await _databaseHelper.deleteCrop(id);
      await _loadCrops();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Crop deleted successfully')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error deleting crop: $e')),
        );
      }
    }
  }

  void _showAddCropDialog() {
    final nameController = TextEditingController();
    final areaController = TextEditingController();
    DateTime? plantingDate;
    DateTime? harvestDate;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add New Crop'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Crop Name',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: areaController,
                decoration: const InputDecoration(
                  labelText: 'Area (acres)',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              ListTile(
                title: const Text('Planting Date'),
                subtitle: Text(plantingDate?.toString() ?? 'Not selected'),
                trailing: const Icon(Icons.calendar_today),
                onTap: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(const Duration(days: 365)),
                  );
                  if (date != null) {
                    plantingDate = date;
                    setState(() {});
                  }
                },
              ),
              ListTile(
                title: const Text('Expected Harvest Date'),
                subtitle: Text(harvestDate?.toString() ?? 'Not selected'),
                trailing: const Icon(Icons.calendar_today),
                onTap: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now().add(const Duration(days: 90)),
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(const Duration(days: 365)),
                  );
                  if (date != null) {
                    harvestDate = date;
                    setState(() {});
                  }
                },
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              if (nameController.text.isEmpty ||
                  areaController.text.isEmpty ||
                  plantingDate == null ||
                  harvestDate == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Please fill in all fields'),
                  ),
                );
                return;
              }

              final crop = {
                'name': nameController.text,
                'area': areaController.text,
                'plantingDate': plantingDate!.toIso8601String(),
                'harvestDate': harvestDate!.toIso8601String(),
                'status': 'Planned',
                'progress': 0.0,
                'icon': '🌱',
              };

              _addCrop(crop);
              Navigator.pop(context);
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Crop Planning'),
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_today),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const CalendarScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _buildCropSchedule(),
                const SizedBox(height: 24),
                _buildUpcomingTasks(),
                const SizedBox(height: 24),
                _buildWeatherForecast(),
              ],
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddCropDialog,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildCropSchedule() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Crop Schedule',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        ..._crops.map((crop) => Card(
              margin: const EdgeInsets.only(bottom: 16),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          crop['name'],
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '${crop['area']} acres',
                          style: const TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Planting: ${crop['plantingDate']}'),
                        Text('Harvest: ${crop['harvestDate']}'),
                      ],
                    ),
                    const SizedBox(height: 16),
                    LinearProgressIndicator(
                      value: crop['progress'],
                      backgroundColor: Colors.grey[200],
                      valueColor: AlwaysStoppedAnimation<Color>(
                        _getStatusColor(crop['status']),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Status: ${crop['status']}',
                          style: TextStyle(
                            color: _getStatusColor(crop['status']),
                          ),
                        ),
                        Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () {
                                // TODO: Implement edit functionality
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () {
                                _deleteCrop(crop['id']);
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            )),
      ],
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'planned':
        return Colors.blue;
      case 'in progress':
        return Colors.orange;
      case 'completed':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  Widget _buildUpcomingTasks() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Upcoming Tasks',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Card(
          child: ListTile(
            leading: const Icon(Icons.agriculture),
            title: const Text('Harvest Wheat'),
            subtitle: const Text('Due in 2 days'),
            trailing: const Chip(
              label: Text('High'),
              backgroundColor: Colors.red,
              labelStyle: TextStyle(color: Colors.white),
            ),
          ),
        ),
        Card(
          child: ListTile(
            leading: const Icon(Icons.water_drop),
            title: const Text('Irrigation System Maintenance'),
            subtitle: const Text('Due in 5 days'),
            trailing: const Chip(
              label: Text('Medium'),
              backgroundColor: Colors.orange,
              labelStyle: TextStyle(color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildWeatherForecast() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Weather Forecast',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Current Weather',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Row(
                      children: [
                        const Icon(Icons.wb_sunny),
                        const SizedBox(width: 8),
                        Text(
                          '25°C',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.orange[700],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildWeatherDay('Mon', '☀️', '28°C'),
                    _buildWeatherDay('Tue', '⛅', '26°C'),
                    _buildWeatherDay('Wed', '🌧️', '24°C'),
                    _buildWeatherDay('Thu', '⛅', '25°C'),
                    _buildWeatherDay('Fri', '☀️', '27°C'),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildWeatherDay(String day, String emoji, String temp) {
    return Column(
      children: [
        Text(
          day,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          emoji,
          style: const TextStyle(fontSize: 24),
        ),
        const SizedBox(height: 8),
        Text(temp),
      ],
    );
  }
}
