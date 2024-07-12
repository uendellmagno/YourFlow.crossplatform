import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class WelcomeUser extends StatefulWidget {
  const WelcomeUser({super.key});

  @override
  WelcomeUserState createState() => WelcomeUserState();
}

class WelcomeUserState extends State<WelcomeUser> {
  final List<String> greetings = [
    "Hello",
    "Welcome back",
    "Greetings",
    "Good day",
    "Hey",
    "What's up",
  ];

  final String userName = "Basics Hardware";
  String greetingText = "Welcome to\nYourFlow!";

  @override
  void initState() {
    super.initState();
    updateGreeting();
  }

  void updateGreeting() {
    final random = Random();
    final index = random.nextInt(greetings.length);
    setState(() {
      greetingText = "${greetings[index]},\n$userName!";
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        updateGreeting();
      },
      child: Text(
        greetingText,
        style: const TextStyle(
          fontSize: 38,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class UserNameView extends StatelessWidget {
  const UserNameView({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Padding(
        padding:
            const EdgeInsets.only(right: 30, top: 30, bottom: 30, left: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [WelcomeUser()],
        ),
      ),
    );
  }
}
