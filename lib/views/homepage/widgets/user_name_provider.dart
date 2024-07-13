import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:your_flow/services/app_state_core.dart';

class WelcomeUser extends StatelessWidget {
  const WelcomeUser({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<MyAppState>(context);

    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        appState.regenerateGreeting();
      },
      child: Text(
        appState.greetingText,
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
