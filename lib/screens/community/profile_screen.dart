import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final List<Map<String, dynamic>> _posts = [
    {
      'content':
          'Just harvested my first organic tomatoes! The yield is amazing this year.',
      'likes': 24,
      'comments': 8,
      'time': '2 hours ago',
      'image': 'assets/images/tomatoes.jpg',
    },
    {
      'content':
          'Looking for advice on sustainable irrigation methods. Any recommendations?',
      'likes': 15,
      'comments': 12,
      'time': '5 hours ago',
    },
  ];

  final List<Map<String, dynamic>> _events = [
    {
      'title': 'Organic Farming Workshop',
      'date': 'March 15, 2024',
      'status': 'Registered',
    },
    {
      'title': 'Harvest Festival',
      'date': 'April 2, 2024',
      'status': 'Interested',
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
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
              expandedHeight: 300,
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
                      const SizedBox(height: 40),
                      const CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.white,
                        child: Text(
                          'J',
                          style: TextStyle(
                            fontSize: 40,
                            color: Colors.green,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'John Smith',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Organic Farmer',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.8),
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildProfileStats(),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
              bottom: TabBar(
                controller: _tabController,
                indicatorColor: Colors.white,
                indicatorWeight: 3,
                labelStyle: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                tabs: const [
                  Tab(text: 'Posts'),
                  Tab(text: 'Events'),
                ],
              ),
            ),
          ];
        },
        body: TabBarView(
          controller: _tabController,
          children: [
            _buildPostsTab(),
            _buildEventsTab(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Handle edit profile
        },
        backgroundColor: Colors.green[700],
        child: const Icon(Icons.edit),
      ),
    );
  }

  Widget _buildProfileStats() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem('Posts', '24'),
          _buildStatItem('Events', '8'),
          _buildStatItem('Connections', '156'),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              color: Colors.white.withOpacity(0.8),
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPostsTab() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _posts.length,
      itemBuilder: (context, index) {
        final post = _posts[index];
        return _buildPostCard(post);
      },
    );
  }

  Widget _buildPostCard(Map<String, dynamic> post) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(post['content']),
          ),
          if (post['image'] != null) ...[
            ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(bottom: Radius.circular(16)),
              child: Image.asset(
                post['image'],
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
          ],
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                _buildActionButton(
                  Icons.thumb_up_outlined,
                  '${post['likes']}',
                  () {
                    // Handle like
                  },
                ),
                const SizedBox(width: 16),
                _buildActionButton(
                  Icons.comment_outlined,
                  '${post['comments']}',
                  () {
                    // Handle comment
                  },
                ),
                const SizedBox(width: 16),
                _buildActionButton(
                  Icons.share_outlined,
                  'Share',
                  () {
                    // Handle share
                  },
                ),
                const Spacer(),
                Text(
                  post['time'],
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(IconData icon, String label, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.grey[600]),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEventsTab() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _events.length,
      itemBuilder: (context, index) {
        final event = _events[index];
        return _buildEventCard(event);
      },
    );
  }

  Widget _buildEventCard(Map<String, dynamic> event) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              event['title'],
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.calendar_today, size: 16),
                const SizedBox(width: 8),
                Text(event['date']),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.green[100],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    event['status'],
                    style: TextStyle(
                      color: Colors.green[700],
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
