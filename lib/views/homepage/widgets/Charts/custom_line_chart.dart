import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

// This is the boxed line chart widget
class BoxedLineChart extends StatelessWidget {
  final String defaultVar;

  const BoxedLineChart({
    super.key,
    required this.defaultVar,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      elevation: 3,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  defaultVar,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Text(
                  'per week',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(
                      FontAwesomeIcons.arrowUp,
                      size: 14,
                      color: Colors.green,
                    ),
                    const SizedBox(width: 4),
                    const Text(
                      '72%',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.green,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: const CustomLineChart(),
            ),
          ),
        ],
      ),
    );
  }
}

// This is the line chart widget
class CustomLineChart extends StatelessWidget {
  const CustomLineChart({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SizedBox(
          width: constraints.maxWidth,
          height: constraints.maxHeight,
          child: LineChart(
            LineChartData(
              lineTouchData: LineTouchData(
                touchTooltipData: LineTouchTooltipData(
                  showOnTopOfTheChartBoxArea: true,
                ),
              ),
              gridData: const FlGridData(show: false),
              borderData: FlBorderData(show: false),
              lineBarsData: [
                LineChartBarData(
                  spots: const [
                    FlSpot(0, 4),
                    FlSpot(1, 5),
                    FlSpot(2, 6),
                    FlSpot(3, 6),
                    FlSpot(4, 4),
                    FlSpot(5, 5),
                    FlSpot(6, 5),
                    FlSpot(7, 7),
                  ],
                  color: Theme.of(context).colorScheme.primary,
                  barWidth: 2,
                  preventCurveOverShooting: true,
                  isCurved: true,
                  belowBarData: BarAreaData(
                    show: true,
                    color: Colors.blue.withOpacity(0.1),
                  ),
                  dotData: const FlDotData(show: false),
                  isStrokeCapRound: true,
                ),
              ],
              titlesData: const FlTitlesData(show: false),
            ),
          ),
        );
      },
    );
  }
}
