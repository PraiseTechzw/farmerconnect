import 'dart:convert'; // For jsonEncode and jsonDecode

class ChatMessage {
  final String text;
  final bool isFromUser;

  ChatMessage({required this.text, required this.isFromUser});

  factory ChatMessage.fromJson(String json) {
    final data = jsonDecode(json) as Map<String, dynamic>;
    return ChatMessage(
      text: data['text'] as String, // Ensure proper type casting
      isFromUser: data['isFromUser'] as bool, // Ensure proper type casting
    );
  }

  String toJson() {
    return jsonEncode({
      'text': text,
      'isFromUser': isFromUser,
    });
  }
}
