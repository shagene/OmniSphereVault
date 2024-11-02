import 'package:flutter/material.dart';

class PasswordEntryDetailScreen extends StatefulWidget {
  const PasswordEntryDetailScreen({super.key});

  @override
  State<PasswordEntryDetailScreen> createState() => _PasswordEntryDetailScreenState();
}

class _PasswordEntryDetailScreenState extends State<PasswordEntryDetailScreen> {
  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Password Entry'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              // Implement edit functionality
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              // Implement delete functionality
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailItem(context, 'Title', 'Google'),
            _buildDetailItem(context, 'Username', 'john.doe@gmail.com'),
            _buildPasswordItem(context, 'Password', '********'),
            _buildDetailItem(context, 'Website', 'https://www.google.com'),
            _buildDetailItem(context, 'Category', 'Web'),
            _buildDetailItem(context, 'Tags', 'email, work'),
            _buildDetailItem(context, 'Last Modified', '01/05/2023'),
            const SizedBox(height: 24),
            Text(
              'Password Strength',
              style: textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            LinearProgressIndicator(
              value: 0.8,
              backgroundColor: colorScheme.surfaceVariant,
              valueColor: AlwaysStoppedAnimation<Color>(colorScheme.primary),
            ),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: () {
                // Implement password history view
              },
              child: const Text('View Password History'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailItem(BuildContext context, String label, String value) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: textTheme.bodySmall?.copyWith(
              color: colorScheme.outline,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: textTheme.bodyLarge,
          ),
        ],
      ),
    );
  }

  Widget _buildPasswordItem(BuildContext context, String label, String value) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: textTheme.bodySmall?.copyWith(
              color: colorScheme.outline,
            ),
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Expanded(
                child: Text(
                  _obscurePassword ? '********' : value,
                  style: textTheme.bodyLarge,
                ),
              ),
              IconButton(
                icon: Icon(
                  _obscurePassword ? Icons.visibility : Icons.visibility_off,
                  color: colorScheme.primary,
                ),
                onPressed: () {
                  setState(() {
                    _obscurePassword = !_obscurePassword;
                  });
                },
              ),
              IconButton(
                icon: Icon(
                  Icons.copy,
                  color: colorScheme.primary,
                ),
                onPressed: () {
                  // Implement copy functionality
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}