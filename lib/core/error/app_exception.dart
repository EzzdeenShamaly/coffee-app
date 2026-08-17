/// The app's single typed failure hierarchy.
///
/// Every repository maps transport- and storage-level errors onto one of these
/// before they cross into the application layer, so blocs catch `AppException`
/// and never a raw `SocketException`, `PlatformException`, or `FormatException`
/// (`01-flutter-architecture-guard.mdc`, `flutter-repository-gen` Step 2).
///
/// `message` is display-ready: a bloc puts it straight onto a failure state and
/// the widget renders it without formatting. Never put a stack trace, a URL, or
/// a token in here.
sealed class AppException implements Exception {
  const AppException(this.message);

  /// Human-readable, safe to show in the UI.
  final String message;

  @override
  String toString() => '$runtimeType: $message';
}

/// The device could not reach the backend at all.
final class NetworkException extends AppException {
  const NetworkException([super.message = 'No internet connection.']);
}

/// The backend was reached but the resource does not exist.
final class NotFoundException extends AppException {
  const NotFoundException([super.message = 'That item could not be found.']);
}

/// Credentials are missing, expired, or rejected.
final class UnauthorizedException extends AppException {
  const UnauthorizedException([super.message = 'Please sign in again.']);
}

/// The request was well-formed but the input is not acceptable.
///
/// Used for domain rule violations too (an unavailable drink, an empty cart at
/// checkout), which is why the message is always caller-supplied.
final class ValidationException extends AppException {
  const ValidationException(super.message);
}

/// Anything not covered above. Keep this rare — a broad catch that maps
/// everything here loses the information the UI needs to react usefully.
final class UnexpectedException extends AppException {
  const UnexpectedException([super.message = 'Something went wrong.']);
}
