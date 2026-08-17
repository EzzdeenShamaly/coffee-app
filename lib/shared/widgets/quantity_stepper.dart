import 'package:coffee_app/app/theme/app_spacing.dart';
import 'package:flutter/material.dart';

/// Decrement / value / increment control for a quantity.
///
/// Presentation only: it reports intent through [onChanged] and holds no state,
/// so the owning bloc stays the single source of truth for quantity.
class QuantityStepper extends StatelessWidget {
  const QuantityStepper({
    required this.quantity,
    required this.onChanged,
    this.min = 1,
    this.max = 20,
    this.itemLabel = 'item',
    super.key,
  });

  final int quantity;
  final ValueChanged<int> onChanged;
  final int min;
  final int max;

  /// Used to build screen-reader labels, e.g. "Increase latte quantity".
  final String itemLabel;

  @override
  Widget build(BuildContext context) {
    final canDecrement = quantity > min;
    final canIncrement = quantity < max;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _StepperButton(
          icon: Icons.remove_rounded,
          // Icon-only controls need an explicit label or a screen reader
          // announces only "button" (`/flutter-accessibility-audit`).
          semanticLabel: 'Decrease $itemLabel quantity',
          onPressed: canDecrement ? () => onChanged(quantity - 1) : null,
        ),
        SizedBox(
          width: AppSpacing.xl,
          child: Text(
            '$quantity',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
        _StepperButton(
          icon: Icons.add_rounded,
          semanticLabel: 'Increase $itemLabel quantity',
          onPressed: canIncrement ? () => onChanged(quantity + 1) : null,
        ),
      ],
    );
  }
}

class _StepperButton extends StatelessWidget {
  const _StepperButton({
    required this.icon,
    required this.semanticLabel,
    required this.onPressed,
  });

  final IconData icon;
  final String semanticLabel;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed,
      icon: Icon(icon),
      tooltip: semanticLabel,
      // Enforces the 48x48 accessibility floor even though the icon is smaller.
      constraints: const BoxConstraints(
        minWidth: AppSpacing.minTapTarget,
        minHeight: AppSpacing.minTapTarget,
      ),
      visualDensity: VisualDensity.compact,
      style: IconButton.styleFrom(
        side: BorderSide(color: Theme.of(context).colorScheme.outlineVariant),
      ),
    );
  }
}
