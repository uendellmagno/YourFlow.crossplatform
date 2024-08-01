import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:your_flow/services/app_state_core.dart';
import 'package:your_flow/views/homepage/widgets/products_ranking_provider.dart';
import 'package:your_flow/views/homepage/widgets/quick_actions_provider.dart';
import 'package:your_flow/views/homepage/widgets/quick_insights_provider.dart';
import 'package:your_flow/views/homepage/widgets/sales_mix_provider.dart';
import 'package:your_flow/views/homepage/widgets/user_name_provider.dart';
import 'package:your_flow/views/notifications/notifications_view.dart';
import 'package:your_flow/views/reports/products_view.dart';
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
      const ProductsView(),
      const SettingsView(),
    ];

    return Scaffold(
      body: PageView(
        physics: const NeverScrollableScrollPhysics(),
        controller: _pageController,
        onPageChanged: (index) {
          appState.setCurrentIndex(index);
        },
        children: pages,
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 10,
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
              semanticLabel: "Products",
              text: 'Products',
              icon: Icons.warehouse_rounded,
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

  // This is the Refresh system for the HomeView
  Future<void> _refresh() async {
    await Provider.of<MyAppState>(context, listen: false).fetchUserName();
    setState(() {
      _future = apiOps.graphsRevenue();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // The app bar is a sliver app bar with a title and an action button
      body: RefreshIndicator.adaptive(
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
              title: Text("YourFlow", style: TextStyle(fontSize: 15)),
              centerTitle: true,
              actions: [
                IconButton(
                  onPressed: () {
                    HapticFeedback.selectionClick();

                    // TODO - Or a Navigator.push()?
                    showModalBottomSheet(
                        shape: const BeveledRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(20))),
                        context: context,
                        builder: (context) => const NotificationsView());
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
                      apiOps: apiOps, future: _future, refresh: _refresh),
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
  final Future<void> Function() refresh;

  const YFHomeView(
      {super.key,
      required this.apiOps,
      required this.future,
      required this.refresh});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const UserNameView(),
          const QuickActionsView(),
          const Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              QuickInsightsView(),
              SalesMixView(),
              ProductsRankingView(),
            ],
          ),
        ],
      ),
    );
  }
}
