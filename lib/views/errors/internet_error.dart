import 'package:flutter/material.dart';

class NoInternetConnection extends StatelessWidget {
  const NoInternetConnection({super.key});

  @override
  Widget build(BuildContext context) {
    final ColorScheme lightColorScheme = ColorScheme.fromSeed(
      seedColor: const Color(0xFF01659F),
    );

    final ColorScheme darkColorScheme = ColorScheme.fromSeed(
      seedColor: const Color(0xFF01659F),
      brightness: Brightness.dark,
    );

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "YourFlow",
      theme: lightThemeMethod(lightColorScheme),
      darkTheme: darkThemeMethod(darkColorScheme),
      themeMode: ThemeMode.system,
      home: const View(),
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

class View extends StatelessWidget {
  const View({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Image.asset(
                  Theme.of(context).brightness == Brightness.dark
                      ? 'assets/images/SellersFlowDot_logoDarkMode.png'
                      : 'assets/images/SellersFlowDot_logo.png',
                  height: 75,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: SizedBox(
              width: double.infinity,
              height: 200,
              child: Card(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "CONNECTION ISSUE",
                      style: TextStyle(
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Colors.orange
                            : Colors.red,
                        fontWeight: FontWeight.w900,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    const Text(
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                        "It seems that you're\nnot connected to the internet!"),
                    const SizedBox(
                      height: 30,
                    ),
                    const CircularProgressIndicator.adaptive()
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
