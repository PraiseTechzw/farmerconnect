import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  final Map<DateTime, List<Map<String, dynamic>>> _events = {
    DateTime.now(): [
      {
        'title': 'Harvest Wheat',
        'icon': Icons.agriculture,
        'color': Colors.orange,
      },
    ],
    DateTime.now().add(const Duration(days: 2)): [
      {
        'title': 'Irrigation System Maintenance',
        'icon': Icons.water_drop,
        'color': Colors.blue,
      },
    ],
  };

  List<Map<String, dynamic>> _getEventsForDay(DateTime day) {
    return _events[day] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Farm Calendar'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showAddEventDialog(),
          ),
        ],
      ),
      body: Column(
        children: [
          TableCalendar(
            firstDay: DateTime.utc(2024, 1, 1),
            lastDay: DateTime.utc(2024, 12, 31),
            focusedDay: _focusedDay,
            calendarFormat: _calendarFormat,
            selectedDayPredicate: (day) {
              return isSameDay(_selectedDay, day);
            },
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
            },
            onFormatChanged: (format) {
              setState(() {
                _calendarFormat = format;
              });
            },
            eventLoader: _getEventsForDay,
            calendarStyle: const CalendarStyle(
              markersMaxCount: 1,
              markerDecoration: BoxDecoration(
                color: Colors.blue,
                shape: BoxShape.circle,
              ),
            ),
          ),
          const Divider(),
          Expanded(
            child: _selectedDay == null
                ? const Center(child: Text('Select a day to view events'))
                : ListView.builder(
                    itemCount: _getEventsForDay(_selectedDay!).length,
                    itemBuilder: (context, index) {
                      final event = _getEventsForDay(_selectedDay!)[index];
                      return ListTile(
                        leading: Icon(event['icon'], color: event['color']),
                        title: Text(event['title']),
                        trailing: IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () => _showEditEventDialog(event),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  void _showAddEventDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Event'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: const InputDecoration(
                labelText: 'Event Title',
              ),
              onChanged: (value) {
                // Handle title input
              },
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<IconData>(
              decoration: const InputDecoration(
                labelText: 'Event Type',
              ),
              items: const [
                DropdownMenuItem(
                  value: Icons.agriculture,
                  child: Text('Harvest'),
                ),
                DropdownMenuItem(
                  value: Icons.water_drop,
                  child: Text('Irrigation'),
                ),
                DropdownMenuItem(
                  value: Icons.engineering,
                  child: Text('Maintenance'),
                ),
              ],
              onChanged: (value) {
                // Handle icon selection
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              // Handle event creation
              Navigator.pop(context);
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  void _showEditEventDialog(Map<String, dynamic> event) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Event'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: const InputDecoration(
                labelText: 'Event Title',
              ),
              controller: TextEditingController(text: event['title']),
              onChanged: (value) {
                // Handle title update
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              // Handle event update
              Navigator.pop(context);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
} 