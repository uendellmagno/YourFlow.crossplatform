import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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
          // IconButton(
          //   icon: Icon(Icons.search_rounded),
          //   onPressed: () {},
          // ),
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
                InventoryMetrics(),
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

// This is the Inventory by Day widget that contains the chart
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
                      "263,265",
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
                  interval: 55,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// This is the Inventory Metrics widget that contains the metrics cards
class InventoryMetrics extends StatelessWidget {
  InventoryMetrics({super.key});

  final ApiOps apiOps = ApiOps();

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        Padding(
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
          padding: EdgeInsets.only(top: 20, bottom: 20),
          child: Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              MetricsCard(
                title: "Available Units",
                metric: "48,432",
              ),
              MetricsCard(
                title: "FC Transfer",
                metric: "5,922",
              ),
              MetricsCard(
                title: "FC Processing",
                metric: "2,364",
              ),
              MetricsCard(
                title: "Unfulfillable",
                metric: "592",
              ),
              MetricsCard(
                title: "Units Sold",
                metric: "2,000",
              ),
              MetricsCard(
                title: "Days of Stock",
                metric: "211.68",
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class MetricsCard extends StatelessWidget {
  final String title;
  final String metric;
  const MetricsCard({
    super.key,
    required this.title,
    required this.metric,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: (MediaQuery.of(context).size.width / 2) -
          25, // Adjust the width as needed
      height: 100, // Set the desired height
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          mainAxisAlignment:
              MainAxisAlignment.center, // Center content vertically
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Text(title,
                  style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
            ),
            Text(metric,
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
          ],
        ),
      ),
    );
  }
}

// This is the Reviews Summary widget that contains the reviews summary button that leads to the reviews_view.dart
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

// This is the Global Products Ranking widget that contains the ranking of the best 3 selling products
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
