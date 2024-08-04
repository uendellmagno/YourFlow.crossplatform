import 'dart:core';
import 'package:flutter/material.dart';
import 'package:your_flow/services/api_ops.dart';
import 'package:your_flow/views/homepage/widgets/Cards/qi_cards.dart';
import 'package:your_flow/views/homepage/widgets/Charts/custom_chart.dart';

class QuickInsightsView extends StatefulWidget {
  const QuickInsightsView({super.key});

  @override
  QuickInsightsViewState createState() => QuickInsightsViewState();
}

class QuickInsightsViewState extends State<QuickInsightsView> {
  final ApiOps apiOps = ApiOps();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 20, top: 20),
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
