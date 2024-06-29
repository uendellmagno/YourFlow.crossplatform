import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../settings/widgets/about.dart';
import '/views/homepage/widgets/Charts/custom_line_chart.dart';
import '../../main.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('YourFlow'),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AboutView()),
                );
              },
              enableFeedback: true,
              icon: const Icon(Icons.notifications)),
        ],
      ),
      body: const YFHomeView(),
    );
  }
}

class YFHomeView extends StatelessWidget {
  const YFHomeView({super.key});

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    var pair = appState.current;

    IconData icon;
    if (appState.favorites.contains(pair)) {
      icon = Icons.favorite;
    } else {
      icon = Icons.favorite_border;
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text("I've got an awesome idea!"),
          const SizedBox(height: 10),
          Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton(
                onPressed: () {
                  appState.getNext();
                },
                child: const Text('Generate new idea'),
              ),
              const SizedBox(
                width: 10,
              ),
              ElevatedButton.icon(
                onPressed: () {
                  appState.toggleFavorite();
                },
                icon: Icon(icon),
                label: const Text('Like'),
              ),
            ],
          ),
          const SizedBox(height: 50),
          const FLChart(),
        ],
      ),
    );
  }
}
