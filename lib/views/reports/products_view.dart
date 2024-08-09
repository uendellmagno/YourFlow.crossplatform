import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:your_flow/services/api_ops.dart';

class ProductsView extends StatelessWidget {
  const ProductsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Inventory',
          style: TextStyle(
            fontSize: 15,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_alt_rounded),
            onPressed: () {
              showModalBottomSheet(
                shape: const BeveledRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
                context: context,
                builder: (context) {
                  return Container(
                    height: 200,
                    color: Colors.blue,
                  );
                },
              );
            },
          ),
        ],
      ),
      body: YFInventoryView(),
    );
  }
}

class YFInventoryView extends StatelessWidget {
  YFInventoryView({super.key});

  final ApiOps apiOps = ApiOps();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            scrollDirection: Axis.vertical,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IDayChartView(apiOps: apiOps),
                const SizedBox(height: 15),
                InventoryMetrics(apiOps: apiOps),
                const SizedBox(height: 15),
                const ReviewsSummary(),
                const SizedBox(height: 15),
                const ProductsRanking(),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class IDayChartView extends StatelessWidget {
  final ApiOps apiOps;
  const IDayChartView({super.key, required this.apiOps});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 20, top: 20),
          child: Row(
            children: [
              Icon(Icons.warehouse_rounded, size: 15),
              SizedBox(width: 10),
              Text("Inventory by Day", style: TextStyle(fontSize: 15)),
            ],
          ),
        ),
        const SizedBox(height: 20),
        IDayChartProvider(
          fetchData: apiOps.graphsInventory,
        ),
      ],
    );
  }
}

class IDayChartProvider extends StatefulWidget {
  const IDayChartProvider({super.key, required this.fetchData});

  final Future<Map<String, dynamic>> Function() fetchData;

  @override
  State<IDayChartProvider> createState() => _IDayChartState();
}

class _IDayChartState extends State<IDayChartProvider> {
  late Future<Map<String, dynamic>> data;

  @override
  void initState() {
    super.initState();
    data = widget.fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
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
              const Padding(
                padding: EdgeInsets.only(top: 15, left: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Today",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      "NUMBER HERE",
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              ClipRRect(
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
                      // Convert date strings to day of the year for x-axis
                      List<FlSpot> spots = (snapshot.data!['Inventory']
                              ['Inventory by day'] as Map<String, dynamic>)
                          .entries
                          .map((entry) {
                        final dateParts = entry.key.split('/');
                        final month = int.parse(dateParts[0]);
                        final day = int.parse(dateParts[1]);
                        final dayOfYear = DateTime(2024, month, day)
                            .difference(DateTime(2024, 1, 1))
                            .inDays
                            .toDouble();
                        return FlSpot(dayOfYear, entry.value.toDouble());
                      }).toList();

                      return IDayChart(data: spots);
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class IDayChart extends StatelessWidget {
  final List<FlSpot> data;

  const IDayChart({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 15, right: 15, bottom: 10),
      child: SizedBox(
        height: 175,
        width: double.infinity,
        child: LineChart(
          LineChartData(
            lineTouchData: const LineTouchData(
              touchTooltipData: LineTouchTooltipData(
                showOnTopOfTheChartBoxArea: false,
                fitInsideVertically: true,
              ),
            ),
            gridData: const FlGridData(show: false),
            borderData: FlBorderData(
              border: const Border(
                bottom: BorderSide(color: Colors.grey),
              ),
            ),
            lineBarsData: [
              LineChartBarData(
                spots: data,
                isCurved: true,
                color: Theme.of(context).primaryColor,
                barWidth: 2,
                preventCurveOverShooting: true,
                belowBarData: BarAreaData(
                  show: true,
                  color: Colors.blue.withOpacity(0.1),
                ),
                dotData: const FlDotData(show: false),
                isStrokeCapRound: true,
              )
            ],
            titlesData: const FlTitlesData(
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: false,
                ),
              ),
              rightTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: false,
                ),
              ),
              topTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: false,
                ),
              ),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  interval: 10,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class InventoryMetrics extends StatefulWidget {
  final ApiOps apiOps;
  const InventoryMetrics({super.key, required this.apiOps});

  @override
  State<InventoryMetrics> createState() => InventoryMetricsProvider();
}

class InventoryMetricsProvider extends State<InventoryMetrics> {
  late Future<Map<String, dynamic>> data;

  @override
  void initState() {
    super.initState();
    data = widget.apiOps.cardsInventory();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 20, top: 20),
          child: Row(
            children: [
              Icon(Icons.bar_chart_rounded, size: 17),
              SizedBox(width: 10),
              Text("Metrics", style: TextStyle(fontSize: 15)),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 20, bottom: 20),
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
                final metrics = snapshot.data!['Inventory'];
                // print(metrics);
                return Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    MetricsCard(
                      title: "Available Units",
                      metric: metrics["Available Units"]['current'],
                    ),
                    MetricsCard(
                      title: "FC Transfer",
                      metric: metrics["FC Transfer"]['current'],
                    ),
                    MetricsCard(
                      title: "FC Processing",
                      metric: metrics["FC Processing"]['current'],
                    ),
                    MetricsCard(
                      title: "Unfulfillable",
                      metric: metrics["Unfulfillable"]['current'],
                    ),
                    MetricsCard(
                      title: "Days of Stock",
                      metric: metrics["Days of Stock"]['current'],
                    ),
                  ],
                );
              }
            },
          ),
        ),
      ],
    );
  }
}

class MetricsCard extends StatelessWidget {
  final String title;
  final dynamic metric;

  const MetricsCard({
    super.key,
    required this.title,
    required this.metric,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: (MediaQuery.of(context).size.width / 2) - 15,
      height: 100,
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Text(title,
                  style: const TextStyle(
                      fontSize: 15, fontWeight: FontWeight.w600)),
            ),
            Text(
              _formatMetric(title, metric),
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
            ),
          ],
        ),
      ),
    );
  }

  String _formatMetric(String title, dynamic metric) {
    if ([
      'Available Units',
      'FC Transfer',
      'FC Processing',
      'Unfulfillable',
      'Days of Stock',
    ].contains(title)) {
      return NumberFormat.decimalPattern().format(metric);
    }
    return metric.toString(); // Fallback for unrecognized metrics
  }
}

class ReviewsSummary extends StatelessWidget {
  const ReviewsSummary({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 20, top: 20),
          child: Row(
            children: [
              Icon(Icons.thumbs_up_down_rounded, size: 15),
              SizedBox(width: 10),
              Text("Reviews Summary", style: TextStyle(fontSize: 15)),
            ],
          ),
        ),
        const SizedBox(height: 10),
        Container(
          height: 200,
          width: double.infinity,
          color: Colors.blue,
        )
      ],
    );
  }
}

class ProductsRanking extends StatelessWidget {
  const ProductsRanking({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 20, top: 20),
          child: Row(
            children: [
              Icon(FontAwesomeIcons.fireFlameCurved, size: 15),
              SizedBox(width: 10),
              Text("Products Ranking", style: TextStyle(fontSize: 15)),
            ],
          ),
        ),
        const SizedBox(height: 10),
        Container(
          height: 200,
          width: double.infinity,
          color: Colors.blue,
        )
      ],
    );
  }
}
