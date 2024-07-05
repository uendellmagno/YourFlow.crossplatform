/// This is the custom line chart widget, it was built to display the line chart in a card widget.
library;

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

// This is the boxed line chart widget
class BoxedLineChart extends StatelessWidget {
  final String? navigationId;

  const BoxedLineChart({
    super.key,
    this.navigationId,
  });

  @override
  Widget build(BuildContext context) {
    return const Card(
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: FLChart(),
      ),
    );
  }
}

// This is the line chart widget
class FLChart extends StatelessWidget {
  const FLChart({super.key});

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 2.0,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: LineChart(
          LineChartData(
            gridData: const FlGridData(show: false),
            borderData: FlBorderData(show: false),
            lineBarsData: [
              LineChartBarData(
                show: true,
                spots: const [
                  FlSpot(0, 4),
                  FlSpot(1, 5),
                  FlSpot(2, 6),
                  FlSpot(3, 6),
                  FlSpot(4, 4),
                  FlSpot(5, 5),
                  FlSpot(6, 5),
                  FlSpot(7, 7),
                  FlSpot(8, 8),
                  FlSpot(9, 9),
                  FlSpot(10, 5),
                  FlSpot(11, 3),
                  FlSpot(12, 4),
                  FlSpot(13, 1),
                  FlSpot(14, 9),
                  FlSpot(15, 9),
                  FlSpot(16, 3),
                  FlSpot(17, 6),
                  FlSpot(18, 6),
                  FlSpot(19, 7),
                  FlSpot(20, 3),
                  FlSpot(21, 1),
                  FlSpot(22, 9),
                  FlSpot(23, 9),
                  FlSpot(24, 8),
                  FlSpot(25, 7),
                  FlSpot(26, 6),
                  FlSpot(27, 6),
                  FlSpot(28, 7),
                  FlSpot(29, 7),
                  FlSpot(30, 4),
                ],
                color: Colors.red.shade800,
                barWidth: 2,
                preventCurveOverShooting: true,
                isCurved: true,
                preventCurveOvershootingThreshold: 1,
                isStrokeCapRound: true,
                isStrokeJoinRound: true,
                belowBarData: BarAreaData(
                  show: true,
                  color: Colors.red.withOpacity(0.01),
                ),
                dotData: const FlDotData(
                  show: false,
                ),
                shadow: const Shadow(
                  color: Colors.red,
                  blurRadius: 15,
                ),
              ),
              LineChartBarData(
                spots: const [
                  FlSpot(0, 0),
                  FlSpot(1, 3),
                  FlSpot(2, 1),
                  FlSpot(3, 8),
                  FlSpot(4, 0),
                  FlSpot(5, 9),
                  FlSpot(6, 8),
                  FlSpot(7, 8),
                  FlSpot(8, 3),
                  FlSpot(9, 7),
                  FlSpot(10, 2),
                  FlSpot(11, 6),
                  FlSpot(12, 5),
                  FlSpot(13, 8),
                  FlSpot(14, 9),
                  FlSpot(15, 9),
                  FlSpot(16, 6),
                  FlSpot(17, 6),
                  FlSpot(18, 5),
                  FlSpot(19, 8),
                  FlSpot(20, 3),
                  FlSpot(21, 4),
                  FlSpot(22, 4.6),
                  FlSpot(23, 4.3),
                  FlSpot(24, 5),
                  FlSpot(25, 8),
                  FlSpot(26, 3),
                  FlSpot(27, 7),
                  FlSpot(28, 2),
                  FlSpot(29, 6),
                  FlSpot(30, 5),
                ],
                color: Colors.blue.shade800,
                barWidth: 2,
                preventCurveOverShooting: true,
                isCurved: true,
                preventCurveOvershootingThreshold: 1,
                isStrokeCapRound: true,
                isStrokeJoinRound: true,
                belowBarData: BarAreaData(
                  show: true,
                  color: Colors.blue.withOpacity(0.01),
                ),
                dotData: const FlDotData(
                  show: false,
                ),
                shadow: const Shadow(
                  color: Colors.blue,
                  blurRadius: 15,
                ),
              ),
            ],
            betweenBarsData: [
              BetweenBarsData(
                fromIndex: 0,
                toIndex: 1,
                color: Colors.red.withOpacity(0.1),
              )
            ],
            titlesData: const FlTitlesData(show: false),
          ),
        ),
      ),
    );
  }
}
