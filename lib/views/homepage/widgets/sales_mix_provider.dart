import 'package:flutter/material.dart';
import 'package:your_flow/services/api_ops.dart';
import 'package:your_flow/views/homepage/widgets/Cards/mktshare_cards.dart';

class SalesMixView extends StatefulWidget {
  const SalesMixView({
    super.key,
  });

  @override
  State<SalesMixView> createState() => _SalesMixViewState();
}

class _SalesMixViewState extends State<SalesMixView> {
  final ApiOps apiOps = ApiOps();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 20, top: 20),
          child: Row(
            children: [
              Icon(Icons.pie_chart_rounded, size: 20),
              SizedBox(width: 5),
              Text("Sales Mix", style: TextStyle(fontSize: 15)),
            ],
          ),
        ),
        const SizedBox(height: 10),
        SalesMixProvider(
          apiOps: apiOps,
        ),
      ],
    );
  }
}
