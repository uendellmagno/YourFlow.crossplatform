import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:your_flow/views/unauthenticated/login_view.dart';


// This is a custom widget that checks if the user is authenticated
class AuthChecker extends StatelessWidget {
  const AuthChecker({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Show loading indicator while waiting for auth state
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF00659e)),
              ),
            ),
          );
        }

        if (snapshot.hasData) {
          // User is signed in
          return child;
        } else {
          // User is not signed in, navigate to login screen
          return LoginScreen();
        }
      },
    );
  }
}