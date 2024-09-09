import 'dart:io';

import 'package:farmerconnect/service/gemini_api.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class FarmersAIScreen extends StatefulWidget {
  const FarmersAIScreen({super.key});

  @override
  State<FarmersAIScreen> createState() => _FarmersAIScreenState();
}

class _FarmersAIScreenState extends State<FarmersAIScreen> {
  final TextEditingController _inputController = TextEditingController();
  final GeminiService _geminiService = GeminiService();
  XFile? _image;
  List<Map<String, String>> _messages = [];
  bool _isLoading = false;
  bool _showIntro = true; // To control the visibility of the introduction

  // Image picker for camera or gallery input
  final ImagePicker _picker = ImagePicker();

  Future<void> _sendToAI() async {
    final userInput = _inputController.text.trim();

    if (userInput.isEmpty && _image == null) return;

    setState(() {
      _isLoading = true;
      _showIntro = false; // Hide intro when user starts interacting
    });

    try {
      // Add user message to chat
      setState(() {
        _messages.add({'text': userInput, 'type': 'user'});
      });

      String responseText = '';

      if (_image != null) {
        // Process image-based crop identification
        final cropDetails = await _geminiService.getCropDetails('Uploaded Image Crop', 'Your Location');
        responseText = cropDetails.description; // Update based on image analysis
      } else if (userInput.isNotEmpty) {
        // Process text-based request for farming advice
        responseText = await _geminiService.chatWithAI(userInput);
      }

      // Add AI response to chat
      setState(() {
        _messages.add({'text': responseText, 'type': 'ai'});
        _inputController.clear();
        _image = null;
      });
    } catch (e) {
      setState(() {
        _messages.add({'text': 'Error: $e', 'type': 'ai'});
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
      _showIntro = false; // Hide intro when user selects an image
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Farmer AI', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.deepPurple,
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
                      offset: Offset(0, 5),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
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
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                final isUserMessage = message['type'] == 'user';
                return Align(
                  alignment: isUserMessage ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
                    margin: const EdgeInsets.symmetric(vertical: 5),
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
                      message['text']!,
                      style: TextStyle(
                        color: isUserMessage ? Colors.white : Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ),
                );
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
                    offset: Offset(0, 4),
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
          Padding(
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
          ),
        ],
      ),
    );
  }
}
