import 'dart:io';
import 'dart:typed_data'; // Added for Uint8List
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
  late final GeminiService _geminiService; // Make it late final
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
    // Initialize GeminiService using the factory
    GeminiService.create().then((service) {
      setState(() {
        _geminiService = service;
      });
    }).catchError((error) {
      // Handle error, e.g., show a snackbar or log
      print("Failed to initialize GeminiService: $error");
      // You might want to set a flag to disable AI features if initialization fails
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to initialize AI Service. Some features might not work. Error: $error')),
      );
    });
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

      if (!mounted) return; // Ensure widget is still mounted

      if (_image != null) {
        final Uint8List imageBytes = await _image!.readAsBytes();
        // Using null for location for now, as per instructions
        final diseaseInfoMap = await _geminiService.identifyDiseaseFromImage(imageBytes, null);

        if (diseaseInfoMap.containsKey('error')) {
          responseText = "Error identifying disease: ${diseaseInfoMap['error']}\nDetails: ${diseaseInfoMap['details']}";
        } else if (diseaseInfoMap.containsKey('diseaseInfo')) {
          List<dynamic> diseases = diseaseInfoMap['diseaseInfo'] as List<dynamic>;
          if (diseases.isEmpty) {
            responseText = "No diseases identified or the image was unclear.";
          } else {
            StringBuffer sb = StringBuffer();
            sb.writeln("Plant Disease Analysis:");
            for (var disease in diseases) {
              sb.writeln("\n**Disease:** ${disease['name'] ?? 'N/A'}");
              sb.writeln("**Symptoms:** ${disease['symptoms'] ?? 'N/A'}");
              sb.writeln("**Treatment:** ${disease['treatment'] ?? 'N/A'}");
              sb.writeln("**Prevention:** ${disease['prevention'] ?? 'N/A'}");
            }
            responseText = sb.toString();
          }
        } else {
          responseText = "Received an unexpected response format from the AI.";
        }
        // Clear the image after processing
        setState(() {
          _image = null; 
        });
      } else if (userInput.isNotEmpty) {
        responseText = await _geminiService.chatWithAI(userInput);
      }

      // Simulate a delay for the AI "thinking" - can be removed if not desired
      // await Future.delayed(const Duration(seconds: 1)); 

      if (!mounted) return;

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
    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Pick from Gallery'),
                onTap: () {
                  Navigator.of(context).pop(ImageSource.gallery);
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Take a Photo'),
                onTap: () {
                  Navigator.of(context).pop(ImageSource.camera);
                },
              ),
            ],
          ),
        );
      },
    );

    if (source != null) {
      try {
        final pickedImage = await _picker.pickImage(source: source);
        if (pickedImage != null) {
          setState(() {
            _image = pickedImage;
            _showIntro = false; // Hide intro text when an image is selected
          });
        }
      } catch (e) {
        // Handle potential errors during image picking (e.g., permission issues)
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error picking image: $e')),
          );
        }
        print('Error picking image: $e');
      }
    }
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
