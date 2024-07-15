import 'dart:math';
import 'package:flutter/material.dart';
import 'package:your_flow/services/api_ops.dart';


// This is the app state class
class MyAppState extends ChangeNotifier {
  int _currentIndex = 0;
  String _userName = "User";
  String _greetingText = "Welcome to\nYourFlow!";

  int get currentIndex => _currentIndex;
  String get userName => _userName;
  String get greetingText => _greetingText;

 // This is the constructor for the app state class, it fetches the user name and updates the greeting text.
  MyAppState() {
    fetchUserName();
    updateGreeting();
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
      updateGreeting();
      notifyListeners();
    } catch (error) {
      print('Error fetching user info: $error');
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
    _greetingText = "${greetings[index]},\n$_userName!";
  }

  // This method regenerates the greeting text
  Future regenerateGreeting() {
    updateGreeting();
    notifyListeners();
    return Future.value();
  }
}
