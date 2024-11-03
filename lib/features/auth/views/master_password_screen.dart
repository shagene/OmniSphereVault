import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/auth_provider.dart';
import '../../password_management/views/password_vault_screen.dart';

class MasterPasswordScreen extends ConsumerStatefulWidget {
  const MasterPasswordScreen({super.key});

  @override
  ConsumerState<MasterPasswordScreen> createState() => _MasterPasswordScreenState();
}

class _MasterPasswordScreenState extends ConsumerState<MasterPasswordScreen> {
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void initState() {
    super.initState();
    _checkBiometrics();
  }

  Future<void> _checkBiometrics() async {
    await ref.read(authProvider.notifier).checkBiometricAvailability();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    // Handle authentication state changes
    ref.listen(authProvider, (previous, next) {
      if (next.isAuthenticated) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const PasswordVaultScreen()),
        );
      }
    });

    return Scaffold(
      body: Container(
        color: colorScheme.background,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.lock,
                  size: 64,
                ),
                const SizedBox(height: 32),
                Text(
                  'Welcome Back',
                  style: textTheme.displayLarge,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  'Enter your master password to unlock',
                  style: textTheme.bodyLarge?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                TextField(
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  decoration: InputDecoration(
                    labelText: 'Master Password',
                    hintText: 'Enter your master password',
                    errorText: authState.error,
                    prefixIcon: const Icon(Icons.lock_outline),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword ? Icons.visibility : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                    ),
                    border: const OutlineInputBorder(),
                  ),
                  onSubmitted: (value) {
                    ref.read(authProvider.notifier).authenticate(value);
                  },
                ),
                const SizedBox(height: 24),
                FilledButton(
                  onPressed: authState.isLoading
                      ? null
                      : () {
                          ref.read(authProvider.notifier)
                              .authenticate(_passwordController.text);
                        },
                  child: authState.isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Text('Unlock'),
                ),
                if (authState.isBiometricAvailable) ...[
                  const SizedBox(height: 16),
                  TextButton.icon(
                    onPressed: authState.isLoading
                        ? null
                        : () {
                            ref.read(authProvider.notifier)
                                .authenticateWithBiometrics();
                          },
                    icon: const Icon(Icons.fingerprint),
                    label: const Text('Use Biometric Authentication'),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }
}