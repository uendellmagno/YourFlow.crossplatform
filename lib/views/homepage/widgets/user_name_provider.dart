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
        // appState.regenerateGreeting();
      },
      child: appState.userName != ''
          ? Text(
              // "${appState.greetingText},\n${appState.userName}!",
              "Hello,\n${appState.userName}!",
              style: const TextStyle(
                fontSize: 35,
                fontWeight: FontWeight.bold,
              ),
            )
          : const CircularProgressIndicator.adaptive(),
    );
  }
}

class UserNameView extends StatelessWidget {
  const UserNameView({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      width: double.infinity,
      child: Padding(
        padding: EdgeInsets.only(right: 30, top: 25, bottom: 20, left: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [WelcomeUser()],
        ),
      ),
    );
  }
}
