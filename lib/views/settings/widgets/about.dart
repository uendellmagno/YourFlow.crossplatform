import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutView extends StatelessWidget {
  const AboutView({super.key});

  @override
  Widget build(BuildContext context) {
    final appInfo = AppInformation();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'About Us',
          style: TextStyle(
            fontSize: 18,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            appInfo.appIcon,
            const SizedBox(height: 20),
            Text(
              appInfo.appFullName,
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              appInfo.appDescription,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                padding: const EdgeInsets.symmetric(
                    horizontal: 16.0, vertical: 12.0),
              ),
              onPressed: () {
                showAboutDialog(
                  context: context,
                  applicationIcon: appInfo.appIcon,
                  applicationName: appInfo.appFullName,
                  applicationVersion: appInfo.appVersionDetail,
                  applicationLegalese: appInfo.appLegal,
                );
              },
              icon: const Icon(Icons.info),
              label: const Text("About us"),
            ),
            const SizedBox(height: 20),
            const Divider(),
            const SizedBox(height: 20),
            const Text(
              "Follow us on Social Media",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(width: 20),
                IconButton(
                  icon: const Icon(FontAwesomeIcons.instagram),
                  onPressed: () async {
                    final url =
                        Uri.parse('https://www.instagram.com/sellersflow/');
                    if (await canLaunchUrl(url)) {
                      await launchUrl(url);
                    } else {
                      throw 'Could not launch $url';
                    }
                  },
                ),
                const SizedBox(width: 20),
                IconButton(
                  icon: const Icon(FontAwesomeIcons.linkedin),
                  onPressed: () async {
                    final Uri url = Uri.parse(
                        'https://www.linkedin.com/company/sellersflow');
                    if (await canLaunchUrl(url)) {
                      await launchUrl(url);
                    } else {
                      throw 'Could not launch $url';
                    }
                  },
                ),
                const SizedBox(width: 20),
                IconButton(
                  icon: const Icon(FontAwesomeIcons.youtube),
                  onPressed: () async {
                    final Uri url =
                        Uri.parse('https://www.youtube.com/@Sellers_Flow');
                    if (await canLaunchUrl(url)) {
                      await launchUrl(url);
                    } else {
                      throw 'Could not launch $url';
                    }
                  },
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class AppInformation {
  final String appName = "YourFlow";
  final String appFullName = "SF YourFlow";
  final String appVersion = "1.0.0.2";
  late final String appVersionDetail;
  final String appDescription =
      "Made by us, for someone like you.\nSee all of your company's data right at your fingertips.";
  final Image appIcon = Image.asset(
    'assets/images/SF-DarkIcon-64.png',
    width: 48.0,
    height: 48.0,
  );
  // Made by Uendell Magno - AVLA Solutions, proprietary.
  final String appLegal =
      "All Rights Reserved®.\nCreated and Managed by SellersFLow LLC ©.";

  AppInformation() {
    appVersionDetail = "Alpha Release: $appVersion";
  }
}
