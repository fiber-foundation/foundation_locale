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

library;

import 'package:timeago/timeago.dart' as timeago;

import './src/locale/area.dart';
import './src/locale/calendar.dart';
import './src/locale/currency.dart';
import './src/locale/date.dart';
import './src/locale/measurement.dart';
import './src/locale/number.dart';
import './src/locale/phone.dart';
import './src/locale/temperature.dart';
import './src/locale/time.dart';
import './src/locale/volume.dart';
import './src/locale/week.dart';
import './src/locale/weight.dart';
import 'di/di.dart';
import 'extensions/region_code.dart';

export 'src/locale/area.dart';
export 'src/locale/calendar.dart';
export 'src/locale/currency.dart';
export 'src/locale/date.dart';
export 'src/locale/measurement.dart';
export 'src/locale/number.dart';
export 'src/locale/phone.dart';
export 'src/locale/temperature.dart';
export 'src/locale/time.dart';
export 'src/locale/volume.dart';
export 'src/locale/week.dart';
export 'src/locale/weight.dart';

enum AppRegionCode { fr, us, uk }

class AppLocale {
  AppLocale._();

  static final AppLocale _instance = AppLocale._();

  static AppRegionCode? _sourceRegion;
  static AppRegionCode? _targetRegion;

  static bool get isInitialized => _sourceRegion != null && _targetRegion != null;

  static Future<void> initialize({required AppRegionCode source, required AppRegionCode target}) async {
    if (isInitialized) return;

    await configureFoundationLocaleServices();
    timeago.setLocaleMessages(target.languageCode, foundationTimeago[target.languageCode]);
    _sourceRegion = source;
    _targetRegion = target;
  }

  static void setSource(AppRegionCode source) => _sourceRegion = source;

  static void setTarget(AppRegionCode target) {
    timeago.setLocaleMessages(target.languageCode, foundationTimeago[target.languageCode]);
    _targetRegion = target;
  }

  static void _assertInitialized() {
    assert(isInitialized, 'AppLocale.initialize() must be called before accessing AppLocale.*');
  }

  static AppRegionCode get source {
    _assertInitialized();
    return _sourceRegion!;
  }

  static AppRegionCode get target {
    _assertInitialized();
    return _targetRegion!;
  }

  static AppNumber get number {
    _assertInitialized();
    return _instance._number;
  }

  static AppDate get date {
    _assertInitialized();
    return _instance._date;
  }

  static AppTemperature get temperature {
    _assertInitialized();
    return _instance._temperature;
  }

  static AppMeasurement get measurement {
    _assertInitialized();
    return _instance._measurement;
  }

  static AppCalendar get calendar {
    _assertInitialized();
    return _instance._calendar;
  }

  static AppTime get time {
    _assertInitialized();
    return _instance._time;
  }

  static AppCurrency get currency {
    _assertInitialized();
    return _instance._currency;
  }

  static AppWeight get weight {
    _assertInitialized();
    return _instance._weight;
  }

  static AppArea get area {
    _assertInitialized();
    return _instance._area;
  }

  static AppVolume get volume {
    _assertInitialized();
    return _instance._volume;
  }

  static AppPhone get phone {
    _assertInitialized();
    return _instance._phone;
  }

  static AppWeek get week {
    _assertInitialized();
    return _instance._week;
  }

  final AppNumber _number = AppNumber(source: source, target: target);
  final AppDate _date = AppDate(source: source, target: target);
  final AppTemperature _temperature = AppTemperature(source: source, target: target);
  final AppMeasurement _measurement = AppMeasurement(source: source, target: target);
  final AppCalendar _calendar = AppCalendar(source: source, target: target);
  final AppTime _time = AppTime(source: source, target: target);
  final AppCurrency _currency = AppCurrency(source: source, target: target);
  final AppWeight _weight = AppWeight(source: source, target: target);
  final AppArea _area = AppArea(source: source, target: target);
  final AppVolume _volume = AppVolume(source: source, target: target);
  final AppPhone _phone = AppPhone(source: source, target: target);
  final AppWeek _week = AppWeek(source: source, target: target);
}
