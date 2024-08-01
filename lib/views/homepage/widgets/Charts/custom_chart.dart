import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class CChartState extends StatefulWidget {
  const CChartState({super.key});

  @override
  State<CChartState> createState() => CustomChart();
}

class CustomChart extends State<CChartState> {
  String? _dropdownValue = 'Item1'; // Initialize with a default value

  // final List<bool> _toggleButton = [false, true];
  bool _isDailySelected = false;

  int touchedIndex = -1;

  void dropdownCallback(String? selectedValue) {
    setState(() {
      _dropdownValue = selectedValue;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.all(8.0),
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
                  Flexible(
                    flex: 2,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 15, left: 15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Total Sales",
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            "\$ 1,257,992",
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Spacer(),
                  Flexible(
                    flex: 5,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: BarChart(
                        BarChartData(
                          barTouchData: BarTouchData(
                              touchTooltipData: BarTouchTooltipData(
                                fitInsideHorizontally: true,
                                tooltipHorizontalAlignment:
                                    FLHorizontalAlignment.right,
                                tooltipMargin: -10,
                                getTooltipItem:
                                    (group, groupIndex, rod, rodIndex) {
                                  String weekDay;
                                  switch (group.x) {
                                    case 0:
                                      weekDay = 'Monday';
                                      break;
                                    case 1:
                                      weekDay = 'Tuesday';
                                      break;
                                    case 2:
                                      weekDay = 'Wednesday';
                                      break;
                                    case 3:
                                      weekDay = 'Thursday';
                                      break;
                                    case 4:
                                      weekDay = 'Friday';
                                      break;
                                    case 5:
                                      weekDay = 'Saturday';
                                      break;
                                    case 6:
                                      weekDay = 'Sunday';
                                      break;
                                    default:
                                      weekDay = '';
                                  }
                                  return BarTooltipItem(
                                    '$weekDay\n',
                                    const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                    ),
                                    children: <TextSpan>[
                                      TextSpan(
                                        text: (rod.toY - 1).toString(),
                                        style: const TextStyle(
                                          color: Colors
                                              .white, //widget.touchedBarColor,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              ),
                              touchCallback:
                                  (FlTouchEvent event, barTouchResponse) {
                                setState(() {
                                  if (!event.isInterestedForInteractions ||
                                      barTouchResponse == null ||
                                      barTouchResponse.spot == null) {
                                    touchedIndex = -1;
                                    return;
                                  }
                                  touchedIndex = barTouchResponse
                                      .spot!.touchedBarGroupIndex;
                                });
                              }),
                          gridData: FlGridData(
                            show: false,
                          ),
                          titlesData: FlTitlesData(
                            show: true,
                            leftTitles: AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                            rightTitles: AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                            topTitles: AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                          ),
                          borderData: FlBorderData(
                            show: false,
                          ),
                          barGroups: showingGroups(
                            List.generate(20, (index) => index.toDouble()),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        // TODO - Rebuild this
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 12),
          child: SizedBox(
            width: double.infinity,
            height: 60,
            child: DropdownButton(
              icon: Icon(Icons.arrow_drop_down_circle_rounded),
              value: _dropdownValue,
              underline: Container(),
              // TODO - Render this dynamically through the API
              items: [
                DropdownMenuItem(value: 'Item1', child: Text("Item 1")),
                DropdownMenuItem(value: 'Item2', child: Text("Item 2")),
                DropdownMenuItem(value: 'Item3', child: Text("Item 3")),
                DropdownMenuItem(value: 'Item4', child: Text("Item 4")),
                DropdownMenuItem(value: 'Item5', child: Text("Item 5")),
                DropdownMenuItem(value: 'Item6', child: Text("Item 6")),
                DropdownMenuItem(value: 'Item7', child: Text("Item 7")),
              ],
              onChanged: dropdownCallback,
              isExpanded: true,
            ),
          ),
        ),

        Padding(
          padding: EdgeInsets.symmetric(horizontal: 18, vertical: 7),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                flex: 3,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        _isDailySelected ? Color(0xFF016AA8) : Colors.grey[200],
                    foregroundColor:
                        _isDailySelected ? Colors.white : Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  onPressed: () {
                    setState(() {
                      _isDailySelected = true;
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 10,
                    ),
                    child: Text('Daily'),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                flex: 3,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: !_isDailySelected
                        ? Color(0xFF016AA8)
                        : Colors.grey[200],
                    foregroundColor:
                        !_isDailySelected ? Colors.white : Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  onPressed: () {
                    setState(() {
                      _isDailySelected = false;
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Text('Monthly'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  BarChartGroupData barGroupData(
    int x,
    double y, {
    bool isTouched = false,
    double width = 30,
    List<int> showTooltips = const [],
  }) {
    return BarChartGroupData(x: x, barRods: [
      BarChartRodData(
        toY: isTouched ? y + 2 : y,
        borderRadius: BorderRadius.all(Radius.circular(4)),
        color: Color(0xFF016AA8),
        width: width,
      ),
    ]);
  }

  List<BarChartGroupData> showingGroups(List<double> amounts) {
    int amount = 7;
    return List.generate(amount, (i) {
      // TODO - temp logix
      return barGroupData(i + 1, i.toDouble(),
          width: amount > 7 ? 5 : 30, isTouched: i == touchedIndex);
    });
  }
}
