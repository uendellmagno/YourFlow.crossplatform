import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
    return const SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Padding(
        padding: EdgeInsets.only(top: 22, bottom: 22, left: 8, right: 8),
        child: Row(
          children: [
            QuickActionItem(
              icon: Icons.bar_chart_rounded,
              title: 'Revenue',
              view: AboutView(),
            ),
            QuickActionItem(
              icon: Icons.warehouse_rounded,
              title: 'Inventory',
              view: AboutView(),
            ),
            QuickActionItem(
              icon: Icons.airplane_ticket,
              title: "Shipments",
              view: AboutView(),
            ),
            QuickActionItem(
              icon: Icons.star,
              title: 'Reviews',
              view: AboutView(),
            ),
            QuickActionItem(
              icon: Icons.health_and_safety_rounded,
              title: 'Health',
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
          HapticFeedback.selectionClick();
          if (view != context.widget) {
            // TODO - Chega ne?
            // Navigator.push(
            //   context,
            //   MaterialPageRoute(builder: (context) => view),
            // );
            showModalBottomSheet(
              shape: BeveledRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20)),
              ),
              context: context,
              builder: (context) {
                return view;
              },
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
