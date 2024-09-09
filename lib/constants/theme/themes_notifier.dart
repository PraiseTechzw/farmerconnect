import 'package:flutter/material.dart';

final ThemeData lightTheme = ThemeData(
  primarySwatch: Colors.green,
  brightness: Brightness.light,
  cardColor: Colors.white,
  scaffoldBackgroundColor: Colors.grey[100],
  textTheme: const TextTheme(
    titleLarge: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
    bodyMedium: TextStyle(fontSize: 16.0),
  ),
);

final ThemeData darkTheme = ThemeData(
  primarySwatch: Colors.green,
  brightness: Brightness.dark,
  cardColor: Colors.grey[800],
  scaffoldBackgroundColor: Colors.grey[900],
  textTheme: const TextTheme(
    titleLarge: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
    bodyMedium: TextStyle(fontSize: 16.0),
  ),
);
