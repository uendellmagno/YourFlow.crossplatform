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
import 'package:your_flow/services/api_ops.dart';

// This class is the main screen of MyApp() class
class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<MyAppState>(context);

    // List of pages to be displayed
    List<Widget> pages = [
      const HomeView(),
      const SalesView(),
      const RequestsView(),
      const SettingsView(),
    ];

    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          appState.setCurrentIndex(index);
        },
        children: pages,
      ),
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
          padding: const EdgeInsets.all(16),
          selectedIndex: appState.currentIndex,
          onTabChange: (int newIndex) {
            _pageController.jumpToPage(newIndex);
          },
          tabs: const [
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
class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final ApiOps apiOps = ApiOps();
  late Future<Map<String, dynamic>> _future;

  @override
  void initState() {
    super.initState();
    _future = apiOps.graphsRevenue();
  }

  Future<void> _refresh() async {
    setState(() {
      _future = apiOps.graphsRevenue();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // The app bar is a sliver app bar with a title and an action button
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: CustomScrollView(
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
                  YFHomeView(
                    apiOps: apiOps,
                    future: _future,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// This class is the main view of the HomeView() class
class YFHomeView extends StatelessWidget {
  final ApiOps apiOps;
  final Future<Map<String, dynamic>> future;

  const YFHomeView({super.key, required this.apiOps, required this.future});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const UserNameView(),
          const QuickActionsView(),
          const Divider(
            height: 1,
            thickness: 1,
          ),
          const Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 15, bottom: 15),
            child: Column(
              children: [
                cardsTopHeader(context),
                FutureBuilder<Map<String, dynamic>>(
                  future: future,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else if (snapshot.hasData) {
                      return cardsView(apiOps);
                    } else {
                      return const Center(child: Text('No data'));
                    }
                  },
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

GridView cardsView(ApiOps apiOps) {
  return GridView(
    shrinkWrap: true,
    physics: const NeverScrollableScrollPhysics(),
    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 2,
      childAspectRatio: 0.8,
      crossAxisSpacing: 7,
      mainAxisSpacing: 7,
    ),
    children: [
      BoxedLineChart(
        defaultVar: "Total Sales",
        fetchData: apiOps.graphsRevenue,
      ),
      BoxedLineChart(
        defaultVar: "Units",
        fetchData: apiOps.graphsRevenue,
      ),
      BoxedLineChart(
        defaultVar: "Price",
        fetchData: apiOps.graphsRevenue,
      ),
      BoxedLineChart(
        defaultVar: "Ads Sales",
        fetchData: apiOps.graphsRevenue,
      ),
      BoxedLineChart(
        defaultVar: "Ads Spend",
        fetchData: apiOps.graphsRevenue,
      ),
      BoxedLineChart(
        defaultVar: "Other",
        fetchData: apiOps.graphsRevenue,
      ),
    ],
  );
}

Row cardsTopHeader(BuildContext context) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      const Padding(
        padding: EdgeInsets.only(left: 15),
        child: Text(
          'Overview',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(right: 15),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(8),
              ),
            ),
          ),
          onPressed: () {
            HapticFeedback.selectionClick();
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const SalesView(),
              ),
            );
          },
          child: Text(
            'View All',
            style: TextStyle(
              color: Theme.of(context).primaryColor,
            ),
          ),
        ),
      ),
    ],
  );
}
