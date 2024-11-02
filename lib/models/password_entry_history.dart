class PasswordEntryHistory {
  final DateTime timestamp;
  final Map<String, dynamic> changes;
  final String reason; // Optional reason for the change

  PasswordEntryHistory({
    required this.timestamp,
    required this.changes,
    this.reason = '',
  });
} 