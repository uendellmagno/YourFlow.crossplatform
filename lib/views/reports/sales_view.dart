import 'package:flutter/material.dart';
import 'package:your_flow/views/reports/TEMPORARY/temporary_view.dart';

class SalesView extends StatelessWidget {
  const SalesView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Sales',
          style: TextStyle(
            fontSize: 15,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(8.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF5c6bc0),
                  enableFeedback: true,
                  splashFactory: InkRipple.splashFactory,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  showBottomSheet(
                    context: context,
                    showDragHandle: true,
                    enableDrag: true,
                    constraints: BoxConstraints(
                      maxHeight: MediaQuery.of(context).size.height - 150,
                    ),
                    builder: (context) => const TemporaryView(),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.only(
                    top: 17,
                    bottom: 17,
                  ),
                  child: Text(
                    "Coming soon",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
