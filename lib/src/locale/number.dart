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

import 'package:intl/intl.dart';

import '../../extensions/region_code.dart';
import '../../fiber_foundation_locale.dart';

enum NumberSeparatorStyle {
  locale, // 1,234.56 / 1 234,56
  compact, // 1K / 1M
}

enum NumberSignStyle {
  auto, // -1
  always, // +1 / -1
  none, // 1
}

class AppNumber {
  // ignore: unused_field
  final AppRegionCode _source;
  final AppRegionCode _target;

  AppNumber({required AppRegionCode source, required AppRegionCode target}) : _source = source, _target = target;

  String format(
    num value, {
    int? fractionDigits,
    NumberSeparatorStyle separator = NumberSeparatorStyle.locale,
    NumberSignStyle sign = NumberSignStyle.auto,
  }) {
    final NumberFormat format = separator == NumberSeparatorStyle.compact
        ? NumberFormat.compact(locale: _target.localeTag)
        : NumberFormat.decimalPattern(_target.localeTag);

    if (fractionDigits != null) {
      format.minimumFractionDigits = fractionDigits;
      format.maximumFractionDigits = fractionDigits;
    }

    var result = format.format(value);

    if (sign == NumberSignStyle.always && value > 0) {
      result = '+$result';
    } else if (sign == NumberSignStyle.none) {
      result = result.replaceAll('-', '');
    }

    return result;
  }

  String percent(num value, {int fractionDigits = 0}) {
    final format = NumberFormat.percentPattern(_target.localeTag)
      ..minimumFractionDigits = fractionDigits
      ..maximumFractionDigits = fractionDigits;

    return format.format(value);
  }
}
