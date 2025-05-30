import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:farmer_connect/providers/ai_provider.dart';
import 'package:farmer_connect/service/weather_service.dart';
import 'package:farmer_connect/service/location_services.dart';

class AIChatScreen extends StatefulWidget {
  const AIChatScreen({Key? key}) : super(key: key);

  @override
  _AIChatScreenState createState() => _AIChatScreenState();
}

class _AIChatScreenState extends State<AIChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  late WeatherApiService _weatherApiService;
  late LocationService _locationService;
  Map<String, dynamic>? _weatherData;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _weatherApiService = WeatherApiService();
    _locationService = LocationService();
    _fetchWeatherData();
  }

  Future<void> _fetchWeatherData() async {
    try {
      final position = await _locationService.getCurrentLocation();
      final weatherData = await _weatherApiService.fetchWeather(
        position['latitude'],
        position['longitude'],
      );
      setState(() {
        _weatherData = weatherData;
      });
    } catch (error) {
      print('Error fetching weather data: $error');
    }
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  Future<void> _sendMessage() async {
    if (_messageController.text.trim().isEmpty) return;

    final message = _messageController.text.trim();
    _messageController.clear();

    final aiProvider = Provider.of<AIProvider>(context, listen: false);
    setState(() => _isLoading = true);

    try {
      await aiProvider.sendMessage(message);
      _scrollToBottom();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Farming Assistant'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _fetchWeatherData,
          ),
        ],
      ),
      body: Column(
        children: [
          if (_weatherData != null) _buildWeatherContext(),
          Expanded(
            child: Consumer<AIProvider>(
              builder: (context, aiProvider, child) {
                return ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.all(16),
                  itemCount: aiProvider.messages.length,
                  itemBuilder: (context, index) {
                    final message = aiProvider.messages[index];
                    return _buildMessageBubble(message);
                  },
                );
              },
            ),
          ),
          _buildMessageInput(),
        ],
      ),
    );
  }

  Widget _buildWeatherContext() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        border: Border(
          bottom: BorderSide(
            color: Colors.blue[100]!,
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          Icon(
            _getWeatherIcon(_weatherData?['currentConditions']['conditions']),
            color: Colors.blue[700],
            size: 32,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Current Weather',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.blue[900],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${_weatherData?['currentConditions']['temp']}°C, ${_weatherData?['currentConditions']['conditions']}',
                  style: TextStyle(
                    color: Colors.blue[700],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(Map<String, dynamic> message) {
    final isUser = message['isUser'] as bool;
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisAlignment:
            isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isUser) _buildAvatar(),
          const SizedBox(width: 8),
          Flexible(
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isUser ? Colors.blue[100] : Colors.grey[200],
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                message['text'] as String,
                style: TextStyle(
                  color: isUser ? Colors.blue[900] : Colors.black87,
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          if (isUser) _buildUserAvatar(),
        ],
      ),
    );
  }

  Widget _buildAvatar() {
    return CircleAvatar(
      backgroundColor: Colors.green[100],
      child: const Icon(
        Icons.agriculture,
        color: Colors.green,
      ),
    );
  }

  Widget _buildUserAvatar() {
    return CircleAvatar(
      backgroundColor: Colors.blue[100],
      child: const Icon(
        Icons.person,
        color: Colors.blue,
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
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, -1),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _messageController,
                decoration: InputDecoration(
                  hintText: 'Ask about farming, weather, or crops...',
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
                maxLines: null,
                textInputAction: TextInputAction.send,
                onSubmitted: (_) => _sendMessage(),
              ),
            ),
            const SizedBox(width: 8),
            Container(
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(24),
              ),
              child: IconButton(
                icon: _isLoading
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : const Icon(
                        Icons.send,
                        color: Colors.white,
                      ),
                onPressed: _isLoading ? null : _sendMessage,
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getWeatherIcon(String? condition) {
    if (condition == null) return Icons.wb_sunny;

    condition = condition.toLowerCase();
    if (condition.contains('rain')) return Icons.grain;
    if (condition.contains('cloud')) return Icons.cloud;
    if (condition.contains('snow')) return Icons.ac_unit;
    if (condition.contains('thunder')) return Icons.flash_on;
    return Icons.wb_sunny;
  }
} 