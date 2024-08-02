import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:your_flow/services/api_ops.dart';

class SalesMixProvider extends StatelessWidget {
  final ApiOps apiOps;
  const SalesMixProvider({super.key, required this.apiOps});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          SalesMixCard(label: "Countries", apiOps: apiOps, dataType: "country"),
          // const SizedBox(height: 15),
          SalesMixCard(
              label: "Marketplaces", apiOps: apiOps, dataType: "mktplace"),
        ],
      ),
    );
  }
}

class SalesMixCard extends StatefulWidget {
  final ApiOps apiOps;
  final String label;
  final String dataType; // To differentiate between countries and marketplaces

  const SalesMixCard({
    super.key,
    required this.label,
    required this.apiOps,
    required this.dataType,
  });

  @override
  State<SalesMixCard> createState() => _SalesMixCardState();
}

class _SalesMixCardState extends State<SalesMixCard> {
  int touchedIndex = -1; // Index of the touched section
  late List<Color> colorSet;
  late Future<Map<String, dynamic>> data;

  @override
  void initState() {
    super.initState();
    colorSet = generateColorSet();
    data = widget.apiOps.mktshareHome();
  }

  List<Color> generateColorSet() {
    return [
      const Color(0xFF016AA8),
      const Color(0xFF008CFF),
      const Color(0xFF132442),
      const Color(0xFF167979),
      const Color(0xFF3baee1),
      const Color(0xFF3b8ac0),
      const Color(0xFF3b6ea8),
      const Color(0xFF3b4e8c),
      const Color(0xFF3b3b6e),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 210,
      width: double.infinity,
      child: Card(
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
            } else if (!snapshot.hasData) {
              return const Center(child: Text('No data available'));
            } else {
              final apiData = snapshot.data![widget.dataType];
              final pieChartSections = generatePieChartSections(apiData);
              return Column(
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
                      padding: const EdgeInsets.only(
                        left: 12,
                        right: 12,
                        bottom: 12,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(flex: 3, child: legends(apiData)),
                          const SizedBox(width: 10),
                          Flexible(
                            flex: 4,
                            child: LayoutBuilder(
                              builder: (context, constraints) {
                                final size = constraints.maxHeight;
                                return SizedBox(
                                  height: size,
                                  width: size,
                                  child: pieChart(pieChartSections),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            }
          },
        ),
      ),
    );
  }

  Widget legends(Map<String, dynamic> data) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: data.entries.map((entry) {
        final color =
            colorSet[data.keys.toList().indexOf(entry.key) % colorSet.length];
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 2),
          child: Row(
            children: [
              Container(
                height: 10,
                width: 10,
                color: color,
              ),
              const SizedBox(width: 5),
              Text(entry.key),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget pieChart(List<PieChartSectionData> sections) {
    return AspectRatio(
      aspectRatio: 1,
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
          borderData: FlBorderData(show: false),
          startDegreeOffset: 180,
          sections: sections,
        ),
      ),
    );
  }

  TextStyle textStyle({bool isTouched = false}) {
    return TextStyle(
      fontSize: isTouched ? 20 : 14,
      fontWeight: FontWeight.bold,
    );
  }

  List<PieChartSectionData> generatePieChartSections(
      Map<String, dynamic> data) {
    return data.entries.toList().asMap().entries.map((entry) {
      final index = entry.key;
      final pieEntry = entry.value.value;
      final isTouched = index == touchedIndex;

      return PieChartSectionData(
        titlePositionPercentageOffset: 1.5,
        color: colorSet[index % colorSet.length],
        value: pieEntry.toDouble(),
        title: touchedIndex == -1 || isTouched ? "$pieEntry%" : "",
        radius: isTouched ? 30.0 : 25.0,
        titleStyle: textStyle(isTouched: isTouched),
      );
    }).toList();
  }
}
