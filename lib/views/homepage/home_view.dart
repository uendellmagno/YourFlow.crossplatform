/// This file was built to display the home view of the application.
library;

import 'package:flutter/material.dart';
import 'package:your_flow/views/homepage/widgets/quick_actions_provider.dart';
import 'package:your_flow/views/homepage/widgets/user_name_provider.dart';
import 'package:your_flow/views/homepage/widgets/Charts/custom_line_chart.dart';
import 'package:your_flow/views/settings/widgets/about.dart';

// This Class is the main view of the app
class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // The app bar is a sliver app bar with a title and an action button
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        scrollBehavior: const MaterialScrollBehavior().copyWith(
          scrollbars: false,
        ),
        slivers: [
          SliverAppBar(
            floating: true,
            pinned: false,
            snap: true,
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
                icon: const Icon(Icons.notifications),
              ),
            ],
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                const YFHomeView(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}


// This class is the main view of the HomeView() class
class YFHomeView extends StatelessWidget {
  const YFHomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const UserNameView(),
          const QuickActionsView(),
          const SizedBox(height: 10),
          Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [],
          ),
          Wrap(
            runSpacing: 10,
            children: [
              const BoxedLineChart(),
              const BoxedLineChart(),
              const BoxedLineChart(),
              const BoxedLineChart(),
            ],
          ),
        ],
      ),
    );
  }
}
