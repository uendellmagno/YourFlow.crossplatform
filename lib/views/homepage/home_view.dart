import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:your_flow/main.dart';
import 'package:your_flow/views/homepage/widgets/quick_actions_provider.dart';
import 'package:your_flow/views/homepage/widgets/user_name_provider.dart';
import 'package:your_flow/views/homepage/widgets/Charts/custom_line_chart.dart';
import 'package:your_flow/views/notifications/notifications_view.dart';
import 'package:your_flow/views/settings/settings_view.dart';


// This class is the main screen of MyApp() class
class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<MyAppState>(context);

    // List of pages to be displayed
    List<Widget> pages = [
      HomeView(),
      Icon(Icons.adaptive.more_rounded, size: 150),
      Icon(Icons.person, size: 150),
      SettingsView(),
    ];

    return Scaffold(
      body: pages[appState.currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        enableFeedback: true,
        currentIndex: appState.currentIndex,
        onTap: (int newIndex) {
          appState.setCurrentIndex(newIndex);
        },
        items: const [
          BottomNavigationBarItem(
            tooltip: "Home",
            label: 'Home',
            icon: Icon(Icons.home),
          ),
          BottomNavigationBarItem(
            tooltip: "Sales",
            label: 'Sales',
            icon: Icon(Icons.attach_money_rounded),
          ),
          BottomNavigationBarItem(
            tooltip: "Requests",
            label: 'Requests',
            icon: Icon(Icons.bubble_chart_rounded),
          ),
          BottomNavigationBarItem(
            tooltip: "Settings",
            label: 'Settings',
            icon: Icon(Icons.settings),
          ),
        ],
      ),
    );
  }
}

// This Class is the HomeView of the app
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
            title: const Text(
              'YourFlow',
              style: TextStyle(
                fontSize: 18,
              ),
            ),
            centerTitle: true,
            actions: [
              IconButton(
                onPressed: () {
                  HapticFeedback.selectionClick();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const NotificationsView()),
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
          Divider(
            height: 1,
            thickness: 1,
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [],
          ),
          GridView(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.8,
              crossAxisSpacing: 7,
              mainAxisSpacing: 7,
            ),
            children: const [
              BoxedLineChart(defaultVar: "Total Sales"),
              BoxedLineChart(defaultVar: "Units"),
              BoxedLineChart(defaultVar: "Price"),
              BoxedLineChart(defaultVar: "Ads Sales"),
              BoxedLineChart(defaultVar: "Ads Spend"),
              BoxedLineChart(defaultVar: "Other"),
            ],
          ),
        ],
      ),
    );
  }
}
