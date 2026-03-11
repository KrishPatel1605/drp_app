import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/dpr_provider.dart';
import '../widgets/dpr_card.dart';

class DPRHistoryScreen extends StatelessWidget {

  const DPRHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {

    final reports = Provider.of<DPRProvider>(context).reports;

    return Scaffold(
      appBar: AppBar(
        title: const Text("DPR History"),
      ),

      body: reports.isEmpty
          ? const Center(
              child: Text("No DPR submitted yet"),
            )
          : ListView.builder(
              itemCount: reports.length,
              itemBuilder: (context, index) {

                final report = reports[index];

                return DPRCard(report: report);

              },
            ),
    );
  }
}