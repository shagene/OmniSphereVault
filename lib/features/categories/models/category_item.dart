import 'package:flutter/material.dart';

class CategoryItem {
  final String name;
  final IconData icon;
  final int count;
  final Color color;

  const CategoryItem({
    required this.name,
    required this.icon,
    required this.count,
    required this.color,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'icon': icon.codePoint,
      'count': count,
      'color': color.value,
    };
  }

  factory CategoryItem.fromJson(Map<String, dynamic> json) {
    return CategoryItem(
      name: json['name'] as String,
      icon: IconData(json['icon'] as int, fontFamily: 'MaterialIcons'),
      count: json['count'] as int,
      color: Color(json['color'] as int),
    );
  }
} 