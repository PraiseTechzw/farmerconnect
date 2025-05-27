import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  final Map<String, dynamic> user;

  const ChatScreen({super.key, required this.user});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final List<Map<String, dynamic>> _messages = [
    {
      'content': 'Hi! How are you?',
      'isMe': false,
      'time': '10:30 AM',
    },
    {
      'content': 'I\'m good, thanks! How about you?',
      'isMe': true,
      'time': '10:31 AM',
    },
    {
      'content':
          'I\'m doing great! I wanted to ask about your organic farming techniques.',
      'isMe': false,
      'time': '10:32 AM',
    },
    {
      'content':
          'Sure! I\'d be happy to share my experience with organic farming.',
      'isMe': true,
      'time': '10:33 AM',
    },
  ];

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              backgroundColor: Colors.green[700],
              child: Text(
                widget.user['avatar'],
                style: const TextStyle(color: Colors.white),
              ),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.user['name'],
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Online',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.green[300],
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.video_call),
            onPressed: () {
              // Handle video call
            },
          ),
          IconButton(
            icon: const Icon(Icons.call),
            onPressed: () {
              // Handle voice call
            },
          ),
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {
              // Handle more options
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                return _buildMessageBubble(message);
              },
            ),
          ),
          _buildMessageInput(),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(Map<String, dynamic> message) {
    return Align(
      alignment: message['isMe'] ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: message['isMe'] ? Colors.green[700] : Colors.grey[200],
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              message['content'],
              style: TextStyle(
                color: message['isMe'] ? Colors.white : Colors.black,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              message['time'],
              style: TextStyle(
                color: message['isMe']
                    ? Colors.white.withOpacity(0.7)
                    : Colors.grey[600],
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageInput() {
    return Container(
      padding: const EdgeInsets.all(8),
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
          IconButton(
            icon: const Icon(Icons.attach_file),
            onPressed: () {
              // Handle attachment
            },
          ),
          Expanded(
            child: TextField(
              controller: _messageController,
              decoration: InputDecoration(
                hintText: 'Type a message...',
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
          IconButton(
            icon: const Icon(Icons.send),
            color: Colors.green[700],
            onPressed: () {
              if (_messageController.text.isNotEmpty) {
                setState(() {
                  _messages.add({
                    'content': _messageController.text,
                    'isMe': true,
                    'time': 'Now',
                  });
                });
                _messageController.clear();
              }
            },
          ),
        ],
      ),
    );
  }
}
