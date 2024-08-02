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
          SizedBox(height: 15),
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
                      padding: const EdgeInsets.all(8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          legends(apiData),
                          pieChart(pieChartSections),
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
      children: data.entries.map((entry) {
        final color =
            colorSet[data.keys.toList().indexOf(entry.key) % colorSet.length];
        return Row(
          children: [
            Container(
              height: 10,
              width: 10,
              color: color,
            ),
            SizedBox(width: 5),
            Text(entry.key),
          ],
        );
      }).toList(),
    );
  }

  Widget pieChart(List<PieChartSectionData> sections) {
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
          sections: sections,
        ),
      ),
    );
  }

  TextStyle textStyle({bool isTouched = false}) {
    return TextStyle(
      fontSize: isTouched ? 21 : 16,
      fontWeight: FontWeight.bold,
      color: isTouched ? Colors.white : Colors.black,
    );
  }

  List<PieChartSectionData> generatePieChartSections(
      Map<String, dynamic> data) {
    return data.entries.toList().asMap().entries.map((entry) {
      final index = entry.key;
      final pieEntry = entry.value.value;
      final isTouched = index == touchedIndex;
      return PieChartSectionData(
        color: colorSet[index % colorSet.length],
        value: pieEntry.toDouble(),
        title: "$pieEntry%",
        radius: isTouched ? 25.0 : 20.0,
        titleStyle: textStyle(isTouched: isTouched),
      );
    }).toList();
  }
}
