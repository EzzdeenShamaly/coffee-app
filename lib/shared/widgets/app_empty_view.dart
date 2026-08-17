import 'package:coffee_app/app/theme/app_spacing.dart';
import 'package:flutter/material.dart';

/// Success-but-nothing-to-show state.
///
/// Distinct from [AppErrorView] on purpose: an empty cart is not a failure, and
/// showing an error for one trains users to distrust real errors.
class AppEmptyView extends StatelessWidget {
  const AppEmptyView({
    required this.message,
    this.icon = Icons.local_cafe_outlined,
    this.actionLabel,
    this.onAction,
    super.key,
  });

  final String message;
  final IconData icon;

  /// Both [actionLabel] and [onAction] must be set for the button to render.
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hasAction = actionLabel != null && onAction != null;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 56,
              color: theme.colorScheme.onSurfaceVariant,
              semanticLabel: 'Nothing here',
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              message,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            if (hasAction) ...[
              const SizedBox(height: AppSpacing.lg),
              FilledButton(onPressed: onAction, child: Text(actionLabel!)),
            ],
          ],
        ),
      ),
    );
  }
}
