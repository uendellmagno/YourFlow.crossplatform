import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ProductsRankingView extends StatelessWidget {
  const ProductsRankingView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        Padding(
          padding: EdgeInsets.only(left: 20, top: 20),
          child: Row(
            children: [
              Icon(FontAwesomeIcons.fireFlameCurved, size: 17),
              SizedBox(width: 5),
              Text("Products Ranking", style: TextStyle(fontSize: 15)),
            ],
          ),
        ),
        SizedBox(height: 10),
      ],
    );
  }
}
