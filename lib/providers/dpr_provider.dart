import 'package:flutter/material.dart';
import '../models/dpr.dart';

class DPRProvider with ChangeNotifier {

  final List<DPR> _reports = [];

  List<DPR> get reports => _reports;

  void addReport(DPR report) {
    _reports.add(report);
    notifyListeners();
  }
}