import 'package:json_annotation/json_annotation.dart';

/// How the customer pays.
///
/// No card numbers or tokens appear anywhere in this app — a real integration
/// hands off to the platform payment sheet (Apple Pay / Google Pay) or a PCI-
/// compliant SDK, and the app only ever sees an opaque result
/// (`03-flutter-security-guard.mdc`).
enum PaymentMethod {
  @JsonValue('apple_pay')
  applePay,
  @JsonValue('google_pay')
  googlePay,
  @JsonValue('card_on_file')
  cardOnFile,
  @JsonValue('pay_at_counter')
  payAtCounter;

  String get label => switch (this) {
    PaymentMethod.applePay => 'Apple Pay',
    PaymentMethod.googlePay => 'Google Pay',
    PaymentMethod.cardOnFile => 'Saved card',
    PaymentMethod.payAtCounter => 'Pay at counter',
  };
}

/// When the customer wants the order ready.
enum PickupOption {
  @JsonValue('asap')
  asap,
  @JsonValue('in_15')
  inFifteenMinutes,
  @JsonValue('in_30')
  inThirtyMinutes;

  String get label => switch (this) {
    PickupOption.asap => 'As soon as possible',
    PickupOption.inFifteenMinutes => 'In 15 minutes',
    PickupOption.inThirtyMinutes => 'In 30 minutes',
  };
}
