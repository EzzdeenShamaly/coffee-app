import 'package:flutter/material.dart';

/// The app's single in-progress indicator.
///
/// Every screen's in-progress state renders this, so a change to how loading
/// looks is one edit rather than one per screen.
class AppLoadingIndicator extends StatelessWidget {
  const AppLoadingIndicator({super.key, this.semanticLabel = 'Loading'});

  /// Announced by screen readers while the spinner is on screen.
  final String semanticLabel;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(semanticsLabel: semanticLabel),
    );
  }
}
