import 'package:flutter/material.dart';

class Subject {
  final String id;
  String name;
  Color color;
  IconData icon;
  double targetMastery;

  Subject({
    required this.id,
    required this.name,
    required this.color,
    required this.icon,
    this.targetMastery = 0.90,
  });
}
