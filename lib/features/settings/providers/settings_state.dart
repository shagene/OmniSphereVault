import '../../../core/models/base_state.dart';

class SettingsState extends BaseState {
  final bool isDarkMode;
  final bool useBiometrics;
  final int autoLockTimeout;
  final int clipboardTimeout;
  
  // Individual Password Settings
  final int defaultPasswordExpirationDays;
  final bool defaultNotifyOnExpiration;
  final int expirationWarningDays;
  
  // Master Password Settings
  final int masterPasswordExpirationDays;
  final bool masterPasswordNotifyOnExpiration;
  final bool requireMasterPasswordChange;

  const SettingsState({
    super.status = StateStatus.initial,
    super.errorMessage,
    super.isLoading = false,
    this.isDarkMode = false,
    this.useBiometrics = false,
    this.autoLockTimeout = 1,
    this.clipboardTimeout = 30,
    // Individual Password Defaults
    this.defaultPasswordExpirationDays = 90,
    this.defaultNotifyOnExpiration = true,
    this.expirationWarningDays = 14,
    // Master Password Settings
    this.masterPasswordExpirationDays = 180,  // 6 months
    this.masterPasswordNotifyOnExpiration = true,
    this.requireMasterPasswordChange = true,
  });

  @override
  SettingsState copyWith({
    StateStatus? status,
    String? errorMessage,
    bool? isLoading,
    bool? isDarkMode,
    bool? useBiometrics,
    int? autoLockTimeout,
    int? clipboardTimeout,
    // Individual Password Settings
    int? defaultPasswordExpirationDays,
    bool? defaultNotifyOnExpiration,
    int? expirationWarningDays,
    // Master Password Settings
    int? masterPasswordExpirationDays,
    bool? masterPasswordNotifyOnExpiration,
    bool? requireMasterPasswordChange,
  }) {
    return SettingsState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      isLoading: isLoading ?? this.isLoading,
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
  );
} 