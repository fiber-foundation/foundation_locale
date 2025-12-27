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

class FoundationTime {
  final int hour;
  final int minute;
  final int? second;

  FoundationTime({required this.hour, required this.minute, this.second})
    : assert(hour >= 0 && hour < 24, 'hour must be between 0 and 23'),
      assert(minute >= 0 && minute < 60, 'minute must be between 0 and 59'),
      assert(second == null || (second >= 0 && second < 60), 'second must be between 0 and 59');
}

class AppTime {
  // ignore: unused_field
  final AppRegionCode _source;
  final AppRegionCode _target;

  AppTime({required AppRegionCode source, required AppRegionCode target}) : _source = source, _target = target;

  String format(FoundationTime time) {
    final now = DateTime.now();
    final dateTime = DateTime(now.year, now.month, now.day, time.hour, time.minute, time.second ?? 0);
    final bool hasSeconds = time.second != null;
    final pattern = _uses12HourFormat ? (hasSeconds ? 'hh:mm:ss a' : 'hh:mm a') : (hasSeconds ? 'HH:mm:ss' : 'HH:mm');

    return DateFormat(pattern, _target.localeTag).format(dateTime);
  }

  bool get _uses12HourFormat {
    final pattern = DateFormat.jm(_target.localeTag).pattern;
    return pattern?.contains('a') ?? false;
  }
}
