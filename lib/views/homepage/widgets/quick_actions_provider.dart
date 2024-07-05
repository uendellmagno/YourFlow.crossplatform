import 'package:flutter/material.dart';
import 'package:your_flow/views/homepage/home_view.dart';
import 'package:your_flow/views/settings/widgets/about.dart';

class QuickActionsView extends StatelessWidget {
  const QuickActionsView({super.key});

  @override
  Widget build(BuildContext context) {
    return const QuickActionsProvider();
  }
}

class QuickActionsProvider extends StatelessWidget {
  const QuickActionsProvider({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: const [
            QuickActionItem(
              icon: Icons.home,
              title: 'Home',
              view: HomeView(),
            ),
            QuickActionItem(
              icon: Icons.shopping_cart,
              title: 'Cart',
              view: AboutView(),
            ),
            QuickActionItem(
              icon: Icons.favorite,
              title: 'Favorites',
              view: AboutView(),
            ),
            QuickActionItem(
              icon: Icons.settings,
              title: 'Settings',
              view: AboutView(),
            ),
          ],
        ),
      ),
    );
  }
}

// The quick actions items must be in a rounded square shape with an icon and a title inside of it, Material You design style each of it with icon and text side by side, the icon must be on left of the text
class QuickActionItem extends StatelessWidget {
  const QuickActionItem(
      {super.key, required this.icon, required this.title, required this.view});

  final IconData icon;
  final String title;
  final Widget view;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          const EdgeInsets.only(top: 8.0, bottom: 8.0, left: 4.0, right: 4),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).colorScheme.primary,
          enableFeedback: true,
          splashFactory: InkRipple.splashFactory,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onPressed: () {
          if (view != context.widget) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => view),
            );
          }
        },
        child: Padding(
          padding: const EdgeInsets.only(
            top: 17,
            bottom: 17,
          ),
          child: Row(
            children: [
              Icon(
                icon,
                color: Theme.of(context).colorScheme.onPrimary,
              ),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
