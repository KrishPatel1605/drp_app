import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../models/dpr.dart';
import '../providers/dpr_provider.dart';

class DPRFormScreen extends StatefulWidget {
  final String projectName;

  const DPRFormScreen({super.key, required this.projectName});

  @override
  State<DPRFormScreen> createState() => _DPRFormScreenState();
}

class _DPRFormScreenState extends State<DPRFormScreen> {
  final _formKey = GlobalKey<FormState>();

  DateTime? selectedDate;
  String weather = "Sunny";
  String description = "";
  int workers = 0;

  List<File> images = [];

  final picker = ImagePicker();

  Future pickImage() async {
    if (images.length >= 3) return;

    final picked = await picker.pickImage(source: ImageSource.gallery);

    if (picked != null) {
      setState(() {
        images.add(File(picked.path));
      });
    }
  }

  void submit() {
    if (!_formKey.currentState!.validate() || selectedDate == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Fill all fields")));
      return;
    }

    final report = DPR(
      project: widget.projectName,
      date: selectedDate!,
      weather: weather,
      description: description,
      workers: workers,
      photos: images.map((e) => e.path).toList(),
    );

    Provider.of<DPRProvider>(context, listen: false).addReport(report);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("DPR Submitted Successfully")),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("DPR - ${widget.projectName}"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                ListTile(
                  title: Text(selectedDate == null
                      ? "Select Date"
                      : DateFormat.yMMMd().format(selectedDate!)),
                  trailing: const Icon(Icons.calendar_today),
                  onTap: () async {
                    final date = await showDatePicker(
                      context: context,
                      firstDate: DateTime(2020),
                      lastDate: DateTime.now(),
                      initialDate: DateTime.now(),
                    );

                    setState(() {
                      selectedDate = date;
                    });
                  },
                ),
                DropdownButtonFormField(
                  value: weather,
                  items: ["Sunny", "Rainy", "Cloudy"]
                      .map((e) => DropdownMenuItem(
                            value: e,
                            child: Text(e),
                          ))
                      .toList(),
                  onChanged: (v) => weather = v!,
                  decoration: const InputDecoration(labelText: "Weather"),
                ),
                TextFormField(
                  maxLines: 3,
                  decoration:
                      const InputDecoration(labelText: "Work Description"),
                  validator: (v) =>
                      v!.isEmpty ? "Description required" : null,
                  onChanged: (v) => description = v,
                ),
                TextFormField(
                  keyboardType: TextInputType.number,
                  decoration:
                      const InputDecoration(labelText: "Worker Count"),
                  validator: (v) =>
                      v!.isEmpty ? "Enter worker count" : null,
                  onChanged: (v) => workers = int.parse(v),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: pickImage,
                  child: const Text("Upload Photo"),
                ),
                Wrap(
                  children: images
                      .map((img) => Padding(
                            padding: const EdgeInsets.all(5),
                            child: Image.file(
                              img,
                              height: 80,
                              width: 80,
                              fit: BoxFit.cover,
                            ),
                          ))
                      .toList(),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: submit,
                  child: const Text("Submit DPR"),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}