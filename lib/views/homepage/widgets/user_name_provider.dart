import 'package:flutter/material.dart';

class UserNameView extends StatelessWidget {
  const UserNameView({super.key});

  final String userName = "Insider Store";

  @override
  Widget build(BuildContext context) {
    // TODO - i want it aligned left
    return SizedBox(
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.only(top: 20.0, bottom: 20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              "Hello, $userName",
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
