import 'package:freezed_annotation/freezed_annotation.dart';

part 'password_entry.freezed.dart';
part 'password_entry.g.dart';

@freezed
class PasswordEntry with _$PasswordEntry {
  const factory PasswordEntry({
    required String title,
    required String password,
    String? username,
    String? email,
    String? url,
    String? notes,
    required DateTime lastModified,
    @Default('General') String category,
    @Default([]) List<String> tags,
    required DateTime lastUsed,
    required DateTime passwordLastChanged,
    @Default(false) bool isFavorite,
    @Default(false) bool hasCustomExpirationSettings,
    @Default(false) bool neverExpires,
  }) = _PasswordEntry;

  factory PasswordEntry.fromJson(Map<String, dynamic> json) =>
      _$PasswordEntryFromJson(json);
}

extension PasswordEntryExtension on PasswordEntry {
  bool shouldNotifyExpiration(int defaultDays, int warningDays) {
    if (neverExpires) return false;
    return getDaysUntilExpiration(defaultDays) <= warningDays;
  }

  bool isPasswordExpired(int defaultDays) {
    if (neverExpires) return false;
    return getDaysUntilExpiration(defaultDays) <= 0;
  }

  int getDaysUntilExpiration(int defaultDays) {
    return passwordLastChanged
        .add(Duration(days: defaultDays))
        .difference(DateTime.now())
        .inDays;
  }

  int get daysSincePasswordChange {
    return DateTime.now().difference(passwordLastChanged).inDays;
  }
} 