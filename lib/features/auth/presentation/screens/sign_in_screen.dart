import 'package:coffee_app/app/router/app_routes.dart';
import 'package:coffee_app/app/theme/app_spacing.dart';
import 'package:coffee_app/features/auth/application/auth_bloc.dart';
import 'package:coffee_app/features/auth/application/auth_event.dart';
import 'package:coffee_app/features/auth/application/auth_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

/// Email + password sign-in.
///
/// Stateful only because it owns `TextEditingController`s and the
/// obscure-password toggle — genuinely ephemeral widget state, which is exactly
/// what `setState` is for (`02-flutter-state-guard.mdc`). The credentials
/// themselves go to `AuthBloc`; nothing about the session lives here.
class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    context.read<AuthBloc>().add(
      AuthSignInRequested(
        email: _emailController.text,
        password: _passwordController.text,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        // Failures surface as a snackbar from a listener. The router handles
        // navigating away on success, so this screen never pushes a route
        // itself.
        child: BlocListener<AuthBloc, AuthState>(
          listenWhen: (previous, current) => current is AuthFailure,
          listener: (context, state) {
            if (state is! AuthFailure) return;
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          },
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Icon(
                      Icons.coffee_rounded,
                      size: 64,
                      color: theme.colorScheme.primary,
                      semanticLabel: 'Coffee app',
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    Text(
                      'Welcome back',
                      textAlign: TextAlign.center,
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xl),

                    TextFormField(
                      controller: _emailController,
                      decoration: const InputDecoration(labelText: 'Email'),
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      autofillHints: const [AutofillHints.email],
                      validator: (value) {
                        final text = value?.trim() ?? '';
                        if (text.isEmpty) return 'Enter your email.';
                        if (!text.contains('@')) return 'Enter a valid email.';
                        return null;
                      },
                    ),
                    const SizedBox(height: AppSpacing.md),

                    TextFormField(
                      controller: _passwordController,
                      obscureText: _obscurePassword,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        suffixIcon: IconButton(
                          onPressed: () => setState(
                            () => _obscurePassword = !_obscurePassword,
                          ),
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                          ),
                          tooltip: _obscurePassword
                              ? 'Show password'
                              : 'Hide password',
                        ),
                      ),
                      textInputAction: TextInputAction.done,
                      autofillHints: const [AutofillHints.password],
                      onFieldSubmitted: (_) => _submit(),
                      validator: (value) => (value ?? '').isEmpty
                          ? 'Enter your password.'
                          : null,
                    ),
                    const SizedBox(height: AppSpacing.lg),

                    BlocBuilder<AuthBloc, AuthState>(
                      builder: (context, state) {
                        final busy = state is AuthInProgress;
                        return FilledButton(
                          onPressed: busy ? null : _submit,
                          child: busy
                              ? const SizedBox.square(
                                  dimension: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    semanticsLabel: 'Signing in',
                                  ),
                                )
                              : const Text('Sign in'),
                        );
                      },
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    TextButton(
                      onPressed: () => context.goNamed(AppRoutes.signUp),
                      child: const Text('Create an account'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
