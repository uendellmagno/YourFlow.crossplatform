import 'package:flutter/material.dart';
import 'package:your_flow/views/homepage/widgets/user_name_provider.dart';
import 'package:your_flow/views/settings/widgets/about.dart';
import 'package:your_flow/views/homepage/widgets/Charts/custom_line_chart.dart';
import 'package:your_flow/main.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
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

class YFHomeView extends StatelessWidget {
  const YFHomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const UserNameView(),
          const SizedBox(height: 10),
          Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [],
          ),
          Wrap(
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
