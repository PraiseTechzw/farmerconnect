import 'package:farmer_connect/constants/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'constants/theme/themes_notifier.dart';
import 'screens/home/home_screen.dart';
import 'screens/marketplace/marketplace_screen.dart';
import 'screens/farm/farm_management_screen.dart';
import 'screens/community/community_screen.dart';
import 'screens/finance/finance_screen.dart';
import 'screens/ai/ai_chat_screen.dart';
import 'providers/crop_provider.dart';
import 'providers/ai_provider.dart';
import 'package:farmer_connect/service/firebase_service.dart';
import 'package:farmer_connect/service/supabase_service.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:farmer_connect/service/auth_service.dart';
import 'package:farmer_connect/screens/auth/login_screen.dart';
import 'package:farmer_connect/screens/onboarding/onboarding_screen.dart';
import 'package:farmer_connect/screens/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Load environment variables
  await dotenv.load();
  
  // Initialize Firebase
  await FirebaseService.initialize();
  
  // Initialize Supabase
  await SupabaseService.initialize(
    dotenv.env['SUPABASE_URL'] ?? '',
    dotenv.env['SUPABASE_ANON_KEY'] ?? '',
  );
  
  runApp(const FarmerConnectApp());
}

class FarmerConnectApp extends StatelessWidget {
  const FarmerConnectApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<CropProvider>(create: (_) => CropProvider()),
        ChangeNotifierProvider<ThemeNotifier>(create: (_) => ThemeNotifier()),
        ChangeNotifierProvider<AIProvider>(create: (_) => AIProvider()),
      ],
      child: Consumer<ThemeNotifier>(
        builder: (context, themeNotifier, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'FarmerConnect',
            theme: lightTheme,
            darkTheme: darkTheme,
            themeMode: themeNotifier.isDarkMode ? ThemeMode.dark : ThemeMode.light,
            home: const SplashScreen(),
            routes: {
              '/splash': (context) => const SplashScreen(),
              '/onboarding': (context) => const OnboardingScreen(),
              '/login': (context) => const LoginScreen(),
              '/home': (context) => const MainScreen(),
            },
          );
        },
      ),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const HomeScreen(),
    const MarketplaceScreen(),
    const FarmManagementScreen(),
    const CommunityScreen(),
    const FinanceScreen(),
    const AIChatScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.store),
            label: 'Marketplace',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.agriculture),
            label: 'Farm',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: 'Community',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_balance_wallet),
            label: 'Financial',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: 'AI Assistant',
          ),
        ],
      ),
    );
  }
}
