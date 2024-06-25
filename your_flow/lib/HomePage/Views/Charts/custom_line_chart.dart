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
                FlSpot(1, 6),
                FlSpot(2, 1),
                FlSpot(3, 9),
                FlSpot(4, 0),
                FlSpot(5, 9),
                FlSpot(6, 2),
              ],
              gradient: const LinearGradient(
                colors: [
                  Colors.red,
                  Colors.purpleAccent,
                  Colors.lightBlueAccent,
                ],
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
              ),
              barWidth: 4,
              isCurved: true,
              preventCurveOverShooting: true,
              isStrokeCapRound: true,
              isStrokeJoinRound: true,
              belowBarData: BarAreaData(
                show: true,
                color: Colors.red.withOpacity(0.3),
              ),
              aboveBarData: BarAreaData(
                show: true,
                color: Colors.green.withOpacity(0.3),
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