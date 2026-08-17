import 'package:coffee_app/app/theme/app_spacing.dart';
import 'package:flutter/material.dart';

/// Failure state with a retry affordance.
///
/// [message] comes straight from a bloc's failure state and is already
/// display-ready — this widget never formats an exception
/// (`02-flutter-state-guard.mdc`).
class AppErrorView extends StatelessWidget {
  const AppErrorView({required this.message, this.onRetry, super.key});

  final String message;

  /// When null, no retry button renders — for failures the user cannot resolve
  /// by trying again.
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.cloud_off_rounded,
              size: 48,
              color: theme.colorScheme.error,
              semanticLabel: 'Error',
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              message,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyLarge,
            ),
            if (onRetry != null) ...[
              const SizedBox(height: AppSpacing.lg),
              OutlinedButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh_rounded),
                label: const Text('Try again'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
