import 'dart:math';
import 'package:flutter/material.dart';
import 'package:your_flow/services/api_ops.dart';

class MyAppState extends ChangeNotifier {
  int _currentIndex = 0;
  String _userName = "User";
  String _greetingText = "Welcome to\nYourFlow!";

  int get currentIndex => _currentIndex;
  String get userName => _userName;
  String get greetingText => _greetingText;

  MyAppState() {
    fetchUserName();
    updateGreeting();
  }

  void setCurrentIndex(int index) {
    _currentIndex = index;
    notifyListeners();
  }

  Future fetchUserName() async {
    try {
      final api = ApiOps();
      final userInfo = await api.userInfo();
      _userName = userInfo['name']; // Assuming 'name' is the correct key
      updateGreeting(); // Update the greeting after fetching the user name
      notifyListeners();
    } catch (error) {
      print('Error fetching user info: $error');
    }
  }

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

  Future regenerateGreeting() {
    updateGreeting();
    notifyListeners();
    return Future.value();
  }
}
