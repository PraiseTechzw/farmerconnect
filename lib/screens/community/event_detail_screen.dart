import 'package:flutter/material.dart';

class EventDetailScreen extends StatefulWidget {
  final Map<String, dynamic> event;

  const EventDetailScreen({super.key, required this.event});

  @override
  State<EventDetailScreen> createState() => _EventDetailScreenState();
}

class _EventDetailScreenState extends State<EventDetailScreen> {
  bool _isRegistered = false;
  final List<Map<String, dynamic>> _attendees = [
    {
      'name': 'John Smith',
      'avatar': 'J',
      'role': 'Organic Farmer',
    },
    {
      'name': 'Maria Garcia',
      'avatar': 'M',
      'role': 'Sustainable Agriculture Expert',
    },
    {
      'name': 'David Wilson',
      'avatar': 'D',
      'role': 'Farm Manager',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Image.asset(
                widget.event['image'],
                fit: BoxFit.cover,
              ),
            ),
            leading: IconButton(
              icon: const CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(Icons.arrow_back, color: Colors.black),
              ),
              onPressed: () => Navigator.pop(context),
            ),
            actions: [
              IconButton(
                icon: const CircleAvatar(
                  backgroundColor: Colors.white,
                  child: Icon(Icons.share, color: Colors.black),
                ),
                onPressed: () {
                  // Handle share
                },
              ),
            ],
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.event['title'],
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildEventInfo(),
                  const SizedBox(height: 24),
                  _buildEventDescription(),
                  const SizedBox(height: 24),
                  _buildAttendeesSection(),
                  const SizedBox(height: 24),
                  _buildRegistrationButton(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEventInfo() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          _buildInfoRow(
            Icons.calendar_today,
            'Date',
            widget.event['date'],
          ),
          const SizedBox(height: 12),
          _buildInfoRow(
            Icons.location_on,
            'Location',
            widget.event['location'],
          ),
          const SizedBox(height: 12),
          _buildInfoRow(
            Icons.people,
            'Attendees',
            '${widget.event['attendees']} registered',
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Colors.grey[600]),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 12,
              ),
            ),
            Text(
              value,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildEventDescription() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'About Event',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          'Join us for an exciting workshop on organic farming techniques. Learn from industry experts about sustainable agriculture practices, soil management, and crop rotation methods. This hands-on workshop will provide valuable insights for both beginners and experienced farmers.',
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey[800],
            height: 1.5,
          ),
        ),
      ],
    );
  }

  Widget _buildAttendeesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Attendees',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _attendees.length,
          itemBuilder: (context, index) {
            final attendee = _attendees[index];
            return _buildAttendeeCard(attendee);
          },
        ),
      ],
    );
  }

  Widget _buildAttendeeCard(Map<String, dynamic> attendee) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.green[700],
          child: Text(
            attendee['avatar'],
            style: const TextStyle(color: Colors.white),
          ),
        ),
        title: Text(attendee['name']),
        subtitle: Text(attendee['role']),
        trailing: IconButton(
          icon: const Icon(Icons.message_outlined),
          onPressed: () {
            // Handle message
          },
        ),
      ),
    );
  }

  Widget _buildRegistrationButton() {
    return ElevatedButton(
      onPressed: () {
        setState(() {
          _isRegistered = !_isRegistered;
        });
        // Handle registration
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: _isRegistered ? Colors.grey : Colors.green[700],
        minimumSize: const Size(double.infinity, 50),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: Text(
        _isRegistered ? 'Cancel Registration' : 'Register Now',
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
} 