class MasterPassword {
  final String hash;
  final DateTime lastChanged;
  final bool requiresBiometric;

  MasterPassword({
    required this.hash,
    required this.lastChanged,
    this.requiresBiometric = false,
  });
} 