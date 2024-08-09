import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:your_flow/services/api_ops.dart';
import 'package:your_flow/services/app_state_core.dart';
import 'package:your_flow/views/settings/widgets/about.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Settings',
          style: TextStyle(fontSize: 18),
        ),
        centerTitle: true,
      ),
      body: const Padding(
        padding: EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: SettingsListBuilder(),
        ),
      ),
    );
  }
}

class SettingsListBuilder extends StatelessWidget {
  const SettingsListBuilder({super.key});
// TODO - SLACK - Add a method to get the profile picture URL
  @override
  Widget build(BuildContext context) {
    final ApiOps apiOps = ApiOps();
    print(apiOps.userInfo());
    final appState = Provider.of<MyAppState>(context);
    return FutureBuilder<String>(
      future: _getProfilePictureUrl(appState.userName),
      builder: (context, snapshot) {
        String profileUrl = snapshot.data ??
            'https://ui-avatars.com/api/?name=${Uri.encodeComponent(appState.userName)}';

        return Column(
          children: [
            SettingsCard(
              image: profileUrl,
              title: appState.userName,
              subtitle: 'View and edit your profile',
              view: const Text('Profile'),
              tileType: 'profile',
            ),
            const SettingsCard(
              title: 'Help',
              subtitle: "Get help with the app",
              view: Text('Help'),
              tileType: 'help',
            ),
            SettingsCard(
              title: 'About',
              subtitle: "Learn more about the app",
              view: const Text('About'),
              tileType: 'about',
              tapGesture: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AboutView()),
                );
              },
            ),
            SettingsCard(
              title: 'Logout',
              subtitle: 'Logout from your account',
              view: const Text('Logout'),
              tileType: 'logout',
              tapGesture: () {
                _showLogoutDialog(context, appState);
              },
            ),
          ],
        );
      },
    );
  }

  Future<String> _getProfilePictureUrl(String userName) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return '';

    final uid = user.uid;
    final profilePicRef = FirebaseStorage.instance
        .ref()
        .child('SF-DataFlow/assets/logos/$uid/$uid.jpg');

    try {
      final url = await profilePicRef.getDownloadURL();
      return url;
    } catch (error) {
      return 'https://ui-avatars.com/api/?name=${Uri.encodeComponent(user.displayName ?? userName)}';
    }
  }

  Future<void> _showLogoutDialog(
      BuildContext context, MyAppState appState) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Logout'),
          content: const Text('Are you sure you want to leave?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                FirebaseAuth.instance.signOut();
                Navigator.of(context).pop();
                appState.loggedOut();
              },
              child: const Text('Yes'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'Cancel',
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
            ),
          ],
        );
      },
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
    final leadingWidget = _getLeadingWidget(tileType);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onPressed: () {
          HapticFeedback.lightImpact();
          tapGesture != null ? tapGesture!() : _showComingSoon(context);
        },
        icon: leadingWidget,
        label: ListTile(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          subtitle: subtitle != null
              ? Text(subtitle!, style: const TextStyle(fontSize: 14))
              : null,
        ),
      ),
    );
  }

  Widget _getLeadingWidget(String tileType) {
    switch (tileType) {
      case 'profile':
        return ClipOval(
          child: Image.network(
            image!,
            width: 50,
            height: 50,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return const Icon(Icons.account_circle, size: 50);
            },
          ),
        );
      case 'settings':
        return const Icon(Icons.settings);
      case 'about':
        return const Icon(Icons.info);
      case 'help':
        return const Icon(Icons.help);
      case 'logout':
        return const Icon(Icons.logout);
      default:
        return const Icon(Icons.info);
    }
  }

  void _showComingSoon(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('This feature is coming soon! Stay tuned.'),
      ),
    );
  }
}
