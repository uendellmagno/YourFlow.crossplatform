import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:your_flow/services/api_ops.dart';

class CChartState extends StatefulWidget {
  final ApiOps apiOps;
  const CChartState({super.key, required this.apiOps});

  @override
  State<CChartState> createState() => CustomChart();
}

class CustomChart extends State<CChartState> {
  String? _dropdownValue = 'Loading...'; // Initialize with a default value

  bool _isDailySelected = false;
  int touchedIndex = -1;

  late Future<Map<String, dynamic>> data;
  List<DropdownMenuItem<String>> dropdownItems = [];

  @override
  void initState() {
    super.initState();
    data = widget.apiOps.graphsHome();
    data.then((dataMap) {
      // Initialize an empty list for dropdown items
      List<DropdownMenuItem<String>> dropdownItems = [];

      // Function to add DropdownMenuItems for given keys
      void addDropdownItems(Map<String, dynamic> section) {
        dropdownItems.addAll(
          section.keys.map((key) {
            return DropdownMenuItem<String>(
              value: key,
              child: Text(key),
            );
          }).toList(),
        );
      }

      // Check for and add keys from 'Revenue' and 'Marketing'
      if (dataMap.containsKey('Revenue')) {
        addDropdownItems(dataMap['Revenue']);
      }

      if (dataMap.containsKey('Marketing')) {
        addDropdownItems(dataMap['Marketing']);
      }

      setState(() {
        // Set the dropdown items and default selected value
        _dropdownValue =
            dropdownItems.isNotEmpty ? dropdownItems[0].value : null;
        this.dropdownItems = dropdownItems;
      });
    }).catchError((error) {
      // Handle any errors from fetching data
      print('Error fetching data: $error');
    });
  }

  void dropdownCallback(String? selectedValue) {
    setState(() {
      _dropdownValue = selectedValue;
    });
  }

  @override
  Widget build(BuildContext context) {
    // print(data.toString);
    // print(_dropdownValue);
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
                      child: barChart(),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 12),
          child: SizedBox(
            width: double.infinity,
            height: 60,
            child: dropdownButton(),
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

  DropdownButton<String> dropdownButton() {
    return DropdownButton(
      icon: Icon(Icons.arrow_drop_down_circle_rounded),
      value: _dropdownValue,
      underline: Container(),
      items: dropdownItems,
      onChanged: dropdownCallback,
      isExpanded: true,
    );
  }

  Widget barChart() {
    return FutureBuilder<Map<String, dynamic>>(
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
          return BarChart(
            BarChartData(
              barTouchData: BarTouchData(
                  touchTooltipData: BarTouchTooltipData(
                    fitInsideHorizontally: true,
                    tooltipHorizontalAlignment: FLHorizontalAlignment.right,
                    tooltipMargin: -10,
                  ),
                  touchCallback: (FlTouchEvent event, barTouchResponse) {
                    setState(() {
                      if (!event.isInterestedForInteractions ||
                          barTouchResponse == null ||
                          barTouchResponse.spot == null) {
                        touchedIndex = -1;
                        return;
                      }
                      touchedIndex =
                          barTouchResponse.spot!.touchedBarGroupIndex;
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
              barGroups: showingGroups(snapshot.data!),
            ),
          );
        }
      },
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

  List<BarChartGroupData> showingGroups(Map<String, dynamic> data) {
    return data.keys.map((entry) {
      //TODO - print('HEY THE KEY IS RIGHT HERE: $entry, Value: ${data[entry]}');
      return barGroupData(entry.hashCode, 2);
    }).toList();
  }
}

// List<BarChartGroupData> showingGroups(Map<String, dynamic> data) {
//   List<BarChartGroupData> barChartGroupData = [];
//   int index = 0;
  
//   data.forEach((key, value) {
//     print('Key: $key, Value: $value');
//     barChartGroupData.add(barGroupData(index, value));
//     index++;
//   });

//   return barChartGroupData;
// }
