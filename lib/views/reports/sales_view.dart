import 'package:flutter/material.dart';

class SalesView extends StatelessWidget {
  const SalesView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Sales',
          style: TextStyle(
            fontSize: 15,
          ),
        ),
        centerTitle: true,
      ),
      body: const Padding(
        padding: EdgeInsets.all(8.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Coming soon..."),
            ],
          ),
        ),
      ),
    );
  }
}
