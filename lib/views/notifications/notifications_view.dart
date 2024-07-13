import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class NotificationsView extends StatelessWidget {
  const NotificationsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Notifications',
          style: TextStyle(
            fontSize: 18,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              NotificationCard(),
            ],
          ),
        ),
      ),
    );
  }
}

class NotificationCard extends StatelessWidget {
  const NotificationCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        onTap: () {
          HapticFeedback.lightImpact();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Graças a Deus, sou brabo demais!'),
            ),
          );
        },
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        leading: const Icon(Icons.notifications),
        title: const Text(
          'Coming soon!',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: const Text(
          'Beep, bop! This feature is coming soon! Stay tuned!',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
