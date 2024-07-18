import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

// This is the boxed line chart widget
class BoxedLineChart extends StatefulWidget {
  final String defaultVar;
  final Future<Map<String, dynamic>> Function() fetchData;

  const BoxedLineChart({
    super.key,
    required this.defaultVar,
    required this.fetchData,
  });

  @override
  _BoxedLineChartState createState() => _BoxedLineChartState();
}

class _BoxedLineChartState extends State<BoxedLineChart> {
  late Future<Map<String, dynamic>> data;

  @override
  void initState() {
    super.initState();
    data = widget.fetchData();
    print(data);
  }

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
                  widget.defaultVar,
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
                FutureBuilder<Map<String, dynamic>>(
                  future: data,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center();
                    } else if (snapshot.hasError) {
                      return const Text(
                        'Error',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.red,
                        ),
                      );
                    } else {
                      // Calculate the percentage based on the last 2 x spots of the graph or snapshot.data:
                      final List<FlSpot> spots =
                          (snapshot.data!['day']['current'] as Map)
                              .entries
                              .map((entry) =>
                                  FlSpot(double.parse(entry.key), entry.value))
                              .toList();
                      final double lastValue = spots[spots.length - 1].y;
                      final double secondLastValue = spots[spots.length - 2].y;
                      final double percentage =
                          ((lastValue - secondLastValue) / secondLastValue) *
                              100;
                      return Row(
                        children: [
                          Icon(
                            percentage >= 0
                                ? FontAwesomeIcons.arrowUp
                                : FontAwesomeIcons.arrowDown,
                            size: 14,
                            color: percentage >= 0 ? Colors.green : Colors.red,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${percentage.toStringAsFixed(2)}%',
                            style: TextStyle(
                              fontSize: 18,
                              color:
                                  percentage >= 0 ? Colors.green : Colors.red,
                            ),
                          )
                        ],
                      );
                    }
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: FutureBuilder<Map<String, dynamic>>(
                future: data,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: LoadingAnimationWidget.waveDots(
                          color: Theme.of(context).primaryColor, size: 40),
                    );
                  } else if (snapshot.hasError) {
                    return const Center(child: Text('Error loading data'));
                  } else {
                    // Ensure spots is not null and is a List
                    List<FlSpot> spots =
                        (snapshot.data!['day']['current'] as Map)
                            .entries
                            .map((entry) =>
                                FlSpot(double.parse(entry.key), entry.value))
                            .toList();

                    return CustomLineChart(data: spots);
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// This is the line chart widget
class CustomLineChart extends StatelessWidget {
  final List<FlSpot> data;

  const CustomLineChart({super.key, required this.data});
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SizedBox(
          width: constraints.maxWidth,
          height: constraints.maxHeight,
          child: LineChart(
            LineChartData(
              lineTouchData: const LineTouchData(
                touchTooltipData: LineTouchTooltipData(
                  showOnTopOfTheChartBoxArea: true,
                ),
              ),
              gridData: const FlGridData(show: false),
              borderData: FlBorderData(show: false),
              lineBarsData: [
                LineChartBarData(
                  spots: [
                    ...data,
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
