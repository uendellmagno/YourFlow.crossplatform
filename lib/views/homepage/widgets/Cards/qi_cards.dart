import 'package:flutter/material.dart';
import 'package:your_flow/services/api_ops.dart';

class QICardsList extends StatelessWidget {
  const QICardsList({
    super.key,
    required this.apiOps,
  });

  final ApiOps apiOps;

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
              fetchData: apiOps.graphsRevenue,
            ),
            QICard(
              title: "Units",
              type: "QTD.",
              fetchData: apiOps.graphsRevenue,
            ),
            QICard(
              title: "Price",
              type: "USD",
              fetchData: apiOps.graphsRevenue,
            ),
            QICard(
              title: "Ads Sales",
              type: "USD",
              fetchData: apiOps.graphsRevenue,
            ),
            QICard(
              title: "Ads Spend",
              type: "USD",
              fetchData: apiOps.graphsRevenue,
            ),
            QICard(
              title: "CTR",
              type: "%",
              fetchData: apiOps.graphsRevenue,
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
  final Future<Map<String, dynamic>> Function() fetchData;

  const QICard({
    super.key,
    required this.title,
    required this.type,
    required this.fetchData,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 230,
      width: 190,
      child: Card(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(14),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    textAlign: TextAlign.start,
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    textAlign: TextAlign.end,
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
                textAlign: TextAlign.center,
                "\$1,258,945",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            deltas(context),
          ],
        ),
      ),
    );
  }

  Padding deltas(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildDeltaRow(context, "1 Day", "245%", Color(0xFF137201)),
          _buildDeltaRow(context, "7 Days", "-75%", Color(0xFFBA1313)),
          _buildDeltaRow(context, "30 Days", "-28%", Color(0xFFBA1313)),
        ],
      ),
    );
  }

  Row _buildDeltaRow(
      BuildContext context, String label, String value, Color valueColor) {
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
                  style: TextStyle(fontWeight: FontWeight.bold),
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
                  value,
                  style: TextStyle(
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