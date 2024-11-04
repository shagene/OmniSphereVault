import 'package:flutter/foundation.dart';

class AuditLogEntry {
  final String id;
  final DateTime timestamp;
  final String action;
  final Map<String, dynamic> details;
  final String? userId;
  final String? ipAddress;

  const AuditLogEntry({
    required this.id,
    required this.timestamp,
    required this.action,
    required this.details,
    this.userId,
    this.ipAddress,
  });

  AuditLogEntry copyWith({
    String? id,
    DateTime? timestamp,
    String? action,
    Map<String, dynamic>? details,
    String? userId,
    String? ipAddress,
  }) {
    return AuditLogEntry(
      id: id ?? this.id,
      timestamp: timestamp ?? this.timestamp,
      action: action ?? this.action,
      details: details ?? this.details,
      userId: userId ?? this.userId,
      ipAddress: ipAddress ?? this.ipAddress,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'timestamp': timestamp.toIso8601String(),
    'action': action,
    'details': details,
    'userId': userId,
    'ipAddress': ipAddress,
  };

  factory AuditLogEntry.fromJson(Map<String, dynamic> json) => AuditLogEntry(
    id: json['id'] as String,
    timestamp: DateTime.parse(json['timestamp'] as String),
    action: json['action'] as String,
    details: Map<String, dynamic>.from(json['details'] as Map),
    userId: json['userId'] as String?,
    ipAddress: json['ipAddress'] as String?,
  );
} 