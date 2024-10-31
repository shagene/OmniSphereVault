import 'package:flutter/material.dart';
import '../utils/design_utils.dart';

class IconPickerDialog extends StatelessWidget {
  const IconPickerDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return AlertDialog(
      title: const Text('Choose Icon'),
      content: SizedBox(
        width: double.maxFinite,
        child: GridView.builder(
          shrinkWrap: true,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
            childAspectRatio: 1,
          ),
          itemCount: DesignUtils.commonIcons.length,
          itemBuilder: (context, index) {
            final icon = DesignUtils.commonIcons[index];
            return IconButton(
              onPressed: () {
                Navigator.of(context).pop(icon);
              },
              icon: Icon(
                icon,
                size: 32,
                color: colorScheme.primary,
              ),
            );
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
      ],
    );
  }
} 