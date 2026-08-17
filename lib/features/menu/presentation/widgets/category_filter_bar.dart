import 'package:coffee_app/app/theme/app_spacing.dart';
import 'package:coffee_app/features/menu/domain/entities/drink_category.dart';
import 'package:flutter/material.dart';

/// Horizontal category chips, with an "All" chip that clears the filter.
///
/// Stateless: the selected category lives in `MenuState`, so the bar always
/// reflects the bloc rather than holding its own copy
/// (`02-flutter-state-guard.mdc`).
class CategoryFilterBar extends StatelessWidget {
  const CategoryFilterBar({
    required this.categories,
    required this.selected,
    required this.onSelected,
    super.key,
  });

  final List<DrinkCategory> categories;

  /// Null means "All".
  final DrinkCategory? selected;

  final ValueChanged<DrinkCategory?> onSelected;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: AppSpacing.xxl,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
        children: [
          _Chip(
            label: 'All',
            isSelected: selected == null,
            onSelected: () => onSelected(null),
          ),
          for (final category in categories)
            _Chip(
              label: category.label,
              isSelected: selected == category,
              onSelected: () => onSelected(category),
            ),
        ],
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip({
    required this.label,
    required this.isSelected,
    required this.onSelected,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onSelected;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: AppSpacing.sm),
      child: ChoiceChip(
        label: Text(label),
        selected: isSelected,
        // ChoiceChip already announces its selected state to screen readers.
        onSelected: (_) => onSelected(),
      ),
    );
  }
}
