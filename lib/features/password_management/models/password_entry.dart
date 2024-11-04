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
  final DateTime passwordLastChanged;
  final bool isFavorite;
  final List<PasswordEntryHistory> history;
  
  // Custom expiration settings per password
  final bool hasCustomExpirationSettings;  // New field
  final int? passwordExpirationDays;       // Made nullable
  final bool notifyOnExpiration;
  final bool neverExpires;                 // New field

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
    DateTime? passwordLastChanged,
    this.isFavorite = false,
    this.history = const [],
    // Custom expiration settings
    this.hasCustomExpirationSettings = false,
    this.passwordExpirationDays,  // Will use default from settings if null
    this.notifyOnExpiration = true,
    this.neverExpires = false,    // If true, ignores expiration days
  }) : passwordLastChanged = passwordLastChanged ?? DateTime.now();

  bool isPasswordExpired(int defaultExpirationDays) {
    if (neverExpires) return false;
    final expirationDays = passwordExpirationDays ?? defaultExpirationDays;
    final daysUntilExpiration = daysSincePasswordChange;
    return daysUntilExpiration >= expirationDays;
  }

  int get daysSincePasswordChange {
    return DateTime.now().difference(passwordLastChanged).inDays;
  }

  int getDaysUntilExpiration(int defaultExpirationDays) {
    if (neverExpires) return -1;  // Never expires
    final expirationDays = passwordExpirationDays ?? defaultExpirationDays;
    return expirationDays - daysSincePasswordChange;
  }

  bool shouldNotifyExpiration(int defaultExpirationDays, int warningDays) {
    if (neverExpires || !notifyOnExpiration) return false;
    final daysLeft = getDaysUntilExpiration(defaultExpirationDays);
    return daysLeft <= warningDays;
  }

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
    bool? hasCustomExpirationSettings,
    int? passwordExpirationDays,
    bool? notifyOnExpiration,
    bool? neverExpires,
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
      hasCustomExpirationSettings: hasCustomExpirationSettings ?? this.hasCustomExpirationSettings,
      passwordExpirationDays: passwordExpirationDays ?? this.passwordExpirationDays,
      notifyOnExpiration: notifyOnExpiration ?? this.notifyOnExpiration,
      neverExpires: neverExpires ?? this.neverExpires,
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

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'username': username,
      'email': email,
      'password': password,
      'url': url,
      'notes': notes,
      'lastModified': lastModified.toIso8601String(),
      'category': category,
      'tags': tags,
      'lastUsed': lastUsed?.toIso8601String(),
      'passwordLastChanged': passwordLastChanged.toIso8601String(),
      'isFavorite': isFavorite,
      'hasCustomExpirationSettings': hasCustomExpirationSettings,
      'passwordExpirationDays': passwordExpirationDays,
      'notifyOnExpiration': notifyOnExpiration,
      'neverExpires': neverExpires,
    };
  }

  factory PasswordEntry.fromJson(Map<String, dynamic> json) {
    return PasswordEntry(
      title: json['title'] as String,
      username: json['username'] as String?,
      email: json['email'] as String?,
      password: json['password'] as String,
      url: json['url'] as String?,
      notes: json['notes'] as String?,
      lastModified: DateTime.parse(json['lastModified'] as String),
      category: json['category'] as String,
      tags: List<String>.from(json['tags'] as List),
      lastUsed: json['lastUsed'] != null 
          ? DateTime.parse(json['lastUsed'] as String) 
          : null,
      passwordLastChanged: DateTime.parse(json['passwordLastChanged'] as String),
      isFavorite: json['isFavorite'] as bool,
      hasCustomExpirationSettings: json['hasCustomExpirationSettings'] as bool? ?? false,
      passwordExpirationDays: json['passwordExpirationDays'] as int?,
      notifyOnExpiration: json['notifyOnExpiration'] as bool? ?? true,
      neverExpires: json['neverExpires'] as bool? ?? false,
    );
  }
} 