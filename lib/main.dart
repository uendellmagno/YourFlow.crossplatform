/// This is the heart, core and soul of the app. It is the main file that runs the app.
library;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:your_flow/views/homepage/home_view.dart';
import 'package:your_flow/views/settings/widgets/about.dart';

// This is the main function that runs the app
void main() {
  runApp(const MyApp());
}

// This is the main class of the app
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Defines a custom ColorScheme for light and dark themes.
    final ColorScheme lightColorScheme = ColorScheme.fromSeed(
      seedColor: const Color(0xFF01659F),
    );

    final ColorScheme darkColorScheme = ColorScheme.fromSeed(
      seedColor: const Color(0xFF01659F),
      brightness: Brightness.dark,
    );

    // This is the main widget of the app
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: "YourFlow",
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: lightColorScheme,
          primaryColor: lightColorScheme.primary,
          scaffoldBackgroundColor: lightColorScheme.surface,
          appBarTheme: AppBarTheme(
            backgroundColor: lightColorScheme.surface,
            foregroundColor: lightColorScheme.onSurface,
          ),
          bottomNavigationBarTheme: BottomNavigationBarThemeData(
            selectedItemColor: lightColorScheme.primary,
            unselectedItemColor: lightColorScheme.onSurface.withOpacity(0.54),
          ),
        ),
        darkTheme: ThemeData(
          useMaterial3: true,
          colorScheme: darkColorScheme,
          primaryColor: darkColorScheme.primary,
          scaffoldBackgroundColor: darkColorScheme.surface,
          appBarTheme: AppBarTheme(
            backgroundColor: darkColorScheme.surface,
            foregroundColor: darkColorScheme.onSurface,
          ),
          bottomNavigationBarTheme: BottomNavigationBarThemeData(
            backgroundColor: darkColorScheme.surface,
            selectedItemColor: darkColorScheme.primary,
            unselectedItemColor: darkColorScheme.onSurface.withOpacity(0.70),
          ),
        ),
        themeMode: ThemeMode.system,
        home: const MainScreen(),
      ),
    );
  }
}

// This class is the main state of the app
class MyAppState extends ChangeNotifier {
  int _currentIndex = 0;

  int get currentIndex => _currentIndex;

  void setCurrentIndex(int index) {
    _currentIndex = index;
    notifyListeners();
  }
}

// This class is the main screen of MyApp() class
class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<MyAppState>(context);

    // List of pages to be displayed
    List<Widget> pages = [
      HomeView(),
      Icon(Icons.adaptive.more_rounded, size: 150),
      Icon(Icons.person, size: 150),
      AboutView(),
    ];

    return Scaffold(
      body: pages[appState.currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        enableFeedback: true,
        currentIndex: appState.currentIndex,
        onTap: (int newIndex) {
          appState.setCurrentIndex(newIndex);
        },
        items: const [
          BottomNavigationBarItem(
            label: 'Home',
            icon: Icon(Icons.home),
          ),
          BottomNavigationBarItem(
            label: 'Sales',
            icon: Icon(Icons.attach_money_rounded),
          ),
          BottomNavigationBarItem(
            label: 'Requests',
            icon: Icon(Icons.bubble_chart_rounded),
          ),
          BottomNavigationBarItem(
            label: 'Settings',
            icon: Icon(Icons.settings),
          ),
        ],
      ),
    );
  }
}
