import 'package:flutter/material.dart';
import 'package:farmer_connect/screens/community/post_detail_screen.dart';
import 'package:farmer_connect/screens/community/event_detail_screen.dart';
import 'package:farmer_connect/screens/community/chat_screen.dart';

class CommunityScreen extends StatefulWidget {
  const CommunityScreen({super.key});

  @override
  State<CommunityScreen> createState() => _CommunityScreenState();
}

class _CommunityScreenState extends State<CommunityScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final List<Map<String, dynamic>> _featuredEvents = [
    {
      'title': 'Organic Farming Workshop',
      'date': 'March 15, 2024',
      'location': 'Green Valley Farm',
      'image': 'assets/images/workshop.jpg',
      'attendees': 45,
    },
    {
      'title': 'Harvest Festival',
      'date': 'April 2, 2024',
      'location': 'Sunset Fields',
      'image': 'assets/images/festival.jpg',
      'attendees': 120,
    },
  ];

  final List<Map<String, dynamic>> _recentPosts = [
    {
      'author': 'John Smith',
      'avatar': 'J',
      'content': 'Just harvested my first organic tomatoes! The yield is amazing this year.',
      'likes': 24,
      'comments': 8,
      'time': '2 hours ago',
      'image': 'assets/images/tomatoes.jpg',
    },
    {
      'author': 'Maria Garcia',
      'avatar': 'M',
      'content': 'Looking for advice on sustainable irrigation methods. Any recommendations?',
      'likes': 15,
      'comments': 12,
      'time': '5 hours ago',
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
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
              elevation: 0,
              backgroundColor: Colors.green[700],
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
                      const Text(
                        'Farmer Community',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildCommunityStats(),
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
                  Tab(text: 'Feed'),
                  Tab(text: 'Events'),
                  Tab(text: 'Connect'),
                ],
              ),
            ),
          ];
        },
        body: TabBarView(
          controller: _tabController,
          children: [
            _buildFeedTab(),
            _buildEventsTab(),
            _buildConnectTab(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          _showCreatePostDialog();
        },
        icon: const Icon(Icons.add),
        label: const Text('New Post'),
        backgroundColor: Colors.green[700],
      ),
    );
  }

  Widget _buildCommunityStats() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem('Members', '1.2K', Icons.people),
          _buildStatItem('Events', '24', Icons.event),
          _buildStatItem('Posts', '3.5K', Icons.article),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.white, size: 20),
          const SizedBox(width: 8),
          Column(
            children: [
              Text(
                value,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFeedTab() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _recentPosts.length,
      itemBuilder: (context, index) {
        final post = _recentPosts[index];
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
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PostDetailScreen(post: post),
            ),
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.green[700],
                child: Text(
                  post['avatar'],
                  style: const TextStyle(color: Colors.white),
                ),
              ),
              title: Text(
                post['author'],
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(post['time']),
              trailing: IconButton(
                icon: const Icon(Icons.more_vert),
                onPressed: () {
                  // Show post options
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(post['content']),
            ),
            if (post['image'] != null) ...[
              const SizedBox(height: 8),
              ClipRRect(
                borderRadius: const BorderRadius.vertical(bottom: Radius.circular(16)),
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
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PostDetailScreen(post: post),
                        ),
                      );
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
                ],
              ),
            ),
          ],
        ),
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
      itemCount: _featuredEvents.length,
      itemBuilder: (context, index) {
        final event = _featuredEvents[index];
        return _buildEventCard(event);
      },
    );
  }

  Widget _buildEventCard(Map<String, dynamic> event) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => EventDetailScreen(event: event),
            ),
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
              child: Image.asset(
                event['image'],
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    event['title'],
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.calendar_today, size: 16),
                      const SizedBox(width: 8),
                      Text(event['date']),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.location_on, size: 16),
                      const SizedBox(width: 8),
                      Text(event['location']),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.people, size: 16),
                      const SizedBox(width: 8),
                      Text('${event['attendees']} attending'),
                    ],
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EventDetailScreen(event: event),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green[700],
                      minimumSize: const Size(double.infinity, 45),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('Register Now'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildConnectTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildSearchBar(),
        const SizedBox(height: 16),
        _buildSuggestedConnections(),
      ],
    );
  }

  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextField(
        decoration: const InputDecoration(
          hintText: 'Search farmers...',
          border: InputBorder.none,
          icon: Icon(Icons.search),
        ),
      ),
    );
  }

  Widget _buildSuggestedConnections() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Suggested Connections',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: 5,
          itemBuilder: (context, index) {
            return _buildConnectionCard();
          },
        ),
      ],
    );
  }

  Widget _buildConnectionCard() {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.green[700],
          child: const Text('F'),
        ),
        title: const Text('Farmer Name'),
        subtitle: const Text('Specializes in Organic Farming'),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.message_outlined),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChatScreen(
                      user: {
                        'name': 'Farmer Name',
                        'avatar': 'F',
                      },
                    ),
                  ),
                );
              },
            ),
            ElevatedButton(
              onPressed: () {
                // Handle connection request
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green[700],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: const Text('Connect'),
            ),
          ],
        ),
      ),
    );
  }

  void _showCreatePostDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Create Post',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                maxLines: 4,
                decoration: const InputDecoration(
                  hintText: 'What\'s on your mind?',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.image),
                    onPressed: () {
                      // Handle image upload
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.location_on),
                    onPressed: () {
                      // Handle location
                    },
                  ),
                  const Spacer(),
                  ElevatedButton(
                    onPressed: () {
                      // Handle post creation
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green[700],
                    ),
                    child: const Text('Post'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
} 