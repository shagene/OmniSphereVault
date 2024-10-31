import 'package:flutter/material.dart';
import 'widgets/icon_picker_dialog.dart';
import 'widgets/color_picker_dialog.dart';
import 'utils/design_utils.dart';

class CategoriesScreen extends StatefulWidget {
  final Function(CategoryItem)? onCategorySelected;

  const CategoriesScreen({
    super.key,
    this.onCategorySelected,
  });

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  // Temporary data - will be replaced with actual database data
  final List<CategoryItem> _categories = [
    CategoryItem(
      name: 'Social Media',
      icon: Icons.social_distance,
      count: 5,
      color: Colors.blue,
    ),
    CategoryItem(
      name: 'Banking',
      icon: Icons.account_balance,
      count: 3,
      color: Colors.green,
    ),
    CategoryItem(
      name: 'Email',
      icon: Icons.email,
      count: 2,
      color: Colors.red,
    ),
    CategoryItem(
      name: 'Work',
      icon: Icons.work,
      count: 4,
      color: Colors.orange,
    ),
    CategoryItem(
      name: 'Shopping',
      icon: Icons.shopping_bag,
      count: 6,
      color: Colors.purple,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

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
                label: const Text('Add Category'),
              ),
            ],
          ),
          const SizedBox(height: 16),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 1.5,
            ),
            itemCount: _categories.length,
            itemBuilder: (context, index) {
              final category = _categories[index];
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
            Padding(
              padding: const EdgeInsets.all(16),
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
            Positioned(
              top: 4,
              right: 4,
              child: IconButton(
                icon: Icon(
                  Icons.more_vert,
                  color: colorScheme.onSurfaceVariant,
                ),
                onPressed: () {
                  _showCategoryOptions(context, category);
                },
              ),
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
            onPressed: () {
              setState(() {
                _categories.removeWhere((item) => item.name == category.name);
              });
              Navigator.pop(context);
            },
            child: const Text('Delete'),
          ),
        ],
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
              onPressed: () {
                if (nameController.text.trim().isNotEmpty) {
                  setState(() {
                    final index = _categories
                        .indexWhere((item) => item.name == category.name);
                    if (index != -1) {
                      _categories[index] = CategoryItem(
                        name: nameController.text.trim(),
                        icon: selectedIcon,
                        count: category.count,
                        color: selectedColor,
                      );
                    }
                  });
                  Navigator.pop(context);
                }
              },
              child: const Text('Save'),
            ),
          ],
        ),
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
              onPressed: () {
                if (nameController.text.trim().isNotEmpty) {
                  // TODO: Save category to database
                  setState(() {
                    _categories.add(
                      CategoryItem(
                        name: nameController.text.trim(),
                        icon: selectedIcon,
                        count: 0,
                        color: selectedColor,
                      ),
                    );
                  });
                  Navigator.pop(context);
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

class CategoryItem {
  final String name;
  final IconData icon;
  final int count;
  final Color color;

  CategoryItem({
    required this.name,
    required this.icon,
    required this.count,
    required this.color,
  });
} 