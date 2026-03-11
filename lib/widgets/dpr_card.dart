import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/dpr.dart';
import '../screens/dpr_detail_screen.dart';

class DPRCard extends StatelessWidget {

  final DPR report;

  const DPRCard({super.key, required this.report});

  @override
  Widget build(BuildContext context) {

    return Card(
      margin: const EdgeInsets.all(10),

      child: ListTile(
        title: Text(report.project),

        subtitle: Text(
          DateFormat.yMMMd().format(report.date),
        ),

        trailing: const Icon(Icons.arrow_forward),

        onTap: () {

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => DPRDetailScreen(report: report),
            ),
          );

        },
      ),
    );
  }
}