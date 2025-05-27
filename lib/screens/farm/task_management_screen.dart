import 'package:flutter/material.dart';

class TaskManagementScreen extends StatefulWidget {
  const TaskManagementScreen({super.key});

  @override
  State<TaskManagementScreen> createState() => _TaskManagementScreenState();
}

class _TaskManagementScreenState extends State<TaskManagementScreen> {
  final List<Map<String, dynamic>> _tasks = [
    {
      'title': 'Fertilize Wheat Field',
      'description': 'Apply organic fertilizer to the wheat field',
      'dueDate': '2024-03-20',
      'priority': 'High',
      'status': 'Pending',
      'assignedTo': 'John Doe',
      'category': 'Field Work',
    },
    {
      'title': 'Irrigate Corn Field',
      'description': 'Set up irrigation system for corn field',
      'dueDate': '2024-03-18',
      'priority': 'Medium',
      'status': 'In Progress',
      'assignedTo': 'Jane Smith',
      'category': 'Irrigation',
    },
    {
      'title': 'Harvest Soybeans',
      'description': 'Harvest soybeans from Field B',
      'dueDate': '2024-03-25',
      'priority': 'High',
      'status': 'Pending',
      'assignedTo': 'Mike Johnson',
      'category': 'Harvest',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Task Management'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              _showFilterDialog();
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildTaskSummary(),
          const SizedBox(height: 24),
          _buildTaskList(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddTaskDialog();
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildTaskSummary() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Task Summary',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildSummaryItem('Total Tasks', '12', Icons.task),
                _buildSummaryItem('Pending', '5', Icons.pending),
                _buildSummaryItem('In Progress', '3', Icons.work),
                _buildSummaryItem('Completed', '4', Icons.check_circle),
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

  Widget _buildTaskList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'All Tasks',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        ..._tasks.map((task) {
          return Card(
            margin: const EdgeInsets.only(bottom: 16),
            child: ExpansionTile(
              leading: CircleAvatar(
                backgroundColor: _getPriorityColor(task['priority'] as String).withOpacity(0.1),
                child: Icon(
                  _getTaskIcon(task['category'] as String),
                  color: _getPriorityColor(task['priority'] as String),
                ),
              ),
              title: Text(
                task['title'] as String,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Due: ${task['dueDate']}'),
                  Text('Assigned to: ${task['assignedTo']}'),
                ],
              ),
              trailing: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: _getStatusColor(task['status'] as String).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  task['status'] as String,
                  style: TextStyle(
                    color: _getStatusColor(task['status'] as String),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Description:',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(task['description'] as String),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton.icon(
                            onPressed: () {
                              _showEditTaskDialog(task);
                            },
                            icon: const Icon(Icons.edit),
                            label: const Text('Edit'),
                          ),
                          ElevatedButton.icon(
                            onPressed: () {
                              _showUpdateStatusDialog(task);
                            },
                            icon: const Icon(Icons.update),
                            label: const Text('Update Status'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ],
    );
  }

  Color _getPriorityColor(String priority) {
    switch (priority.toLowerCase()) {
      case 'high':
        return Colors.red;
      case 'medium':
        return Colors.orange;
      case 'low':
        return Colors.green;
      default:
        return Colors.blue;
    }
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return Colors.orange;
      case 'in progress':
        return Colors.blue;
      case 'completed':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  IconData _getTaskIcon(String category) {
    switch (category.toLowerCase()) {
      case 'field work':
        return Icons.agriculture;
      case 'irrigation':
        return Icons.water_drop;
      case 'harvest':
        return Icons.agriculture;
      default:
        return Icons.task;
    }
  }

  void _showAddTaskDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add New Task'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: const InputDecoration(
                labelText: 'Task Title',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              decoration: const InputDecoration(
                labelText: 'Description',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            TextField(
              decoration: const InputDecoration(
                labelText: 'Due Date',
                border: OutlineInputBorder(),
              ),
              readOnly: true,
              onTap: () async {
                final date = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now().add(const Duration(days: 365)),
                );
                if (date != null) {
                  // Update date field
                }
              },
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: 'Priority',
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(
                  value: 'High',
                  child: Text('High'),
                ),
                DropdownMenuItem(
                  value: 'Medium',
                  child: Text('Medium'),
                ),
                DropdownMenuItem(
                  value: 'Low',
                  child: Text('Low'),
                ),
              ],
              onChanged: (value) {},
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: 'Category',
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(
                  value: 'Field Work',
                  child: Text('Field Work'),
                ),
                DropdownMenuItem(
                  value: 'Irrigation',
                  child: Text('Irrigation'),
                ),
                DropdownMenuItem(
                  value: 'Harvest',
                  child: Text('Harvest'),
                ),
              ],
              onChanged: (value) {},
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: 'Assign To',
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(
                  value: 'John Doe',
                  child: Text('John Doe'),
                ),
                DropdownMenuItem(
                  value: 'Jane Smith',
                  child: Text('Jane Smith'),
                ),
                DropdownMenuItem(
                  value: 'Mike Johnson',
                  child: Text('Mike Johnson'),
                ),
              ],
              onChanged: (value) {},
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
              // Add task
              Navigator.pop(context);
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  void _showEditTaskDialog(Map<String, dynamic> task) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Task'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: const InputDecoration(
                labelText: 'Task Title',
                border: OutlineInputBorder(),
              ),
              controller: TextEditingController(text: task['title'] as String),
            ),
            const SizedBox(height: 16),
            TextField(
              decoration: const InputDecoration(
                labelText: 'Description',
                border: OutlineInputBorder(),
              ),
              controller: TextEditingController(text: task['description'] as String),
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            TextField(
              decoration: const InputDecoration(
                labelText: 'Due Date',
                border: OutlineInputBorder(),
              ),
              controller: TextEditingController(text: task['dueDate'] as String),
              readOnly: true,
              onTap: () async {
                final date = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now().add(const Duration(days: 365)),
                );
                if (date != null) {
                  // Update date field
                }
              },
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
              // Update task
              Navigator.pop(context);
            },
            child: const Text('Update'),
          ),
        ],
      ),
    );
  }

  void _showUpdateStatusDialog(Map<String, dynamic> task) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Update Task Status'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: 'Status',
                border: OutlineInputBorder(),
              ),
              value: task['status'] as String,
              items: const [
                DropdownMenuItem(
                  value: 'Pending',
                  child: Text('Pending'),
                ),
                DropdownMenuItem(
                  value: 'In Progress',
                  child: Text('In Progress'),
                ),
                DropdownMenuItem(
                  value: 'Completed',
                  child: Text('Completed'),
                ),
              ],
              onChanged: (value) {},
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
              // Update status
              Navigator.pop(context);
            },
            child: const Text('Update'),
          ),
        ],
      ),
    );
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Filter Tasks'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: 'Status',
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(
                  value: 'All',
                  child: Text('All'),
                ),
                DropdownMenuItem(
                  value: 'Pending',
                  child: Text('Pending'),
                ),
                DropdownMenuItem(
                  value: 'In Progress',
                  child: Text('In Progress'),
                ),
                DropdownMenuItem(
                  value: 'Completed',
                  child: Text('Completed'),
                ),
              ],
              onChanged: (value) {},
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: 'Priority',
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(
                  value: 'All',
                  child: Text('All'),
                ),
                DropdownMenuItem(
                  value: 'High',
                  child: Text('High'),
                ),
                DropdownMenuItem(
                  value: 'Medium',
                  child: Text('Medium'),
                ),
                DropdownMenuItem(
                  value: 'Low',
                  child: Text('Low'),
                ),
              ],
              onChanged: (value) {},
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: 'Category',
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(
                  value: 'All',
                  child: Text('All'),
                ),
                DropdownMenuItem(
                  value: 'Field Work',
                  child: Text('Field Work'),
                ),
                DropdownMenuItem(
                  value: 'Irrigation',
                  child: Text('Irrigation'),
                ),
                DropdownMenuItem(
                  value: 'Harvest',
                  child: Text('Harvest'),
                ),
              ],
              onChanged: (value) {},
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
              // Apply filters
              Navigator.pop(context);
            },
            child: const Text('Apply'),
          ),
        ],
      ),
    );
  }
} 