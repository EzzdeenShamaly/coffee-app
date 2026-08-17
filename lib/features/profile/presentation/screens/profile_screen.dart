import 'package:coffee_app/app/theme/app_spacing.dart';
import 'package:coffee_app/features/auth/application/auth_bloc.dart';
import 'package:coffee_app/features/auth/application/auth_event.dart';
import 'package:coffee_app/features/profile/application/profile_bloc.dart';
import 'package:coffee_app/features/profile/application/profile_event.dart';
import 'package:coffee_app/features/profile/application/profile_state.dart';
import 'package:coffee_app/features/profile/domain/entities/user_profile.dart';
import 'package:coffee_app/shared/widgets/app_error_view.dart';
import 'package:coffee_app/shared/widgets/app_loading_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Account details, loyalty progress, and sign-out.
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: BlocBuilder<ProfileBloc, ProfileState>(
        builder: (context, state) {
          return switch (state) {
            ProfileInitial() ||
            ProfileLoadInProgress() => const AppLoadingIndicator(),
            ProfileLoadFailure(:final message) => AppErrorView(
              message: message,
              onRetry: () =>
                  context.read<ProfileBloc>().add(const ProfileRequested()),
            ),
            ProfileLoadSuccess(:final profile) => _ProfileDetails(
              profile: profile,
            ),
          };
        },
      ),
    );
  }
}

class _ProfileDetails extends StatelessWidget {
  const _ProfileDetails({required this.profile});

  final UserProfile profile;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListView(
      padding: const EdgeInsets.all(AppSpacing.md),
      children: [
        Row(
          children: [
            CircleAvatar(
              radius: 28,
              backgroundColor: theme.colorScheme.primaryContainer,
              child: Text(
                profile.user.initial,
                style: theme.textTheme.titleLarge?.copyWith(
                  color: theme.colorScheme.onPrimaryContainer,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    profile.user.fullName,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    profile.user.email,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.lg),
        _LoyaltyCard(profile: profile),
        const SizedBox(height: AppSpacing.lg),
        OutlinedButton.icon(
          onPressed: () =>
              context.read<AuthBloc>().add(const AuthSignOutRequested()),
          icon: const Icon(Icons.logout_rounded),
          label: const Text('Sign out'),
        ),
      ],
    );
  }
}

class _LoyaltyCard extends StatelessWidget {
  const _LoyaltyCard({required this.profile});

  final UserProfile profile;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Loyalty',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              '${profile.loyaltyPoints} points',
              style: theme.textTheme.headlineSmall,
            ),
            const SizedBox(height: AppSpacing.sm),
            // All three numbers are derived on UserProfile, so this widget only
            // lays them out (`01-flutter-architecture-guard.mdc`).
            LinearProgressIndicator(
              value: profile.rewardProgress,
              semanticsLabel: 'Progress to next free drink',
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              profile.availableRewards > 0
                  ? '${profile.availableRewards} free drink(s) ready to redeem'
                  : '${profile.pointsToNextReward} points to your next free drink',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
