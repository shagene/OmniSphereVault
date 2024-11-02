class AppSettings {
  final bool isDarkMode;
  final bool useBiometrics;
  final int autoLockTimeout;
  final int clipboardTimeout;

  AppSettings({
    this.isDarkMode = false,
    this.useBiometrics = false,
    this.autoLockTimeout = 1,
    this.clipboardTimeout = 30,
  });
} 