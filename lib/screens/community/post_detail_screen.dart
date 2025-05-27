import 'package:flutter/material.dart';

class PostDetailScreen extends StatefulWidget {
  final Map<String, dynamic> post;

  const PostDetailScreen({super.key, required this.post});

  @override
  State<PostDetailScreen> createState() => _PostDetailScreenState();
}

class _PostDetailScreenState extends State<PostDetailScreen> {
  final TextEditingController _commentController = TextEditingController();
  final List<Map<String, dynamic>> _comments = [
    {
      'author': 'Sarah Johnson',
      'avatar': 'S',
      'content': 'Great harvest! What variety of tomatoes are you growing?',
      'time': '1 hour ago',
      'likes': 5,
    },
    {
      'author': 'Mike Brown',
      'avatar': 'M',
      'content': 'The yield looks amazing! What fertilizer did you use?',
      'time': '45 minutes ago',
      'likes': 3,
    },
  ];

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: widget.post['image'] != null
                  ? Image.asset(
                      widget.post['image'],
                      fit: BoxFit.cover,
                    )
                  : Container(
                      color: Colors.green[700],
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
                  _buildPostHeader(),
                  const SizedBox(height: 16),
                  Text(
                    widget.post['content'],
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 24),
                  _buildInteractionBar(),
                  const Divider(height: 32),
                  _buildCommentsSection(),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomSheet: _buildCommentInput(),
    );
  }

  Widget _buildPostHeader() {
    return Row(
      children: [
        CircleAvatar(
          backgroundColor: Colors.green[700],
          child: Text(
            widget.post['avatar'],
            style: const TextStyle(color: Colors.white),
          ),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.post['author'],
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            Text(
              widget.post['time'],
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 12,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildInteractionBar() {
    return Row(
      children: [
        _buildInteractionButton(
          Icons.thumb_up_outlined,
          '${widget.post['likes']}',
          () {
            // Handle like
          },
        ),
        const SizedBox(width: 24),
        _buildInteractionButton(
          Icons.comment_outlined,
          '${widget.post['comments']}',
          () {
            // Handle comment
          },
        ),
        const SizedBox(width: 24),
        _buildInteractionButton(
          Icons.bookmark_outline,
          'Save',
          () {
            // Handle save
          },
        ),
      ],
    );
  }

  Widget _buildInteractionButton(
      IconData icon, String label, VoidCallback onTap) {
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

  Widget _buildCommentsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Comments',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _comments.length,
          itemBuilder: (context, index) {
            final comment = _comments[index];
            return _buildCommentCard(comment);
          },
        ),
      ],
    );
  }

  Widget _buildCommentCard(Map<String, dynamic> comment) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            backgroundColor: Colors.green[700],
            child: Text(
              comment['avatar'],
              style: const TextStyle(color: Colors.white),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        comment['author'],
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(comment['content']),
                    ],
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      comment['time'],
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(width: 16),
                    TextButton(
                      onPressed: () {
                        // Handle reply
                      },
                      child: const Text('Reply'),
                    ),
                    const SizedBox(width: 16),
                    TextButton(
                      onPressed: () {
                        // Handle like
                      },
                      child: Text('${comment['likes']} Likes'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCommentInput() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, -1),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: Colors.green[700],
            child: const Text(
              'U',
              style: TextStyle(color: Colors.white),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              controller: _commentController,
              decoration: InputDecoration(
                hintText: 'Write a comment...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey[100],
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            icon: const Icon(Icons.send),
            color: Colors.green[700],
            onPressed: () {
              if (_commentController.text.isNotEmpty) {
                // Handle comment submission
                _commentController.clear();
              }
            },
          ),
        ],
      ),
    );
  }
}
