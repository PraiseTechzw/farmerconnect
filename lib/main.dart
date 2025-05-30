import 'package:farmer_connect/constants/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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
import 'package:farmer_connect/screens/auth/login_screen.dart';
import 'package:farmer_connect/screens/onboarding/onboarding_screen.dart';
import 'package:farmer_connect/screens/splash_screen.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:farmer_connect/providers/finance_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Load environment variables
  await dotenv.load();
  
  // Initialize Firebase
  await Firebase.initializeApp();
  
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
        ChangeNotifierProvider(create: (_) => FinanceProvider()),
      ],
      child: Consumer<ThemeNotifier>(
        builder: (context, themeNotifier, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'FarmerConnect',
            theme: lightTheme,
            darkTheme: darkTheme,
            themeMode: themeNotifier.isDarkMode ? ThemeMode.dark : ThemeMode.light,
            home: MainScreen(),
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
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  late final List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _screens = [
      const HomeScreen(),
      const MarketplaceScreen(),
      const FarmManagementScreen(),
      const CommunityScreen(),
      const FinanceScreen(),
      const AIChatScreen(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: SalomonBottomBar(
          currentIndex: _selectedIndex,
          onTap: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
          items: [
            SalomonBottomBarItem(
              icon: const Icon(Icons.home_rounded),
              title: const Text('Home'),
              selectedColor: Colors.green.shade700,
            ),
            SalomonBottomBarItem(
              icon: const Icon(Icons.store_rounded),
              title: const Text('Market'),
              selectedColor: Colors.green.shade700,
            ),
            SalomonBottomBarItem(
              icon: const Icon(Icons.agriculture_rounded),
              title: const Text('Farm'),
              selectedColor: Colors.green.shade700,
            ),
            SalomonBottomBarItem(
              icon: const Icon(Icons.people_rounded),
              title: const Text('Community'),
              selectedColor: Colors.green.shade700,
            ),
            SalomonBottomBarItem(
              icon: const Icon(Icons.account_balance_wallet_rounded),
              title: const Text('Finance'),
              selectedColor: Colors.green.shade700,
            ),
            SalomonBottomBarItem(
              icon: const Icon(Icons.chat_rounded),
              title: const Text('AI'),
              selectedColor: Colors.green.shade700,
            ),
          ],
          itemShape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          itemPadding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 8,
          ),
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          margin: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 8,
          ),
          backgroundColor: Colors.white,
        ),
      ),
    );
  }
}
