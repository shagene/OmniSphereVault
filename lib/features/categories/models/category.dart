import 'package:flutter/material.dart';

class Category {
  final String id;
  final String name;
  final IconData icon;
  final Color color;
  final int count;

  Category({
    required this.id,
    required this.name,
    required this.icon,
    required this.color,
    this.count = 0,
  });
} 