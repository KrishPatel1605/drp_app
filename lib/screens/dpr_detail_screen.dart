import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/dpr.dart';

class DPRDetailScreen extends StatelessWidget {

  final DPR report;

  const DPRDetailScreen({super.key, required this.report});

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: const Text("DPR Details"),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [

            Text(
              report.project,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            Text("Date: ${DateFormat.yMMMd().format(report.date)}"),
            Text("Weather: ${report.weather}"),
            Text("Workers: ${report.workers}"),

            const SizedBox(height: 15),

            const Text(
              "Work Description",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),

            Text(report.description),

            const SizedBox(height: 20),

            const Text(
              "Photos",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 10),

            Wrap(
              spacing: 10,
              children: report.photos.map((path) {

                return Image.file(
                  File(path),
                  height: 100,
                  width: 100,
                  fit: BoxFit.cover,
                );

              }).toList(),
            )
          ],
        ),
      ),
    );
  }
}