import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:intl/intl.dart';
import 'package:your_flow/services/api_ops.dart';

class QICardsState extends StatefulWidget {
  final ApiOps apiOps;
  const QICardsState({super.key, required this.apiOps});

  @override
  State<QICardsState> createState() => QICardsList();
}

class QICardsList extends State<QICardsState> {
  late Future<Map<String, dynamic>> data;

  @override
  void initState() {
    super.initState();
    data = widget.apiOps.cardsHome();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      scrollDirection: Axis.horizontal,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            QICard(
              title: "Total Sales",
              type: "USD",
              data: data,
              category: "Revenue",
              keyName: "Total Sales",
            ),
            QICard(
              title: "Units",
              type: "QTD.",
              data: data,
              category: "Revenue",
              keyName: "Units",
            ),
            QICard(
              title: "Price",
              type: "USD",
              data: data,
              category: "Revenue",
              keyName: "Price",
            ),
            QICard(
              title: "Ads Sales",
              type: "USD",
              data: data,
              category: "Marketing",
              keyName: "ADS Sales",
            ),
            QICard(
              title: "Ads Spend",
              type: "USD",
              data: data,
              category: "Marketing",
              keyName: "ADS Spend",
            ),
            QICard(
              title: "CTR",
              type: "%",
              data: data,
              category: "Marketing",
              keyName: "CTR",
            ),
          ],
        ),
      ),
    );
  }
}

class QICard extends StatelessWidget {
  final String title;
  final String type;
  final Future<Map<String, dynamic>> data;
  final String category;
  final String keyName;

  const QICard({
    super.key,
    required this.title,
    required this.type,
    required this.data,
    required this.category,
    required this.keyName,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 230,
      width: 190,
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
              final cardData = snapshot.data![category][keyName];
              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(14),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          title,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          type,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF9a9a9a),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: Text(
                      formatValue(cardData, type),
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  deltas(context, cardData),
                ],
              );
            }
          },
        ),
      ),
    );
  }

  String formatValue(Map<String, dynamic> cardData, String type) {
    final value = cardData['current'];
    if (type == '%') {
      return "${value.toStringAsFixed(2)}%";
    } else if (type == "USD") {
      return NumberFormat.simpleCurrency(name: 'USD').format(value);
    } else if (type == 'QTD.') {
      return "${value.toStringAsFixed(0)}";
    } else {
      return value.toString(); // Default formatting
    }
  }

  Padding deltas(BuildContext context, Map<String, dynamic> cardData) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildDeltaRow(
              context,
              "1 Day",
              cardData['delta']['1'],
              cardData['delta']['1'] >= 0
                  ? Color(0xFF137201)
                  : Color(0xFFBA1313)),
          _buildDeltaRow(
              context,
              "7 Days",
              cardData['delta']['7'],
              cardData['delta']['7'] >= 0
                  ? Color(0xFF137201)
                  : Color(0xFFBA1313)),
          _buildDeltaRow(
              context,
              "30 Days",
              cardData['delta']['30'],
              cardData['delta']['30'] >= 0
                  ? Color(0xFF137201)
                  : Color(0xFFBA1313)),
        ],
      ),
    );
  }

  Row _buildDeltaRow(
      BuildContext context, String label, double value, Color valueColor) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: SizedBox(
            height: 35,
            child: Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ),
              color: Theme.of(context).cardColor,
              child: Container(
                alignment: Alignment.center,
                child: Text(
                  label,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        ),
        Expanded(
          child: SizedBox(
            height: 35,
            child: Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ),
              color: valueColor,
              child: Container(
                alignment: Alignment.center,
                child: Text(
                  "${value.toStringAsFixed(1)}%",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
