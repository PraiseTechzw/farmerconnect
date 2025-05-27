import 'package:farmer_connect/screens/farmers_interaction_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:farmer_connect/service/location_services.dart';
import 'package:farmer_connect/service/weather_service.dart';
import 'package:farmer_connect/widgets/weather_card.dart';
import 'package:farmer_connect/widgets/crop_recomm.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late WeatherApiService _weatherApiService;
  late LocationService _locationService;
  Map<String, dynamic>? _weatherData;
  String? _location;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _weatherApiService = WeatherApiService();
    _locationService = LocationService();
    _fetchWeatherData();
  }

  Future<void> _fetchWeatherData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final position = await _locationService.getCurrentLocation();
      final weatherData = await _weatherApiService.fetchWeather(
          position.latitude, position.longitude);
      _location = '${position.latitude}, ${position.longitude}';

      setState(() {
        _weatherData = weatherData;
        _isLoading = false;
      });
    } catch (error) {
      setState(() {
        _isLoading = false;
      });
      print('Error fetching weather data: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('FarmerConnect'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {
              // Handle notifications
            },
          ),
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              // Handle profile
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _fetchWeatherData,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildWeatherCard(),
              _buildQuickActions(),
              _buildCropRecommendations(),
              _buildMarketInsights(),
              _buildRecentActivities(),
              _buildImportantNotifications(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWeatherCard() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Weather Update',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _location ?? 'Farm Location',
                      style: TextStyle(
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
                Icon(
                  _getWeatherIcon(
                      _weatherData?['currentConditions']['conditions']),
                  size: 48,
                  color: Colors.orange,
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildWeatherInfo('Temperature',
                    '${_weatherData?['currentConditions']['temp']}°C'),
                _buildWeatherInfo('Humidity',
                    '${_weatherData?['currentConditions']['humidity']}%'),
                _buildWeatherInfo('Wind',
                    '${_weatherData?['currentConditions']['windspeed']} km/h'),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              _getWeatherForecast(
                  _weatherData?['currentConditions']['conditions']),
              style: const TextStyle(
                fontSize: 14,
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

  String _getWeatherForecast(String? condition) {
    if (condition == null) return 'Weather data unavailable';

    condition = condition.toLowerCase();
    if (condition.contains('rain')) {
      return 'Rain expected. Consider protecting your crops and postponing outdoor activities.';
    } else if (condition.contains('cloud')) {
      return 'Cloudy conditions. Good for certain crops but monitor for potential rain.';
    } else if (condition.contains('snow')) {
      return 'Snow expected. Take necessary precautions for temperature-sensitive crops.';
    } else if (condition.contains('thunder')) {
      return 'Thunderstorm warning. Secure equipment and protect livestock.';
    }
    return 'Clear weather. Perfect for outdoor farming activities.';
  }

  Widget _buildWeatherInfo(String label, String value) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildQuickActions() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Quick Actions',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 4,
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            children: [
              _buildActionButton(Icons.agriculture, 'Add Crop', () {
                // Navigate to add crop screen
              }),
              _buildActionButton(Icons.inventory, 'Inventory', () {
                // Navigate to inventory screen
              }),
              _buildActionButton(Icons.store, 'Market', () {
                // Navigate to marketplace screen
              }),
              _buildActionButton(Icons.calendar_today, 'Schedule', () {
                // Navigate to schedule screen
              }),
              _buildActionButton(Icons.analytics, 'Analytics', () {
                // Navigate to analytics screen
              }),
              _buildActionButton(Icons.people, 'Community', () {
                // Navigate to community screen
              }),
              _buildActionButton(Icons.account_balance_wallet, 'Finance', () {
                // Navigate to finance screen
              }),
              _buildActionButton(Icons.settings, 'Settings', () {
                // Navigate to settings screen
              }),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(IconData icon, String label, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.blue[100],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: Colors.blue[700],
              size: 24,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildCropRecommendations() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Recommended Crops',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 180,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 5,
              itemBuilder: (context, index) {
                return Card(
                  margin: const EdgeInsets.only(right: 16),
                  child: Container(
                    width: 160,
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 80,
                          decoration: BoxDecoration(
                            color: Colors.green[100],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Center(
                            child: Icon(
                              _getCropIcon(index),
                              size: 40,
                              color: Colors.green[700],
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _getCropName(index),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _getCropDescription(index),
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  IconData _getCropIcon(int index) {
    final cropIcons = {
      'Wheat': Icons.grain,
      'Rice': Icons.grass,
      'Corn': Icons.eco,
      'Soybeans': Icons.spa,
      'Cotton': Icons.filter_drama,
    };

    final cropName = _getCropName(index);
    return cropIcons[cropName] ?? Icons.agriculture;
  }

  String _getCropName(int index) {
    final crops = [
      'Wheat',
      'Rice',
      'Corn',
      'Soybeans',
      'Cotton',
    ];
    return crops[index % crops.length];
  }

  String _getCropDescription(int index) {
    final descriptions = [
      'Best suited for current weather conditions',
      'High market demand, good profit potential',
      'Low maintenance, high yield variety',
      'Drought-resistant, perfect for current season',
      'Organic variety, premium market price',
    ];
    return descriptions[index % descriptions.length];
  }

  Widget _buildMarketInsights() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Market Insights',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Current Market Prices',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          // Navigate to detailed market prices
                        },
                        child: const Text('View All'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _buildMarketPriceItem('Wheat', '\$250/ton', '+5%'),
                  _buildMarketPriceItem('Rice', '\$300/ton', '-2%'),
                  _buildMarketPriceItem('Corn', '\$200/ton', '+3%'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMarketPriceItem(String crop, String price, String change) {
    final isPositive = change.startsWith('+');
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(crop),
          Row(
            children: [
              Text(
                price,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                change,
                style: TextStyle(
                  color: isPositive ? Colors.green : Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRecentActivities() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Recent Activities',
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
              return Card(
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.blue[100],
                    child: Icon(
                      _getActivityIcon(index),
                      color: Colors.blue[700],
                    ),
                  ),
                  title: Text(_getActivityTitle(index)),
                  subtitle: Text('${index + 1} hours ago'),
                  trailing: IconButton(
                    icon: const Icon(Icons.arrow_forward_ios, size: 16),
                    onPressed: () {
                      // Handle activity details
                    },
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  IconData _getActivityIcon(int index) {
    final icons = [
      Icons.agriculture,
      Icons.store,
      Icons.people,
      Icons.account_balance_wallet,
      Icons.calendar_today,
    ];
    return icons[index % icons.length];
  }

  String _getActivityTitle(int index) {
    final titles = [
      'New crop planted',
      'Market sale completed',
      'Community event attended',
      'Financial report generated',
      'Schedule updated',
    ];
    return titles[index % titles.length];
  }

  Widget _buildImportantNotifications() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Important Notifications',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Card(
            color: Colors.orange[50],
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.warning_amber_rounded,
                        color: Colors.orange[700],
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'Weather Alert',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Heavy rainfall expected in the next 24 hours. Take necessary precautions for your crops.',
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
          Card(
            color: Colors.green[50],
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.calendar_today,
                        color: Colors.green[700],
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'Upcoming Event',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Agricultural workshop on sustainable farming practices tomorrow at 10 AM.',
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
