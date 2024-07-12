import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SettingsListBuilder(),
            ],
          ),
        ),
      ),
    );
  }
}

class SettingsListBuilder extends StatelessWidget {
  const SettingsListBuilder({super.key});

  @override
  Widget build(BuildContext context) {
    return ListBody(
      children: [
        SettingsCard(
          image: 'https://avatars.githubusercontent.com/u/29775873?v=4',
          title: 'Profile',
          subtitle: 'View and edit your profile',
          view: const Text('Profile'),
          tileType: 'profile',
        ),
        SettingsCard(
          title: 'Settings',
          subtitle: 'Change your app settings',
          view: const Text('Settings'),
          tileType: 'settings',
        ),
        SettingsCard(
          title: 'About',
          subtitle: "Learn more about the app",
          view: const Text('About'),
          tileType: 'about',
        ),
        SettingsCard(
          title: 'Help',
          subtitle: "Get help with the app",
          view: const Text('Help'),
          tileType: 'help',
        ),
        SettingsCard(
          title: 'Logout',
          subtitle: 'Logout from your account',
          view: const Text('Logout'),
          tileType: 'logout',
          tapGesture: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text('Confirm Logout'),
                  content: const Text('Are you sure you want to logout?'),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () {
                        FirebaseAuth.instance.signOut();
                        Navigator.of(context).pop();
                      },
                      child: const Text('Logout'),
                    ),
                  ],
                );
              },
            );
          },
        ),
      ],
    );
  }
}

class SettingsCard extends StatelessWidget {
  const SettingsCard({
    super.key,
    this.image,
    required this.title,
    this.subtitle,
    required this.view,
    required this.tileType,
    this.icon,
    this.tapGesture,
  });

  final String? image;
  final Widget? icon;
  final String title;
  final String? subtitle;
  final Widget view;
  final String tileType;
  final GestureTapCallback? tapGesture;

  @override
  Widget build(BuildContext context) {
    Widget leadingWidget;

    switch (tileType) {
      case 'profile':
        leadingWidget = ClipOval(
          child: Image.network(
            image!,
            width: 50,
            height: 50,
            fit: BoxFit.cover,
          ),
        );
        break;
      case 'settings':
        leadingWidget = const Icon(Icons.settings);
        break;
      case 'about':
        leadingWidget = const Icon(Icons.info);
        break;
      case 'help':
        leadingWidget = const Icon(Icons.help);
        break;
      case 'logout':
        leadingWidget = const Icon(Icons.logout);
        break;
      default:
        leadingWidget = const Icon(Icons.info);
        break;
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListTile(
          onTap: () {
            HapticFeedback.lightImpact();
            if (tapGesture != null) {
              tapGesture!();
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('This feature is coming soon! Stay tuned.'),
                ),
              );
            }
          },
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          leading: leadingWidget,
          title: Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          subtitle: subtitle != null
              ? Text(
                  subtitle!,
                  style: const TextStyle(
                    fontSize: 14,
                  ),
                )
              : null,
        ),
      ),
    );
  }
}
