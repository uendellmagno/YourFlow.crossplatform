import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:your_flow/services/api_ops.dart';
import 'package:your_flow/views/homepage/widgets/Cards/qi_cards.dart';

class TemporaryView extends StatelessWidget {
  const TemporaryView({super.key});

  @override
  Widget build(BuildContext context) {
    final data = ApiOps().cardsHome();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Temporary View',
          style: TextStyle(
            fontSize: 15,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Wrap(
          children: [
            const Padding(
              padding: EdgeInsets.all(12),
              child: Row(
                children: [
                  Icon(Icons.bar_chart_rounded, size: 20),
                  SizedBox(width: 5),
                  Text("Revenue", style: TextStyle(fontSize: 15)),
                ],
              ),
            ),
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
            const Padding(
              padding: EdgeInsets.all(12.0),
              child: Row(
                children: [
                  Icon(FontAwesomeIcons.bullhorn, size: 17),
                  SizedBox(width: 5),
                  Text("Marketing", style: TextStyle(fontSize: 15)),
                ],
              ),
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
            QICard(
              title: "Organic",
              type: "%",
              data: data,
              category: "Marketing",
              keyName: "% Organic",
            ),
            QICard(
              title: "ROAS",
              type: "%",
              data: data,
              category: "Marketing",
              keyName: "ROAS",
            ),
            QICard(
              title: "TACOS",
              type: "%",
              data: data,
              category: "Marketing",
              keyName: "TACOS",
            ),
            QICard(
              title: "CPC",
              type: "%",
              data: data,
              category: "Marketing",
              keyName: "CPC",
            ),
            QICard(
              title: "Conversion Rate",
              type: "%",
              data: data,
              category: "Marketing",
              keyName: "Conversion Rate",
            ),
            QICard(
              title: "Impressions",
              type: "QTD.",
              data: data,
              category: "Marketing",
              keyName: "Impressions",
            ),
            QICard(
              title: "Clicks",
              type: "QTD.",
              data: data,
              category: "Marketing",
              keyName: "Clicks",
            ),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Icon(FontAwesomeIcons.bullhorn, size: 20),
                  SizedBox(width: 5),
                  Text("Inventory", style: TextStyle(fontSize: 15)),
                ],
              ),
            ),
            QICard(
              title: "Available Units",
              type: "QTD.",
              data: data,
              category: "Inventory",
              keyName: "Available Units",
            ),
            QICard(
              title: "FC Transfer",
              type: "QTD.",
              data: data,
              category: "Inventory",
              keyName: "FC Transfer",
            ),
            QICard(
              title: "FC Processing",
              type: "QTD.",
              data: data,
              category: "Inventory",
              keyName: "FC Processing",
            ),
            QICard(
              title: "Unfulfillable",
              type: "QTD.",
              data: data,
              category: "Inventory",
              keyName: "Unfulfillable",
            ),
            QICard(
              title: "Days of Stock",
              type: "QTD.",
              data: data,
              category: "Inventory",
              keyName: "Days of Stock",
            ),
          ],
        ),
      ),
    );
  }
}
