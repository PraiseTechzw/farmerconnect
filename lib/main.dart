import 'package:farmerconnect/constants/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'constants/theme/themes_notifier.dart';
import 'screens/home/home_screen.dart';
import 'providers/crop_provider.dart';


void main() {
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
      ],
      child: Consumer<ThemeNotifier>(
        builder: (context, themeNotifier, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'FarmerConnect',
            theme: lightTheme,
            darkTheme: darkTheme,
            themeMode: themeNotifier.isDarkMode ? ThemeMode.dark : ThemeMode.light,
            initialRoute: '/',
            routes: {
              '/': (context) => const HomeScreen(),
            
            },
          );
        },
      ),
    );
  }
}
