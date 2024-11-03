import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/category_item.dart';
import '../providers/category_provider.dart';
import '../../../core/utils/design_utils.dart';
import './icon_picker_dialog.dart';
import './color_picker_dialog.dart';

class CategoriesScreen extends ConsumerStatefulWidget {
  final Function(CategoryItem)? onCategorySelected;

  const CategoriesScreen({
    super.key,
    this.onCategorySelected,
  });

  @override
  ConsumerState<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends ConsumerState<CategoriesScreen> {
  @override
  Widget build(BuildContext context) {
    final categoryState = ref.watch(categoryProvider);
    final categories = categoryState.categories;
    
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    
    final width = MediaQuery.of(context).size.width;
    final crossAxisCount = width > 600 ? 3 : 2;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Categories',
                style: textTheme.titleLarge,
              ),
              FilledButton.icon(
                onPressed: () {
                  _showAddCategoryDialog(context);
                },
                icon: const Icon(Icons.add),
                label: const Text('Add'),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (categoryState.isLoading)
            const Center(child: CircularProgressIndicator())
          else if (categoryState.error != null)
            Center(
              child: Text(
                categoryState.error!,
                style: TextStyle(color: colorScheme.error),
              ),
            )
          else
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1.0,
              ),
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final category = categories[index];
                return _buildCategoryCard(context, category);
              },
            ),
        ],
      ),
    );
  }

  Widget _buildCategoryCard(BuildContext context, CategoryItem category) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Card(
      elevation: 0,
      color: colorScheme.surfaceVariant,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          widget.onCategorySelected?.call(category);
        },
        onLongPress: () {
          _showCategoryOptions(context, category);
        },
        child: Stack(
          children: [
            Positioned(
              top: 4,
              right: 4,
              child: IconButton(
                icon: Icon(
                  Icons.more_vert,
                  color: colorScheme.onSurfaceVariant,
                  size: 20,
                ),
                onPressed: () {
                  _showCategoryOptions(context, category);
                },
              ),
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      category.icon,
                      size: 32,
                      color: category.color,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      category.name,
                      style: textTheme.titleMedium,
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${category.count} passwords',
                      style: textTheme.bodySmall?.copyWith(
                        color: colorScheme.outline,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showEditCategoryDialog(
      BuildContext context, CategoryItem category) async {
    final TextEditingController nameController =
        TextEditingController(text: category.name);
    IconData selectedIcon = category.icon;
    Color selectedColor = category.color;

    return showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Edit Category'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Category Name',
                  hintText: 'Enter category name',
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton.icon(
                    onPressed: () async {
                      final IconData? icon = await showDialog<IconData>(
                        context: context,
                        builder: (context) => const IconPickerDialog(),
                      );
                      if (icon != null) {
                        setState(() {
                          selectedIcon = icon;
                        });
                      }
                    },
                    icon: Icon(selectedIcon),
                    label: const Text('Choose Icon'),
                  ),
                  TextButton.icon(
                    onPressed: () async {
                      final Color? color = await showDialog<Color>(
                        context: context,
                        builder: (context) => const ColorPickerDialog(),
                      );
                      if (color != null) {
                        setState(() {
                          selectedColor = color;
                        });
                      }
                    },
                    icon: Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        color: selectedColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                    label: const Text('Choose Color'),
                  ),
                ],
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () async {
                if (nameController.text.trim().isNotEmpty) {
                  final updatedCategory = CategoryItem(
                    name: nameController.text.trim(),
                    icon: selectedIcon,
                    count: category.count,
                    color: selectedColor,
                  );
                  
                  await ref.read(categoryProvider.notifier)
                      .updateCategory(updatedCategory);
                  
                  if (mounted) {
                    Navigator.pop(context);
                  }
                }
              },
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }

  void _showCategoryOptions(BuildContext context, CategoryItem category) {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.edit),
              title: const Text('Edit Category'),
              onTap: () {
                Navigator.pop(context);
                _showEditCategoryDialog(context, category);
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete),
              title: const Text('Delete Category'),
              onTap: () {
                Navigator.pop(context);
                _showDeleteConfirmation(context, category);
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showDeleteConfirmation(
      BuildContext context, CategoryItem category) async {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Category'),
        content: Text(
            'Are you sure you want to delete "${category.name}"? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () async {
              await ref.read(categoryProvider.notifier)
                  .deleteCategory(category.name);
              if (mounted) {
                Navigator.pop(context);
              }
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  Future<void> _showAddCategoryDialog(BuildContext context) async {
    final TextEditingController nameController = TextEditingController();
    IconData selectedIcon = Icons.folder;
    Color selectedColor = Colors.blue;

    return showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Add Category'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Category Name',
                  hintText: 'Enter category name',
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton.icon(
                    onPressed: () async {
                      final IconData? icon = await showDialog<IconData>(
                        context: context,
                        builder: (context) => const IconPickerDialog(),
                      );
                      if (icon != null) {
                        setState(() {
                          selectedIcon = icon;
                        });
                      }
                    },
                    icon: Icon(selectedIcon),
                    label: const Text('Choose Icon'),
                  ),
                  TextButton.icon(
                    onPressed: () async {
                      final Color? color = await showDialog<Color>(
                        context: context,
                        builder: (context) => const ColorPickerDialog(),
                      );
                      if (color != null) {
                        setState(() {
                          selectedColor = color;
                        });
                      }
                    },
                    icon: Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        color: selectedColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                    label: const Text('Choose Color'),
                  ),
                ],
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () async {
                if (nameController.text.trim().isNotEmpty) {
                  final newCategory = CategoryItem(
                    name: nameController.text.trim(),
                    icon: selectedIcon,
                    count: 0,
                    color: selectedColor,
                  );
                  
                  await ref.read(categoryProvider.notifier)
                      .addCategory(newCategory);
                  
                  if (mounted) {
                    Navigator.pop(context);
                  }
                }
              },
              child: const Text('Add'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
} 