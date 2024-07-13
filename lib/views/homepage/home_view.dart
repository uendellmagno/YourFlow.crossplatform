import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:your_flow/services/app_state_core.dart';
import 'package:your_flow/views/homepage/widgets/quick_actions_provider.dart';
import 'package:your_flow/views/homepage/widgets/user_name_provider.dart';
import 'package:your_flow/views/homepage/widgets/Charts/custom_line_chart.dart';
import 'package:your_flow/views/notifications/notifications_view.dart';
import 'package:your_flow/views/reports/requests_view.dart';
import 'package:your_flow/views/reports/sales_view.dart';
import 'package:your_flow/views/settings/settings_view.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

// This class is the main screen of MyApp() class
class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<MyAppState>(context);

    // List of pages to be displayed
    List<Widget> pages = [
      HomeView(),
      SalesView(),
      RequestsView(),
      SettingsView(),
    ];

    return Scaffold(
      body: pages[appState.currentIndex],
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 20,
        ),
        child: GNav(
          haptic: true, // haptic feedback
          tabBorderRadius: 15,
          activeColor: Theme.of(context).primaryColor,
          tabBackgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
          duration: const Duration(milliseconds: 300),
          rippleColor: Theme.of(context).primaryColor.withOpacity(0.1),
          gap: 8,
          color: Theme.of(context).appBarTheme.foregroundColor,
          padding: EdgeInsets.all(16),
          selectedIndex: appState.currentIndex,
          onTabChange: (int newIndex) {
            appState.setCurrentIndex(newIndex);
          },
          tabs: [
            GButton(
              semanticLabel: "Home",
              text: 'Home',
              icon: Icons.home_rounded,
            ),
            GButton(
              semanticLabel: "Sales",
              text: 'Sales',
              icon: Icons.attach_money_rounded,
            ),
            GButton(
              semanticLabel: "Requests",
              text: 'Requests',
              icon: Icons.bubble_chart_rounded,
            ),
            GButton(
              semanticLabel: "Settings",
              text: 'Settings',
              icon: Icons.settings_rounded,
            ),
          ],
        ),
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
