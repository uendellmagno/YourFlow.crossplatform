import 'dart:math';
import 'package:flutter/material.dart';
import 'package:your_flow/services/api_ops.dart';

// This is the app state class
class MyAppState extends ChangeNotifier {
  int _currentIndex = 0;
  String _userName = '';
  String _greetingText = "Welcome to\nYourFlow!";

  int get currentIndex => _currentIndex;
  String get userName => _userName;
  String get greetingText => _greetingText;

  // This is the constructor for the app state class, it fetches the user name and updates the greeting text.
  MyAppState() {
    getUserGreetings();
  }

  // This method sets the current Navigation Bar index
  void setCurrentIndex(int index) {
    _currentIndex = index;
    notifyListeners();
  }

  // This method fetches the user name from the server
  Future fetchUserName() async {
    try {
      final api = ApiOps();
      final userInfo = await api.userInfo();
      _userName = userInfo['name'];
      notifyListeners();
    } catch (error) {
      DoNothingAction();
    }
  }

  // This method fetches the user name from the server
  Future getUserGreetings() async {
    try {
      await fetchUserName();
      updateGreeting();
      notifyListeners();
    } catch (error) {
      DoNothingAction();
    }
  }

  // This method updates the greeting text
  void updateGreeting() {
    final List<String> greetings = [
      "Hello",
      "Welcome back",
      "Greetings",
      "Good day",
      "Hey",
      "What's up",
    ];

    final random = Random();
    final index = random.nextInt(greetings.length);
    _greetingText = greetings[index];
  }

  Future loggedOut() async {
    _userName = '';
    _greetingText = "Welcome to\nYourFlow!";
    setCurrentIndex(0);
    notifyListeners();
  }

  // This method regenerates the greeting text
  Future regenerateGreeting() {
    updateGreeting();
    notifyListeners();
    return Future.value();
  }
}
