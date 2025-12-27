// Copyright (C) 2025 Fiber
//
// All rights reserved. This script, including its code and logic, is the
// exclusive property of Fiber. Redistribution, reproduction,
// or modification of any part of this script is strictly prohibited
// without prior written permission from Fiber.
//
// Conditions of use:
// - The code may not be copied, duplicated, or used, in whole or in part,
//   for any purpose without explicit authorization.
// - Redistribution of this code, with or without modification, is not
//   permitted unless expressly agreed upon by Fiber.
// - The name "Fiber" and any associated branding, logos, or
//   trademarks may not be used to endorse or promote derived products
//   or services without prior written approval.
//
// Disclaimer:
// THIS SCRIPT AND ITS CODE ARE PROVIDED "AS IS" WITHOUT WARRANTY OF ANY KIND,
// EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE, OR NON-INFRINGEMENT. IN NO EVENT SHALL
// FIBER BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
// EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING BUT NOT LIMITED TO LOSS OF USE,
// DATA, PROFITS, OR BUSINESS INTERRUPTION) ARISING OUT OF OR RELATED TO THE USE
// OR INABILITY TO USE THIS SCRIPT, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//
// Unauthorized copying or reproduction of this script, in whole or in part,
// is a violation of applicable intellectual property laws and will result
// in legal action.

import '../../fiber_foundation_locale.dart';

enum PhoneCountry { fr, us, uk }

class AppPhone {
  // ignore: unused_field
  final AppRegionCode _source;
  final AppRegionCode _target;

  AppPhone({required AppRegionCode source, required AppRegionCode target}) : _source = source, _target = target;

  String get countryCode => _PhoneMetadata.countryCode(_target.phone);

  bool isValid(String input) {
    final digits = _sanitize(input);
    return _PhoneMetadata.isValid(_target.phone, digits);
  }

  String format(String input) {
    final digits = _sanitize(input);

    if (!_PhoneMetadata.isValid(_target.phone, digits)) return input;
    return _PhoneMetadata.format(_target.phone, digits);
  }

  RegExp get validationRegex => _PhoneMetadata.validationRegex(_target);

  RegExp get formatRegex => _PhoneMetadata.formatRegex(_target);

  String _sanitize(String input) => input.replaceAll(RegExp(r'[^\d+]'), '');
}

class _PhoneMetadata {
  static String countryCode(PhoneCountry country) => switch (country) {
    PhoneCountry.fr => '+33',
    PhoneCountry.us => '+1',
    PhoneCountry.uk => '+44',
  };

  static RegExp validationRegex(AppRegionCode region) => switch (region) {
    AppRegionCode.fr => RegExp(r'^(?:\+33|0)[1-9]\d{8}$'),
    AppRegionCode.us => RegExp(r'^(?:\+1)?\d{10}$'),
    AppRegionCode.uk => RegExp(r'^(?:\+44|0)7\d{9}$'),
  };

  static RegExp formatRegex(AppRegionCode region) => switch (region) {
    AppRegionCode.fr => RegExp(r'^(?:\+33\s?|0)[1-9](?:\s?\d{2}){4}$'),
    AppRegionCode.us => RegExp(r'^(?:\+1\s?)?\(?\d{3}\)?[\s.-]?\d{3}[\s.-]?\d{4}$'),
    AppRegionCode.uk => RegExp(r'^(?:\+44\s?|0)7\d{3}\s?\d{6}$'),
  };

  static bool isValid(PhoneCountry country, String digits) {
    switch (country) {
      case PhoneCountry.fr:
        return RegExp(r'^(?:\+33|0)[1-9]\d{8}$').hasMatch(digits);

      case PhoneCountry.us:
        return RegExp(r'^(?:\+1)?\d{10}$').hasMatch(digits);

      case PhoneCountry.uk:
        return RegExp(r'^(?:\+44|0)7\d{9}$').hasMatch(digits);
    }
  }

  static String format(PhoneCountry country, String digits) {
    switch (country) {
      case PhoneCountry.fr:
        final d = digits.startsWith('+33')
            ? digits.substring(3)
            : digits.startsWith('0')
            ? digits.substring(1)
            : digits;

        return '+33 ${d.substring(0, 1)} ${d.substring(1, 3)} ${d.substring(3, 5)} ${d.substring(5, 7)} ${d.substring(7)}';

      case PhoneCountry.us:
        final d = digits.startsWith('+1') ? digits.substring(2) : digits;
        return '+1 (${d.substring(0, 3)}) ${d.substring(3, 6)}-${d.substring(6)}';

      case PhoneCountry.uk:
        final d = digits.startsWith('+44')
            ? digits.substring(3)
            : digits.startsWith('0')
            ? digits.substring(1)
            : digits;

        return '+44 ${d.substring(0, 4)} ${d.substring(4)}';
    }
  }
}

extension AppRegionCodePhoneExtension on AppRegionCode {
  PhoneCountry get phone => switch (this) {
    AppRegionCode.fr => PhoneCountry.fr,
    AppRegionCode.us => PhoneCountry.us,
    AppRegionCode.uk => PhoneCountry.uk,
  };
}
