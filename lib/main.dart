import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// import 'package:your_flow/views/settings/widgets/about.dart';
import 'package:english_words/english_words.dart';
import 'views/homepage/home_view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: "YourFlow",
        theme: ThemeData(),
        darkTheme: ThemeData.dark(),
        themeMode: ThemeMode.system,
        home: const HomeView(),
      ),
    );
  }
}

// This is the state built to be shared across the app
class MyAppState extends ChangeNotifier {
  var current = WordPair.random();

  void getNext() {
    current = WordPair.random();
    notifyListeners();
  }

  var favorites = <WordPair>[];

  void toggleFavorite() {
    if (favorites.contains(current)) {
      favorites.remove(current);
    } else {
      favorites.add(current);
    }
    notifyListeners();
  }
}
