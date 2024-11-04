import '../../../core/models/base_state.dart';
import './theme_settings.dart';

class SettingsState {
  final bool isDarkMode;
  final bool useBiometrics;
  final int autoLockTimeout;
  final int clipboardTimeout;
  final int defaultPasswordExpirationDays;
  final bool defaultNotifyOnExpiration;
  final int expirationWarningDays;
  final int masterPasswordExpirationDays;
  final bool masterPasswordNotifyOnExpiration;
  final bool requireMasterPasswordChange;
  final bool backupEnabled;
  final int backupFrequency;
  final int maxBackupCount;
  final String securityLevel;
  final Map<String, dynamic> passwordGenerationDefaults;

  const SettingsState({
    this.isDarkMode = false,
    this.useBiometrics = false,
    this.autoLockTimeout = 1,
    this.clipboardTimeout = 30,
    this.defaultPasswordExpirationDays = 90,
    this.defaultNotifyOnExpiration = true,
    this.expirationWarningDays = 14,
    this.masterPasswordExpirationDays = 180,
    this.masterPasswordNotifyOnExpiration = true,
    this.requireMasterPasswordChange = true,
    this.backupEnabled = true,
    this.backupFrequency = 7,
    this.maxBackupCount = 5,
    this.securityLevel = 'high',
    this.passwordGenerationDefaults = const {},
  });

  SettingsState copyWith({
    bool? isDarkMode,
    bool? useBiometrics,
    int? autoLockTimeout,
    int? clipboardTimeout,
    int? defaultPasswordExpirationDays,
    bool? defaultNotifyOnExpiration,
    int? expirationWarningDays,
    int? masterPasswordExpirationDays,
    bool? masterPasswordNotifyOnExpiration,
    bool? requireMasterPasswordChange,
    bool? backupEnabled,
    int? backupFrequency,
    int? maxBackupCount,
    String? securityLevel,
    Map<String, dynamic>? passwordGenerationDefaults,
  }) {
    return SettingsState(
      isDarkMode: isDarkMode ?? this.isDarkMode,
      useBiometrics: useBiometrics ?? this.useBiometrics,
      autoLockTimeout: autoLockTimeout ?? this.autoLockTimeout,
      clipboardTimeout: clipboardTimeout ?? this.clipboardTimeout,
      defaultPasswordExpirationDays: defaultPasswordExpirationDays ?? this.defaultPasswordExpirationDays,
      defaultNotifyOnExpiration: defaultNotifyOnExpiration ?? this.defaultNotifyOnExpiration,
      expirationWarningDays: expirationWarningDays ?? this.expirationWarningDays,
      masterPasswordExpirationDays: masterPasswordExpirationDays ?? this.masterPasswordExpirationDays,
      masterPasswordNotifyOnExpiration: masterPasswordNotifyOnExpiration ?? this.masterPasswordNotifyOnExpiration,
      requireMasterPasswordChange: requireMasterPasswordChange ?? this.requireMasterPasswordChange,
      backupEnabled: backupEnabled ?? this.backupEnabled,
      backupFrequency: backupFrequency ?? this.backupFrequency,
      maxBackupCount: maxBackupCount ?? this.maxBackupCount,
      securityLevel: securityLevel ?? this.securityLevel,
      passwordGenerationDefaults: passwordGenerationDefaults ?? this.passwordGenerationDefaults,
    );
  }

  Map<String, dynamic> toJson() => {
    'isDarkMode': isDarkMode,
    'useBiometrics': useBiometrics,
    'autoLockTimeout': autoLockTimeout,
    'clipboardTimeout': clipboardTimeout,
    'defaultPasswordExpirationDays': defaultPasswordExpirationDays,
    'defaultNotifyOnExpiration': defaultNotifyOnExpiration,
    'expirationWarningDays': expirationWarningDays,
    'masterPasswordExpirationDays': masterPasswordExpirationDays,
    'masterPasswordNotifyOnExpiration': masterPasswordNotifyOnExpiration,
    'requireMasterPasswordChange': requireMasterPasswordChange,
    'backupEnabled': backupEnabled,
    'backupFrequency': backupFrequency,
    'maxBackupCount': maxBackupCount,
    'securityLevel': securityLevel,
    'passwordGenerationDefaults': passwordGenerationDefaults,
  };

  factory SettingsState.fromJson(Map<String, dynamic> json) => SettingsState(
    isDarkMode: json['isDarkMode'] as bool? ?? false,
    useBiometrics: json['useBiometrics'] as bool? ?? false,
    autoLockTimeout: json['autoLockTimeout'] as int? ?? 1,
    clipboardTimeout: json['clipboardTimeout'] as int? ?? 30,
    defaultPasswordExpirationDays: json['defaultPasswordExpirationDays'] as int? ?? 90,
    defaultNotifyOnExpiration: json['defaultNotifyOnExpiration'] as bool? ?? true,
    expirationWarningDays: json['expirationWarningDays'] as int? ?? 14,
    masterPasswordExpirationDays: json['masterPasswordExpirationDays'] as int? ?? 180,
    masterPasswordNotifyOnExpiration: json['masterPasswordNotifyOnExpiration'] as bool? ?? true,
    requireMasterPasswordChange: json['requireMasterPasswordChange'] as bool? ?? true,
    backupEnabled: json['backupEnabled'] as bool? ?? true,
    backupFrequency: json['backupFrequency'] as int? ?? 7,
    maxBackupCount: json['maxBackupCount'] as int? ?? 5,
    securityLevel: json['securityLevel'] as String? ?? 'high',
    passwordGenerationDefaults: Map<String, dynamic>.from(
      json['passwordGenerationDefaults'] as Map? ?? {},
    ),
  );
} 