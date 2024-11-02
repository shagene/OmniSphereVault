class PasswordEntryHistory {
  final DateTime timestamp;
  final Map<String, dynamic> changes;
  final String reason;

  PasswordEntryHistory({
    required this.timestamp,
    required this.changes,
    this.reason = '',
  });
} 