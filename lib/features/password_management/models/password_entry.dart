import 'password_entry_history.dart';

class PasswordEntry {
  final String title;
  final String? username;
  final String? email;
  final String password;
  final String? url;
  final String? notes;
  final DateTime lastModified;
  final String category;
  final List<String> tags;
  final DateTime? lastUsed;
  final DateTime? passwordLastChanged;
  final bool isFavorite;
  final List<PasswordEntryHistory> history;

  PasswordEntry({
    required this.title,
    this.username,
    this.email,
    required this.password,
    this.url,
    this.notes,
    required this.lastModified,
    required this.category,
    this.tags = const [],
    this.lastUsed,
    this.passwordLastChanged,
    this.isFavorite = false,
    this.history = const [],
  });

  PasswordEntry copyWith({
    String? title,
    String? username,
    String? email,
    String? password,
    String? url,
    String? notes,
    DateTime? lastModified,
    String? category,
    List<String>? tags,
    DateTime? lastUsed,
    DateTime? passwordLastChanged,
    bool? isFavorite,
    List<PasswordEntryHistory>? history,
    String? reason,
  }) {
    final Map<String, dynamic> changes = {};
    
    if (title != null && title != this.title) {
      changes['title'] = {'from': this.title, 'to': title};
    }
    if (username != this.username) {
      changes['username'] = {'from': this.username, 'to': username};
    }
    if (email != this.email) {
      changes['email'] = {'from': this.email, 'to': email};
    }
    if (password != null && password != this.password) {
      changes['password'] = {'from': '********', 'to': '********'};
    }
    if (url != this.url) {
      changes['url'] = {'from': this.url, 'to': url};
    }
    if (notes != this.notes) {
      changes['notes'] = {'from': this.notes, 'to': notes};
    }
    if (category != null && category != this.category) {
      changes['category'] = {'from': this.category, 'to': category};
    }
    if (tags != null && tags != this.tags) {
      changes['tags'] = {'from': this.tags, 'to': tags};
    }
    if (isFavorite != null && isFavorite != this.isFavorite) {
      changes['isFavorite'] = {'from': this.isFavorite, 'to': isFavorite};
    }

    final List<PasswordEntryHistory> updatedHistory = [...this.history];
    if (changes.isNotEmpty) {
      updatedHistory.add(PasswordEntryHistory(
        timestamp: DateTime.now(),
        changes: changes,
        reason: reason ?? '',
      ));
    }

    return PasswordEntry(
      title: title ?? this.title,
      username: username ?? this.username,
      email: email ?? this.email,
      password: password ?? this.password,
      url: url ?? this.url,
      notes: notes ?? this.notes,
      lastModified: DateTime.now(),
      category: category ?? this.category,
      tags: tags ?? this.tags,
      lastUsed: lastUsed ?? this.lastUsed,
      passwordLastChanged: password != null ? DateTime.now() : this.passwordLastChanged,
      isFavorite: isFavorite ?? this.isFavorite,
      history: updatedHistory,
    );
  }

  String getFormattedHistory() {
    if (history.isEmpty) return 'No history available';

    final StringBuffer buffer = StringBuffer();
    for (final entry in history.reversed) {
      buffer.writeln('Changed on ${_formatDate(entry.timestamp)}:');
      if (entry.reason.isNotEmpty) {
        buffer.writeln('Reason: ${entry.reason}');
      }
      
      for (final change in entry.changes.entries) {
        final from = change.value['from'];
        final to = change.value['to'];
        
        if (change.key == 'password') {
          buffer.writeln('- Password was changed');
        } else {
          buffer.writeln('- ${_capitalizeField(change.key)}: '
              '${from ?? 'none'} → ${to ?? 'none'}');
        }
      }
      buffer.writeln('');
    }
    return buffer.toString();
  }

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-'
           '${date.day.toString().padLeft(2, '0')} '
           '${date.hour.toString().padLeft(2, '0')}:'
           '${date.minute.toString().padLeft(2, '0')}';
  }

  String _capitalizeField(String field) {
    return field[0].toUpperCase() + field.substring(1);
  }
} 