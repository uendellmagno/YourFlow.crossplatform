import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:your_flow/services/api_ops.dart';

class SalesMixView extends StatefulWidget {
  const SalesMixView({
    super.key,
  });

  @override
  State<SalesMixView> createState() => _SalesMixViewState();
}

class _SalesMixViewState extends State<SalesMixView> {
  @override
  Widget build(BuildContext context) {
    final ApiOps apiOps = ApiOps();

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 20, top: 20),
          child: Row(
            children: [
              Icon(Icons.pie_chart_rounded, size: 20),
              SizedBox(width: 5),
              Text("Sales Mix", style: TextStyle(fontSize: 15)),
            ],
          ),
        ),
        const SizedBox(height: 10),
        SalesMixProvider(
          apiOps: apiOps,
        ),
      ],
    );
  }
}

class SalesMixProvider extends StatelessWidget {
  final ApiOps apiOps;
  const SalesMixProvider({super.key, required this.apiOps});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          SalesMixCard(label: "Countries", apiOps: apiOps),
          SizedBox(height: 15),
          SalesMixCard(label: "Marketplaces", apiOps: apiOps),
        ],
      ),
    );
  }
}

class SalesMixCard extends StatefulWidget {
  final ApiOps apiOps;
  final String label;
  const SalesMixCard({super.key, required this.label, required this.apiOps});

  @override
  State<SalesMixCard> createState() => _SalesMixCardState();
}

class _SalesMixCardState extends State<SalesMixCard> {
  int touchedIndex = -1;
  List<Color> colorSet = [
    Color(0xFF016AA8),
    Color(0xFF008CFF),
    Color(0xFF132442),
    Color(0xFF167979),
    Color(0xFF3baee1),
    Color(0xFF3b8ac0),
    Color(0xFF3b6ea8),
    Color(0xFF3b4e8c),
    Color(0xFF3b3b6e),
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 210,
      width: double.infinity,
      child: Card(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(14),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.label,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    legends(),
                    pieChart(),
                  ],
                ),
              ),
            ),
            // Expanded(
            //   child: FutureBuilder<Map<String, dynamic>>(
            //     future: widget.apiOps.graphsRevenue(),
            //     builder: (context, snapshot) {
            //       if (snapshot.connectionState == ConnectionState.waiting) {
            //         return const Center(child: CircularProgressIndicator());
            //       } else if (snapshot.hasError) {
            //         return Center(
            //           child: Text(
            //             "Error: ${snapshot.error}",
            //             style: const TextStyle(color: Colors.red),
            //           ),
            //         );
            //       } else {
            //         final data = snapshot.data;
            //         return Column(
            //           children: [
            //             Text(
            //               "Revenue: ${data['revenue']}",
            //               style: const TextStyle(fontSize: 16),
            //             ),
            //             Text(
            //               "Cost: ${data['cost']}",
            //               style: const TextStyle(fontSize: 16),
            //             ),
            //             Text(
            //               "Profit: ${data['profit']}",
            //               style: const TextStyle(fontSize: 16),
            //             ),
            //           ],
            //         );
            //       }
            //     },
            //   ),
            // ),
          ],
        ),
      ),
    );
  }

  legends() {
    return Column(
      children: [
        Row(
          children: [
            Container(
              height: 10,
              width: 10,
              color: Colors.red,
            ),
            Text("Revenue"),
          ],
        ),
        Row(
          children: [
            Container(
              height: 10,
              width: 10,
              color: Colors.green,
            ),
            Text("Cost"),
          ],
        ),
        Row(
          children: [
            Container(
              height: 10,
              width: 10,
              color: Colors.blue,
            ),
            Text("Profit"),
          ],
        ),
      ],
    );
  }

  pieChart() {
    return SizedBox(
      height: 200,
      width: 200,
      child: PieChart(
        PieChartData(
          pieTouchData: PieTouchData(
            touchCallback: (FlTouchEvent event, pieTouchResponse) {
              setState(() {
                if (!event.isInterestedForInteractions ||
                    pieTouchResponse == null ||
                    pieTouchResponse.touchedSection == null) {
                  touchedIndex = -1;
                  return;
                }
                touchedIndex =
                    pieTouchResponse.touchedSection!.touchedSectionIndex;
              });
            },
          ),
          centerSpaceRadius: 40,
          borderData: FlBorderData(show: false),
          sections: showingData(),
        ),
      ),
    );
  }

  PieChartSectionData pieSectionData(
    double value, {
    double? radius = 20,
    bool? isTouched = false,
    List<int>? showTooltips = const [],
  }) {
    return PieChartSectionData(
      color: randomColorSet(),
      value: value,
      radius: radius,
      title: "$value%",
      titleStyle: textStyle(isTouched: isTouched),
    );
  }

  Color randomColorSet() {
    return colorSet[Random().nextInt(colorSet.length)];
  }

  TextStyle textStyle({bool? isTouched = false}) {
    return TextStyle(
      fontSize: isTouched! ? 21 : 16,
    );
  }

  List<PieChartSectionData> showingData() {
    return List.generate(5, (i) {
      final isTouched = i == touchedIndex;
      final radius = isTouched ? 25.0 : 20.0;

      return pieSectionData(i * 10.0 + 10,
          isTouched: i == touchedIndex, radius: radius);
    });
  }
}