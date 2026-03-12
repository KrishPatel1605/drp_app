import 'package:flutter/material.dart';
import '../models/project.dart';
import '../widgets/project_card.dart';
import 'dpr_history_screen.dart';

class ProjectListScreen extends StatelessWidget {
  const ProjectListScreen({super.key});

  static final List<Project> projects = [
    Project(name: "Bridge Construction", status: "Active", startDate: "01-01-2026"),
    Project(name: "Highway Expansion", status: "Ongoing", startDate: "15-02-2026"),
    Project(name: "Mall Development", status: "Planning", startDate: "10-03-2026"),
    Project(name: "Metro Tunnel", status: "Active", startDate: "05-01-2026"),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Projects",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: FilledButton.tonalIcon(
              icon: const Icon(Icons.history),
              label: const Text("History"),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const DPRHistoryScreen(),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: projects.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: ProjectCard(project: projects[index]),
          );
        },
      ),
    );
  }
}