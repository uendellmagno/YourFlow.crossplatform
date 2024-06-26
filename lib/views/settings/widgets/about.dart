// This class of finals is used to display the app About information and Legals.
import 'package:flutter/material.dart';

class AppInformation {
  final String appName = "YourFlow";
  final String appFullName = "SF YourFlow App";
  final String appVersionDetail = "Beta Release: 1.0.0";
  final String appVersion = "1.0.0";
  final String appDescription = " I've got an awesome idea!";
  final Image appIcon = Image.asset(
    'assets/images/256-mac.png',
    width: 48.0,
    height: 48.0,
  );
  final String appLegal =
      "All Rights Reserved.\nThis is an AVLA App.\nCreated and Managed for SellersFLow LLC.";
}

class AboutView extends StatelessWidget {
  const AboutView({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "YourFlow",
      theme: ThemeData(),
      darkTheme: ThemeData.dark(),
      themeMode: ThemeMode.system,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('YourFlow'),
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back),
          ),
        ),
        body: const YFAboutView(),
      ),
    );
  }
}

class YFAboutView extends StatelessWidget {
  const YFAboutView({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            "YourFlow is\nan awesome app!",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton.icon(
                  onPressed: () {
                    showAboutDialog(
                      context: context,
                      applicationIcon: AppInformation().appIcon,
                      applicationName: AppInformation().appFullName,
                      applicationVersion: AppInformation().appVersionDetail,
                      applicationLegalese: AppInformation().appLegal,
                    );
                  },
                  icon: const Icon(Icons.info),
                  label: const Text("About us"),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
