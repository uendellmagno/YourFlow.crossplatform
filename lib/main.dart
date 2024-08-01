import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:your_flow/services/firebase_tools.dart';
import 'package:your_flow/services/connectivity_services.dart';
import 'package:your_flow/views/errors/internet_error.dart';
import 'package:your_flow/views/homepage/home_view.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:your_flow/services/app_state_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  static FirebaseAnalyticsObserver observer =
      FirebaseAnalyticsObserver(analytics: analytics);

  static FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    final ColorScheme lightColorScheme = ColorScheme.fromSeed(
      seedColor: const Color(0xFF01659F),
    );

    final ColorScheme darkColorScheme = ColorScheme.fromSeed(
      seedColor: const Color(0xFF01659F),
      brightness: Brightness.dark,
    );

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => MyAppState()),
        Provider(create: (context) => ConnectivityService()),
      ],
      child: Consumer<ConnectivityService>(
        builder: (context, connectivityService, child) {
          return StreamBuilder<ConnectivityResult>(
            stream: connectivityService.connectivityStream,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.active) {
                final connectivityResult = snapshot.data;
                if (connectivityResult == ConnectivityResult.none) {
                  return const NoInternetConnection();
                } else {
                  return MaterialApp(
                    debugShowCheckedModeBanner: false,
                    title: "YourFlow",
                    theme: lightThemeMethod(lightColorScheme),
                    darkTheme: darkThemeMethod(darkColorScheme),
                    themeMode: ThemeMode.system,
                    home: const AuthChecker(child: MainScreen()),
                  );
                }
              }
              return const Center(child: CircularProgressIndicator());
            },
          );
        },
      ),
    );
  }

  ThemeData lightThemeMethod(ColorScheme lightColorScheme) {
    return ThemeData(
      useMaterial3: true,
      fontFamily: 'Gilroy',
      colorScheme: lightColorScheme,
      primaryColor: lightColorScheme.primary,
      cardColor: const Color(0xFFD9D9D9),
      scaffoldBackgroundColor: lightColorScheme.surface,
      appBarTheme: AppBarTheme(
        backgroundColor: lightColorScheme.surface,
        foregroundColor: lightColorScheme.onSurface,
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        selectedItemColor: lightColorScheme.primary,
        unselectedItemColor: lightColorScheme.onSurface.withOpacity(0.54),
      ),
    );
  }

  ThemeData darkThemeMethod(ColorScheme darkColorScheme) {
    return ThemeData(
      useMaterial3: true,
      colorScheme: darkColorScheme,
      primaryColor: darkColorScheme.primary,
      cardColor: const Color(0xFF262626),
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
    );
  }
}
