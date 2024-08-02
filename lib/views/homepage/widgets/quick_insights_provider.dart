import 'dart:core';

import 'package:flutter/material.dart';
import 'package:your_flow/services/api_ops.dart';
import 'package:your_flow/views/homepage/widgets/Cards/qi_cards.dart';
import 'package:your_flow/views/homepage/widgets/Charts/custom_chart.dart';

class QuickInsightsView extends StatefulWidget {
  const QuickInsightsView({super.key});

  @override
  _QuickInsightsView createState() => _QuickInsightsView();
}

class _QuickInsightsView extends State<QuickInsightsView> {
  final ApiOps apiOps = ApiOps();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 20, top: 20),
          child: Row(
            children: [
              Icon(Icons.star_rounded, size: 20),
              SizedBox(width: 5),
              Text("Quick Insights", style: TextStyle(fontSize: 15)),
            ],
          ),
        ),
        const SizedBox(height: 10),
        QICardsState(apiOps: apiOps),
        CChartState(apiOps: apiOps),
      ],
    );
  }
}





  // Center cardsViewError(context) {
  //   return Center(
  //       child: Padding(
  //     padding: const EdgeInsets.all(20),
  //     child: Column(
  //       children: [
  //         const Text(
  //             "It's us, not you. Try again pressing the button below.\nIf the problem persists, contact support."),
  //         const SizedBox(height: 20),
  //         ElevatedButton.icon(
  //           onPressed: () {
  //             HapticFeedback.selectionClick();
  //             refresh;
  //             apiOps.forceFreshFetch();
  //             ScaffoldMessenger.of(context).showSnackBar(
  //               const SnackBar(
  //                 content: Text('Please, quit and reopen the app :)'),
  //               ),
  //             );
  //           },
  //           icon: const Icon(Icons.refresh),
  //           label: const Text('Retry'),
  //         ),
  //       ],
  //     ),
  //   ));
  // }


// GridView cardsView(ApiOps apiOps) {
//   return GridView(
//     shrinkWrap: true,
//     physics: const NeverScrollableScrollPhysics(),
//     gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//       crossAxisCount: 2,
//       childAspectRatio: 0.8,
//       crossAxisSpacing: 7,
//       mainAxisSpacing: 7,
//     ),
//     children: [
//       BoxedLineChart(
//         defaultVar: "Total Sales",
//         fetchData: apiOps.graphsRevenue,
//       ),
//       BoxedLineChart(
//         defaultVar: "Units",
//         fetchData: apiOps.graphsRevenue,
//       ),
//       BoxedLineChart(
//         defaultVar: "Price",
//         fetchData: apiOps.graphsRevenue,
//       ),
//       BoxedLineChart(
//         defaultVar: "Ads Sales",
//         fetchData: apiOps.graphsRevenue,
//       ),
//       BoxedLineChart(
//         defaultVar: "Ads Spend",
//         fetchData: apiOps.graphsRevenue,
//       ),
//       BoxedLineChart(
//         defaultVar: "Other",
//         fetchData: apiOps.graphsRevenue,
//       ),
//     ],
//   );
// }

// Row cardsTopHeader(BuildContext context) {
//   return Row(
//     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//     children: [
//       const Padding(
//         padding: EdgeInsets.only(left: 15),
//         child: Text(
//           'Overview',
//           style: TextStyle(
//             fontSize: 20,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//       ),
//       Padding(
//         padding: const EdgeInsets.only(right: 15),
//         child: ElevatedButton(
//           style: ElevatedButton.styleFrom(
//             shape: const RoundedRectangleBorder(
//               borderRadius: BorderRadius.all(
//                 Radius.circular(8),
//               ),
//             ),
//           ),
//           onPressed: () {
//             HapticFeedback.selectionClick();
//             Navigator.push(
//               context,
//               MaterialPageRoute(
//                 builder: (context) => const SalesView(),
//               ),
//             );
//           },
//           child: Text(
//             'View All',
//             style: TextStyle(
//               color: Theme.of(context).primaryColor,
//             ),
//           ),
//         ),
//       ),
//     ],
//   );
// }
