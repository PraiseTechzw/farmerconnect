import 'dart:io';
import 'package:farmerconnect/service/gemini_api.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class FarmersAIScreen extends StatefulWidget {
  const FarmersAIScreen({super.key});

  @override
  State<FarmersAIScreen> createState() => _FarmersAIScreenState();
}

class _FarmersAIScreenState extends State<FarmersAIScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController _inputController = TextEditingController();
  final GeminiService _geminiService = GeminiService();
  XFile? _image;
  final List<Map<String, String>> _messages = [];
  bool _isLoading = false;
  bool _showIntro = true; // To control the visibility of the introduction
  bool _showTypingIndicator = false; // Typing indicator

  // Image picker for camera or gallery input
  final ImagePicker _picker = ImagePicker();

  // Animation controller for bubble animations
  late AnimationController _bubbleAnimationController;

  @override
  void initState() {
    super.initState();
    _bubbleAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
  }

  @override
  void dispose() {
    _bubbleAnimationController.dispose();
    super.dispose();
  }

  Future<void> _sendToAI() async {
    final userInput = _inputController.text.trim();

    if (userInput.isEmpty && _image == null) return;

    setState(() {
      _isLoading = true;
      _showIntro = false;
      _showTypingIndicator = true; // Show typing indicator
    });

    try {
      // Add user message to chat
      setState(() {
        _messages.add({'text': userInput, 'type': 'user'});
      });

      String responseText = '';

      if (_image != null) {
        final cropDetails = await _geminiService.getCropDetails('Uploaded Image Crop', 'Your Location');
        responseText = cropDetails.description; // Update based on image analysis
      } else if (userInput.isNotEmpty) {
        responseText = await _geminiService.chatWithAI(userInput);
      }

      // Simulate a delay for the AI "thinking"
      await Future.delayed(const Duration(seconds: 2));

      // Add AI response to chat
      setState(() {
        _messages.add({'text': responseText, 'type': 'ai'});
        _inputController.clear();
        _image = null;
        _showTypingIndicator = false;
      });

      // Animate the bubble appearance
      _bubbleAnimationController.forward(from: 0);
    } catch (e) {
      setState(() {
        _messages.add({'text': 'Error: $e', 'type': 'ai'});
        _showTypingIndicator = false;
      });
    }

    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _pickImage() async {
    final pickedImage = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = pickedImage;
      _showIntro = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Farmer AI', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.green[800],
        elevation: 0,
        centerTitle: true,
      ),
      body: Column(
        children: [
          if (_showIntro)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.deepPurple[50],
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Welcome to Farmer AI!',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.deepPurple),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'This screen allows you to interact with an AI system to get farming advice or identify crops. '
                        'You can either type a question or upload an image of your crop for identification.',
                        style: TextStyle(fontSize: 16, color: Colors.black87),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Start by typing your question below or uploading a crop image using the camera button.',
                        style: TextStyle(fontSize: 14, color: Colors.black54),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
              itemCount: _messages.length + (_showTypingIndicator ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == _messages.length && _showTypingIndicator) {
                  return _buildTypingIndicator(); // Typing indicator
                }

                final message = _messages[index];
                final isUserMessage = message['type'] == 'user';
                return _buildChatBubble(message['text']!, isUserMessage);
              },
            ),
          ),
          if (_image != null)
            Container(
              margin: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    spreadRadius: 2,
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.file(File(_image!.path), height: 150, width: 150, fit: BoxFit.cover),
              ),
            ),
          if (_isLoading)
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: CircularProgressIndicator(),
            ),
          _buildInputSection(),
        ],
      ),
    );
  }

  // Helper function to build chat bubbles with avatars
  Widget _buildChatBubble(String text, bool isUserMessage) {
    final avatar = isUserMessage
        ? const CircleAvatar(child: Icon(Icons.person, color: Colors.white), backgroundColor: Colors.deepPurple)
        : const CircleAvatar(child: Icon(Icons.android, color: Colors.white), backgroundColor: Colors.orange);

    return Align(
      alignment: isUserMessage ? Alignment.centerRight : Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: Row(
          mainAxisAlignment: isUserMessage ? MainAxisAlignment.end : MainAxisAlignment.start,
          children: [
            if (!isUserMessage) avatar,
            const SizedBox(width: 10),
            Container(
              constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.7),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isUserMessage ? Colors.deepPurple : Colors.deepOrangeAccent,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    spreadRadius: 2,
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Text(
                text,
                style: const TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
            const SizedBox(width: 10),
            if (isUserMessage) avatar,
          ],
        ),
      ),
    );
  }

  // Build a typing indicator for AI
  Widget _buildTypingIndicator() {
    return Row(
      children: [
        const CircleAvatar(
          child: Icon(Icons.android, color: Colors.white),
          backgroundColor: Colors.orange,
        ),
        const SizedBox(width: 10),
        const Text(
          'AI is typing...',
          style: TextStyle(color: Colors.deepOrangeAccent, fontSize: 16),
        ),
        const SizedBox(width: 10),
        CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.deepOrangeAccent),
          strokeWidth: 2,
        ),
      ],
    );
  }

  // Input section with animations and better styling
  Widget _buildInputSection() {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _inputController,
              decoration: InputDecoration(
                hintText: 'Type your message...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                filled: true,
                fillColor: Colors.grey[100],
              ),
            ),
          ),
          const SizedBox(width: 10),
          IconButton(
            icon: const Icon(Icons.camera_alt, color: Colors.deepPurple),
            onPressed: _pickImage,
          ),
          IconButton(
            icon: const Icon(Icons.send, color: Colors.deepPurple),
            onPressed: _sendToAI,
          ),
        ],
      ),
    );
  }
}
