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

  Future<void> pickImage() async {
    if (images.length >= 3) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Maximum 3 images allowed")),
      );
      return;
    }

    final pickedFiles = await picker.pickMultiImage();

    if (pickedFiles.isNotEmpty) {
      bool limitReached = false;
      
      setState(() {
        for (var picked in pickedFiles) {
          if (images.length < 3) {
            images.add(File(picked.path));
          } else {
            limitReached = true;
          }
        }
      });

      if (limitReached) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Maximum 3 images allowed. Extra images were discarded."),
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      }
    }
  }

  void submit() {
    if (!_formKey.currentState!.validate() || selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please fill all required fields and select a date"),
          behavior: SnackBarBehavior.floating,
        ),
      );
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
      const SnackBar(
        content: Text("DPR Submitted Successfully"),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
      ),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("New Report"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _FormHeader(projectName: widget.projectName),
              const SizedBox(height: 24),

              _DatePickerField(
                selectedDate: selectedDate,
                onTap: () async {
                  final date = await showDatePicker(
                    context: context,
                    firstDate: DateTime(2020),
                    lastDate: DateTime.now(),
                    initialDate: DateTime.now(),
                  );
                  if (date != null) {
                    setState(() {
                      selectedDate = date;
                    });
                  }
                },
              ),
              const SizedBox(height: 16),

              _WeatherDropdownField(
                value: weather,
                onChanged: (v) {
                  if (v != null) {
                    setState(() => weather = v);
                  }
                },
              ),
              const SizedBox(height: 16),

              _DescriptionField(
                onChanged: (v) => description = v,
              ),
              const SizedBox(height: 16),

              _WorkerCountField(
                onChanged: (v) => workers = int.tryParse(v) ?? 0,
              ),
              const SizedBox(height: 24),

              _PhotoUploadSection(
                images: images,
                onPickImage: pickImage,
              ),
              const SizedBox(height: 32),

              _SubmitButton(onPressed: submit),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}


class _FormHeader extends StatelessWidget {
  final String projectName;

  const _FormHeader({required this.projectName});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Daily Progress Report",
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          projectName,
          style: theme.textTheme.titleMedium?.copyWith(
            color: theme.colorScheme.primary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

class _DatePickerField extends StatelessWidget {
  final DateTime? selectedDate;
  final VoidCallback onTap;

  const _DatePickerField({
    required this.selectedDate,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: "Report Date",
          prefixIcon: const Icon(Icons.calendar_today_outlined),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          filled: true,
          fillColor: theme.colorScheme.surfaceContainerHighest.withOpacity(0.3),
        ),
        child: Text(
          selectedDate == null
              ? "Select a date"
              : DateFormat.yMMMd().format(selectedDate!),
          style: TextStyle(
            color: selectedDate == null
                ? theme.colorScheme.onSurfaceVariant
                : theme.colorScheme.onSurface,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}

class _WeatherDropdownField extends StatelessWidget {
  final String value;
  final ValueChanged<String?> onChanged;

  const _WeatherDropdownField({
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return DropdownButtonFormField<String>(
      value: value,
      icon: const Icon(Icons.keyboard_arrow_down_rounded),
      decoration: InputDecoration(
        labelText: "Weather Conditions",
        prefixIcon: const Icon(Icons.cloud_outlined),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        filled: true,
        fillColor: theme.colorScheme.surfaceContainerHighest.withOpacity(0.3),
      ),
      items: ["Sunny", "Rainy", "Cloudy", "Windy", "Snowy"]
          .map((e) => DropdownMenuItem(
                value: e,
                child: Text(e),
              ))
          .toList(),
      onChanged: onChanged,
    );
  }
}

class _DescriptionField extends StatelessWidget {
  final ValueChanged<String> onChanged;

  const _DescriptionField({required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return TextFormField(
      maxLines: 3,
      decoration: InputDecoration(
        labelText: "Work Description",
        hintText: "Briefly describe the work done today...",
        alignLabelWithHint: true,
        prefixIcon: const Padding(
          padding: EdgeInsets.only(bottom: 48.0), // Align icon to top
          child: Icon(Icons.description_outlined),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        filled: true,
        fillColor: theme.colorScheme.surfaceContainerHighest.withOpacity(0.3),
      ),
      validator: (v) => v == null || v.isEmpty ? "Description required" : null,
      onChanged: onChanged,
    );
  }
}

class _WorkerCountField extends StatelessWidget {
  final ValueChanged<String> onChanged;

  const _WorkerCountField({required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return TextFormField(
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: "Worker Count",
        hintText: "Total workers on site",
        prefixIcon: const Icon(Icons.people_alt_outlined),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        filled: true,
        fillColor: theme.colorScheme.surfaceContainerHighest.withOpacity(0.3),
      ),
      validator: (v) => v == null || v.isEmpty ? "Enter worker count" : null,
      onChanged: onChanged,
    );
  }
}

class _PhotoUploadSection extends StatelessWidget {
  final List<File> images;
  final VoidCallback onPickImage;

  const _PhotoUploadSection({
    required this.images,
    required this.onPickImage,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Site Photos",
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              "${images.length}/3",
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            ...images.map((img) => ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.file(
                    img,
                    height: 90,
                    width: 90,
                    fit: BoxFit.cover,
                  ),
                )),
            
            if (images.length < 3)
              InkWell(
                onTap: onPickImage,
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  height: 90,
                  width: 90,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surfaceContainerHighest.withOpacity(0.5),
                    border: Border.all(
                      color: theme.colorScheme.outlineVariant,
                      style: BorderStyle.solid,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.add_a_photo_outlined,
                    color: theme.colorScheme.primary,
                    size: 32,
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }
}

class _SubmitButton extends StatelessWidget {
  final VoidCallback onPressed;

  const _SubmitButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 52,
      child: FilledButton(
        style: FilledButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onPressed: onPressed,
        child: const Text(
          "Submit DPR",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}