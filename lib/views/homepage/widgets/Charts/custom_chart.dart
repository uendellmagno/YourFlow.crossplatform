/// This file contains the custom chart widget that will be used to display the dynamic data
library;

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:your_flow/services/api_ops.dart';

// This is the custom chart dynamic widget
class CChartState extends StatefulWidget {
  final ApiOps apiOps;
  const CChartState({super.key, required this.apiOps});

  @override
  State<CChartState> createState() => CustomChart();
}

class CustomChart extends State<CChartState> {
  // These are the variables that will be used to store and update the data
  String? _dropdownValue;
  bool _isDailySelected = true;
  int touchedIndex = -1;

  late Future<Map<String, dynamic>> data;
  List<DropdownMenuItem<String>> dropdownItems = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  void fetchData() {
    data = widget.apiOps.graphsHome();
    data.then((dataMap) {
      List<DropdownMenuItem<String>> items = [];

      // This function will add the dropdown items to the list
      void addDropdownItems(Map<String, dynamic>? section, String category) {
        if (section != null) {
          items.addAll(
            section.keys.map((key) {
              return DropdownMenuItem<String>(
                value: '$category|$key',
                child: Text(key),
              );
            }).toList(),
          );
        }
      }

      // Check if the dataMap contains the keys and add the dropdown items
      if (dataMap.containsKey('Revenue')) {
        addDropdownItems(dataMap['Revenue'], 'Revenue');
      }
      if (dataMap.containsKey('Marketing')) {
        addDropdownItems(dataMap['Marketing'], 'Marketing');
      }

      // Update the dropdown items and keep the current _dropdownValue if it exists
      setState(() {
        dropdownItems = items;
        _dropdownValue ??= items.isNotEmpty ? items[0].value : null;
      });
    });
  }

  // This function will be called when the dropdown value changes
  void dropdownCallback(String? selectedValue) {
    setState(() {
      _dropdownValue = selectedValue;
    });
  }

  // This function will build the widget
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        buildChartCard(context),
        buildDropdownButton(),
        buildToggleButtons(),
      ],
    );
  }

  // This function is responsible to build the chart card
  Padding buildChartCard(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        width: double.infinity,
        height: 300,
        child: Card(
          elevation: 0,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            // This will build the card header and body
            children: [
              buildCardHeader(),
              buildCardBody(context),
            ],
          ),
        ),
      ),
    );
  }

  // This function will build the card header
  Flexible buildCardHeader() {
    return Flexible(
      flex: 2,
      child: Padding(
        padding: const EdgeInsets.only(top: 15, left: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _dropdownValue != null
                  ? _dropdownValue!.split('|')[1] == '% Organic'
                      ? 'Organic Sales'
                      : _dropdownValue!.split('|')[1]
                  : "Loading...",
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
            ),
            FutureBuilder<Map<String, dynamic>>(
              future: data,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return LoadingAnimationWidget.waveDots(
                      color: Theme.of(context).primaryColor, size: 40);
                } else if (snapshot.hasError) {
                  return const Text('Error loading data');
                } else if (!snapshot.hasData) {
                  return const Text('No data available');
                } else {
                  return buildTotalValueText(snapshot);
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Text buildTotalValueText(AsyncSnapshot<Map<String, dynamic>> snapshot) {
    var category = _dropdownValue?.split('|')[0];
    var key = _dropdownValue?.split('|')[1];
    var section = snapshot.data![category];

    if (key != null && section != null) {
      var selectedData = section[key];
      if (selectedData != null) {
        var totalKey = _isDailySelected ? 'days' : 'months';
        var values = selectedData[totalKey]?['values'] ?? [];
        var totalValue = values.isNotEmpty ? values.last : 0.0;

        // Define different formatting rules based on the key
        if (['Total Sales', 'Price', 'ADS Sales', 'ADS Spend'].contains(key)) {
          return Text(
            NumberFormat.simpleCurrency().format(totalValue),
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          );
        } else if ([
          '% Organic',
          'ROAS',
          'CTR',
          'TACOS',
          'CPC',
          'Conversion Rate'
        ].contains(key)) {
          return Text(
            '${totalValue.toStringAsFixed(2)}%',
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          );
        } else if (['Units', 'Impressions', 'Clicks'].contains(key)) {
          return Text(
            NumberFormat.decimalPattern().format(totalValue),
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          );
        }
      }
    }
    return const Text('No data available');
  }

  // This function will build the card body
  Expanded buildCardBody(BuildContext context) {
    return Expanded(
      flex: 5,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: barChart(),
      ),
    );
  }

  // This function will build the dropdown button
  Padding buildDropdownButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: SizedBox(
          width: double.infinity,
          height: 60,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                icon: const Icon(Icons.arrow_drop_down_rounded),
                value: _dropdownValue,
                borderRadius: BorderRadius.circular(12),

                hint: const Text('Select a category'),
                enableFeedback: true,
                menuMaxHeight: 300,
                isDense: true,
                alignment: AlignmentDirectional.center,
                items: dropdownItems,
                onChanged: dropdownCallback,
                isExpanded: true,
                dropdownColor: Theme.of(context).brightness == Brightness.dark
                    ? Colors.grey[900]
                    : Colors.white,
                focusColor: Colors.transparent, // Remove focus highlight color
              ),
            ),
          ),
        ),
      ),
    );
  }

  // This function will build the toggle buttons
  Padding buildToggleButtons() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          buildToggleButton("Daily", _isDailySelected, true),
          const SizedBox(width: 10),
          buildToggleButton("Monthly", !_isDailySelected, false),
        ],
      ),
    );
  }

  // This function will build a single button for the toggle buttons
  Expanded buildToggleButton(String text, bool isSelected, bool isDaily) {
    return Expanded(
      flex: 3,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: isSelected
              ? const Color(0xFF016AA8)
              : Theme.of(context).brightness == Brightness.dark
                  ? Colors.grey[900]
                  : Colors.grey[200],
          foregroundColor: isSelected
              ? Colors.white
              : Theme.of(context).brightness == Brightness.dark
                  ? Colors.white
                  : Colors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
        onPressed: () {
          setState(() {
            _isDailySelected = isDaily;
            fetchData();
          });
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Text(text),
        ),
      ),
    );
  }

  // This function will build the bar chart view
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
          return buildBarChart(snapshot);
        }
      },
    );
  }

  // This function will build the bar chart
  Widget buildBarChart(AsyncSnapshot<Map<String, dynamic>> snapshot) {
    var category = _dropdownValue?.split('|')[0];
    var key = _dropdownValue?.split('|')[1];
    var section = snapshot.data![category];
    if (key != null && section != null) {
      var selectedData = section[key];
      if (selectedData != null) {
        var totalKey = _isDailySelected ? 'days' : 'months';
        var values = selectedData[totalKey]?['values'] ?? [];
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
                    touchedIndex = barTouchResponse.spot!.touchedBarGroupIndex;
                  });
                }),
            gridData: const FlGridData(show: false),
            titlesData: const FlTitlesData(
              show: true,
              leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
              rightTitles:
                  AxisTitles(sideTitles: SideTitles(showTitles: false)),
              topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            ),
            borderData: FlBorderData(show: false),
            barGroups: showingGroups(values),
          ),
        );
      }
    }
    return const Center(child: Text('No data available'));
  }

  // This function will build each unique bar group
  BarChartGroupData barGroupData(
    int x,
    double y, {
    bool isTouched = false,
    double width = 30,
    List<int> showTooltips = const [],
  }) {
    return BarChartGroupData(x: x, barRods: [
      BarChartRodData(
        toY: isTouched ? y + 1 : y,
        borderRadius: const BorderRadius.all(Radius.circular(4)),
        color: const Color(0xFF016AA8),
        width: width,
      ),
    ]);
  }

  // This function will build the bar chart groups
  List<BarChartGroupData> showingGroups(List<dynamic> data) {
    return data.asMap().entries.map((entry) {
      int index = entry.key;
      double value = entry.value.toDouble();
      return barGroupData(index, value);
    }).toList();
  }
}
