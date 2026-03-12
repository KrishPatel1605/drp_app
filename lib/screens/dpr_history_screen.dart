import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/dpr_provider.dart';
import '../widgets/dpr_card.dart';

class DPRHistoryScreen extends StatelessWidget {
  const DPRHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final reports = Provider.of<DPRProvider>(context).reports;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("DPR History"),
        centerTitle: true,
      ),
      body: reports.isEmpty
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(32.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surfaceContainerHighest.withOpacity(0.5),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.history_toggle_off_rounded,
                        size: 64,
                        color: theme.colorScheme.primary.withOpacity(0.7),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      "No History Yet",
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "You haven't submitted any Daily Progress Reports yet. Once you do, they will appear here.",
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: reports.length,
              itemBuilder: (context, index) {
                final report = reports[index];
                
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: DPRCard(report: report),
                );
              },
            ),
    );
  }
}