import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class FLChart extends StatelessWidget {
  const FLChart({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 2.0,
      child: LineChart(
        LineChartData(
          lineBarsData: [
            LineChartBarData(
              spots: const [
                FlSpot(0, 0),
                FlSpot(1, 3),
                FlSpot(2, 1),
                FlSpot(3, 8),
                FlSpot(4, 0),
                FlSpot(5, 9),
                FlSpot(6, 2),
              ],
              color: Colors.blue.shade800,
              barWidth: 4,
              isCurved: true,
              preventCurveOverShooting: true,
              isStrokeCapRound: true,
              isStrokeJoinRound: true,
              belowBarData: BarAreaData(
                show: true,
                color: Colors.blue.withOpacity(0.1),
              ),
              dotData: const FlDotData(
                show: false,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
