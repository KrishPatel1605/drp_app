import 'package:flutter/material.dart';
import '../models/project.dart';
import '../screens/dpr_form_screen.dart';

class ProjectCard extends StatelessWidget {
  final Project project;

  const ProjectCard({super.key, required this.project});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(10),
      child: ListTile(
        title: Text(project.name),
        subtitle: Text("Status: ${project.status}\nStart: ${project.startDate}"),
        trailing: const Icon(Icons.arrow_forward),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => DPRFormScreen(projectName: project.name),
            ),
          );
        },
      ),
    );
  }
}