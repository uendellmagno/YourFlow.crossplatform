import 'dart:core';

import 'package:flutter/material.dart';
import 'package:your_flow/services/api_ops.dart';

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
        QICardsList(apiOps: apiOps),
        CChartState(),
      ],
    );
  }
}

class QICardsList extends StatelessWidget {
  const QICardsList({
    super.key,
    required this.apiOps,
  });

  final ApiOps apiOps;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      scrollDirection: Axis.horizontal,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            QICard(
              title: "Total Sales",
              type: "USD",
              fetchData: apiOps.graphsRevenue,
            ),
            QICard(
              title: "Units",
              type: "QTD.",
              fetchData: apiOps.graphsRevenue,
            ),
            QICard(
              title: "Price",
              type: "USD",
              fetchData: apiOps.graphsRevenue,
            ),
            QICard(
              title: "Ads Sales",
              type: "USD",
              fetchData: apiOps.graphsRevenue,
            ),
            QICard(
              title: "Ads Spend",
              type: "USD",
              fetchData: apiOps.graphsRevenue,
            ),
            QICard(
              title: "CTR",
              type: "%",
              fetchData: apiOps.graphsRevenue,
            ),
          ],
        ),
      ),
    );
  }
}

class QICard extends StatelessWidget {
  final String title;
  final String type;
  final Future<Map<String, dynamic>> Function() fetchData;

  const QICard({
    super.key,
    required this.title,
    required this.type,
    required this.fetchData,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 230,
      width: 190,
      child: Card(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(14),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    textAlign: TextAlign.start,
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    textAlign: TextAlign.end,
                    type,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF9a9a9a),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: Text(
                textAlign: TextAlign.center,
                "\$1,258,945",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            deltas(context),
          ],
        ),
      ),
    );
  }

  Padding deltas(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildDeltaRow(context, "1 Day", "245%", Color(0xFF137201)),
          _buildDeltaRow(context, "7 Days", "-75%", Color(0xFFBA1313)),
          _buildDeltaRow(context, "30 Days", "-28%", Color(0xFFBA1313)),
        ],
      ),
    );
  }

  Row _buildDeltaRow(
      BuildContext context, String label, String value, Color valueColor) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: SizedBox(
            height: 35,
            child: Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ),
              color: Theme.of(context).cardColor,
              child: Container(
                alignment: Alignment.center,
                child: Text(
                  label,
                  style: TextStyle(fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        ),
        Expanded(
          child: SizedBox(
            height: 35,
            child: Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ),
              color: valueColor,
              child: Container(
                alignment: Alignment.center,
                child: Text(
                  value,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class CChartState extends StatefulWidget {
  const CChartState({super.key});

  @override
  State<CChartState> createState() => CustomChart();
}

class CustomChart extends State<CChartState> {
  String? _dropdownValue = 'Item1'; // Initialize with a default value

  void dropdownCallback(String? selectedValue) {
    setState(() {
      _dropdownValue = selectedValue;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.all(8.0),
          child: SizedBox(
            width: double.infinity,
            height: 300,
            child: Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 15, left: 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Total Sales",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          "\$ 1,257,992",
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10),
                ],
              ),
            ),
          ),
        ),
        // TODO - Rebuild this
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 12),
          child: SizedBox(
            width: double.infinity,
            height: 60,
            child: DropdownButton<String>(
              value: _dropdownValue,
              items: [
                DropdownMenuItem(value: 'Item1', child: Text("Item1")),
                DropdownMenuItem(value: 'Item2', child: Text("Item2")),
                DropdownMenuItem(value: 'Item3', child: Text("Item3")),
                DropdownMenuItem(value: 'Item4', child: Text("Item4")),
                DropdownMenuItem(value: 'Item5', child: Text("Item5")),
                DropdownMenuItem(value: 'Item6', child: Text("Item6")),
                DropdownMenuItem(value: 'Item7', child: Text("Item7")),
              ],
              onChanged: dropdownCallback,
            ),
          ),
        ),
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
