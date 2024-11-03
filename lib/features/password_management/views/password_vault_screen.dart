import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/password_entry.dart';
import '../providers/password_list_provider.dart';
import '../../../core/widgets/bottom_nav.dart';
import './password_generator_screen.dart';
import '../../../features/settings/views/settings_screen.dart';
import '../../../features/categories/views/categories_screen.dart';
import '../../../core/widgets/search_bar_widget.dart';
import '../../../core/utils/keyboard_shortcuts.dart';
import '../../../core/utils/clipboard_manager.dart';
import '../../../features/categories/models/category_item.dart';

class PasswordVaultScreen extends ConsumerStatefulWidget {
  const PasswordVaultScreen({super.key});

  @override
  ConsumerState<PasswordVaultScreen> createState() => _PasswordVaultScreenState();
}

class _PasswordVaultScreenState extends ConsumerState<PasswordVaultScreen> {
  int _currentIndex = 0;
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final FocusNode _searchFocusNode = FocusNode();
  final Map<String, bool> _passwordVisibility = {};
  final _clipboardManager = ClipboardManager();

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      ref.read(passwordListProvider.notifier).setSearchQuery(_searchController.text);
    });
  }

  @override
  Widget build(BuildContext context) {
    final passwordState = ref.watch(passwordListProvider);
    final filteredPasswords = ref.read(passwordListProvider.notifier).filteredEntries;

    return CallbackShortcuts(
      bindings: {
        const SingleActivator(LogicalKeyboardKey.keyS, control: true): () {
          _focusSearchBar();
        },
        const SingleActivator(LogicalKeyboardKey.keyN, control: true): () {
          // TODO: Add new password
        },
        const SingleActivator(LogicalKeyboardKey.keyG, control: true): () {
          setState(() => _currentIndex = 2);
        },
        const SingleActivator(LogicalKeyboardKey.keyC, control: true): () {
          setState(() => _currentIndex = 1);
        },
        const SingleActivator(LogicalKeyboardKey.escape): () {
          _clearFilters();
        },
      },
      child: Focus(
        focusNode: _focusNode,
        autofocus: true,
        child: Scaffold(
          appBar: AppBar(
            title: const Text('OmniSphereVault'),
          ),
          drawer: _buildDrawer(context),
          body: _buildBody(),
          bottomNavigationBar: BottomNavigation(
            currentIndex: _currentIndex,
            onTap: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
          ),
          floatingActionButton: _currentIndex == 0
              ? FloatingActionButton(
                  child: const Icon(Icons.add),
                  onPressed: () async {
                    final PasswordEntry? newEntry = await Navigator.push<PasswordEntry>(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const PasswordGeneratorScreen(),
                      ),
                    );
                    
                    if (newEntry != null && mounted) {
                      ref.read(passwordListProvider.notifier).addPassword(newEntry);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Password entry saved successfully'),
                          duration: Duration(seconds: 2),
                        ),
                      );
                    }
                  },
                )
              : null,
        ),
      ),
    );
  }

  Widget _buildBody() {
    final passwordState = ref.watch(passwordListProvider);
    
    switch (_currentIndex) {
      case 0:
        return Column(
          children: [
            _buildSearchBar(),
            if (passwordState.selectedCategory != null)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Chip(
                  label: Text(passwordState.selectedCategory!),
                  onDeleted: () {
                    ref.read(passwordListProvider.notifier).setSelectedCategory(null);
                  },
                ),
              ),
            Expanded(
              child: _buildPasswordList(context),
            ),
          ],
        );
      case 1:
        return CategoriesScreen(
          onCategorySelected: (category) {
            ref.read(passwordListProvider.notifier).setSelectedCategory(category.name);
            setState(() {
              _currentIndex = 0; // Switch back to password list
            });
          },
        );
      case 2:
        return const PasswordGeneratorScreen();
      case 3:
        return const SettingsScreen();
      default:
        return _buildPasswordList(context);
    }
  }

  Widget _buildDrawer(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: colorScheme.primaryContainer,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.security,
                      size: 32,
                      color: colorScheme.primary,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'OmniSphereVault',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  'Secure Password Manager',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            leading: Icon(Icons.settings, color: colorScheme.primary),
            title: const Text('Settings'),
            onTap: () {
              // Navigate to settings screen
            },
          ),
          ListTile(
            leading: Icon(Icons.info, color: colorScheme.primary),
            title: const Text('About'),
            onTap: () {
              // Show about dialog
            },
          ),
        ],
      ),
    );
  }

  Widget _buildPasswordList(BuildContext context) {
    final passwordState = ref.watch(passwordListProvider);
    final filteredPasswords = ref.read(passwordListProvider.notifier).filteredEntries;

    if (filteredPasswords.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off,
              size: 64,
              color: Theme.of(context).colorScheme.outline,
            ),
            const SizedBox(height: 16),
            Text(
              'No passwords found',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              'Try adjusting your search or category filter',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.only(
        left: 16,
        right: 16,
        top: 16,
        bottom: 88,
      ),
      itemCount: filteredPasswords.length,
      itemBuilder: (context, index) {
        final password = filteredPasswords[index];
        return _buildPasswordCard(context, password);
      },
    );
  }

  Widget _buildPasswordCard(BuildContext context, PasswordEntry entry) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    // Initialize visibility state for this entry if not exists
    _passwordVisibility.putIfAbsent(entry.title, () => false);

    return Card(
      elevation: 0,
      color: colorScheme.surfaceVariant,
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            contentPadding: const EdgeInsets.all(16),
            title: Row(
              children: [
                Expanded(
                  child: Text(
                    entry.title,
                    style: textTheme.titleMedium,
                  ),
                ),
                if (entry.isFavorite)
                  Icon(
                    Icons.star,
                    color: colorScheme.primary,
                    size: 20,
                  ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    entry.category,
                    style: textTheme.bodySmall?.copyWith(
                      color: colorScheme.onPrimaryContainer,
                    ),
                  ),
                ),
              ],
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (entry.url != null) ...[
                  const SizedBox(height: 16),
                  _buildDetailRow(
                    context,
                    Icons.link,
                    entry.url!,
                    'URL',
                    showOpen: true,
                  ),
                ],
                if (entry.username != null) ...[
                  const SizedBox(height: 8),
                  _buildDetailRow(
                    context,
                    Icons.person_outline,
                    entry.username!,
                    'Username',
                  ),
                ],
                if (entry.email != null) ...[
                  const SizedBox(height: 8),
                  _buildDetailRow(
                    context,
                    Icons.email_outlined,
                    entry.email!,
                    'Email',
                  ),
                ],
                // Password section with visibility toggle and copy button
                _buildPasswordRow(context, entry),
                if (entry.notes != null && entry.notes!.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Icon(Icons.note_outlined, 
                           size: 16, 
                           color: colorScheme.onSurfaceVariant),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          entry.notes!,
                          style: textTheme.bodySmall,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.access_time, 
                         size: 16, 
                         color: colorScheme.onSurfaceVariant),
                    const SizedBox(width: 8),
                    Text(
                      'Modified: ${entry.lastModified.day}/${entry.lastModified.month}/${entry.lastModified.year}',
                      style: textTheme.bodySmall?.copyWith(
                        color: colorScheme.outline,
                      ),
                    ),
                  ],
                ),
                if (entry.tags.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: entry.tags.map((tag) => Chip(
                      label: Text(
                        tag,
                        style: textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSecondaryContainer,
                        ),
                      ),
                      backgroundColor: colorScheme.secondaryContainer,
                      padding: EdgeInsets.zero,
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    )).toList(),
                  ),
                ],
              ],
            ),
          ),
          ButtonBar(
            alignment: MainAxisAlignment.end,
            children: [
              IconButton(
                icon: Icon(Icons.edit, color: colorScheme.primary),
                onPressed: () async {
                  final updatedEntry = await Navigator.push<PasswordEntry>(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PasswordGeneratorScreen(
                        entryToEdit: entry,
                      ),
                    ),
                  );
                  
                  if (updatedEntry != null && mounted) {
                    await ref.read(passwordListProvider.notifier)
                        .updatePassword(updatedEntry);
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Password entry updated successfully'),
                          duration: Duration(seconds: 2),
                        ),
                      );
                    }
                  }
                },
                tooltip: 'Edit entry',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SearchBarWidget(
        controller: _searchController,
        focusNode: _searchFocusNode,
        onChanged: (query) {
          ref.read(passwordListProvider.notifier).setSearchQuery(query);
        },
        onClear: () {
          ref.read(passwordListProvider.notifier).setSearchQuery('');
        },
        hintText: 'Search passwords...',
      ),
    );
  }

  void _focusSearchBar() {
    _searchController.selection = TextSelection(
      baseOffset: 0,
      extentOffset: _searchController.text.length,
    );
    FocusScope.of(context).requestFocus(_searchFocusNode);
  }

  void _clearFilters() {
    _searchController.clear();
    ref.read(passwordListProvider.notifier).setSearchQuery('');
    ref.read(passwordListProvider.notifier).setSelectedCategory(null);
  }

  Widget _buildDetailRow(
    BuildContext context,
    IconData icon,
    String value,
    String label, {
    bool showOpen = false,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return InkWell(
      onTap: () => _copyToClipboard(value, label),
      child: Row(
        children: [
          Icon(icon, size: 16, color: colorScheme.onSurfaceVariant),
          const SizedBox(width: 8),
          Expanded(
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
                  style: textTheme.bodyMedium,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(Icons.copy,
                size: 20,
                color: colorScheme.primary),
            onPressed: () => _copyToClipboard(value, label),
            tooltip: 'Copy $label',
          ),
          if (showOpen)
            IconButton(
              icon: Icon(Icons.open_in_new,
                  size: 20,
                  color: colorScheme.primary),
              onPressed: () {
                // TODO: Implement URL launch
              },
              tooltip: 'Open URL',
            ),
        ],
      ),
    );
  }

  Widget _buildPasswordRow(BuildContext context, PasswordEntry entry) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return InkWell(
      onTap: () => _copyToClipboard(entry.password, 'Password'),
      child: Row(
        children: [
          Icon(Icons.password,
              size: 16,
              color: colorScheme.onSurfaceVariant),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Password',
                  style: textTheme.bodySmall?.copyWith(
                    color: colorScheme.outline,
                  ),
                ),
                const SizedBox(height: 4),
                AnimatedCrossFade(
                  firstChild: Text(
                    '••••••••',
                    style: textTheme.bodyMedium,
                  ),
                  secondChild: Text(
                    entry.password,
                    style: textTheme.bodyMedium,
                  ),
                  crossFadeState: _passwordVisibility[entry.title] ?? false
                      ? CrossFadeState.showSecond
                      : CrossFadeState.showFirst,
                  duration: const Duration(milliseconds: 200),
                ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(
              (_passwordVisibility[entry.title] ?? false)
                  ? Icons.visibility_off
                  : Icons.visibility,
              size: 20,
              color: colorScheme.primary,
            ),
            onPressed: () {
              setState(() {
                _passwordVisibility[entry.title] = !(_passwordVisibility[entry.title] ?? false);
              });
              // Auto-hide password after 30 seconds
              if (_passwordVisibility[entry.title] ?? false) {
                Future.delayed(const Duration(seconds: 30), () {
                  if (mounted) {
                    setState(() {
                      _passwordVisibility[entry.title] = false;
                    });
                  }
                });
              }
            },
            tooltip: 'Show/hide password',
          ),
          IconButton(
            icon: Icon(Icons.copy,
                size: 20,
                color: colorScheme.primary),
            onPressed: () => _copyToClipboard(entry.password, 'Password'),
            tooltip: 'Copy password',
          ),
        ],
      ),
    );
  }

  Future<void> _copyToClipboard(String data, String type) async {
    final success = await _clipboardManager.copyToClipboard(
      data,
      type,
      timeout: const Duration(seconds: 30),
    );

    if (mounted) {
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('$type copied to clipboard'),
            duration: const Duration(seconds: 2),
            action: SnackBarAction(
              label: 'Clear',
              onPressed: () {
                _clipboardManager.clearClipboard();
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Clipboard cleared'),
                      duration: Duration(seconds: 1),
                    ),
                  );
                }
              },
            ),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to copy $type'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    _clipboardManager.dispose();
    _searchFocusNode.dispose();
    _focusNode.dispose();
    _searchController.dispose();
    super.dispose();
  }
}