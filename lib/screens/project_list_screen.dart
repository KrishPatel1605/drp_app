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
        title: const Text("Projects"),

        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const DPRHistoryScreen(),
                ),
              );
            },
          )
        ],
      ),

      body: ListView.builder(
        itemCount: projects.length,

        itemBuilder: (context, index) {
          return ProjectCard(project: projects[index]);
        },
      ),
    );
  }
}