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

enum TemperatureUnit { celsius, fahrenheit, kelvin }

enum TemperatureSymbolStyle {
  symbol, // °C, °F, K
  unit, // celsius, fahrenheit, kelvin
}

class AppTemperature {
  final AppRegionCode _source;
  final AppRegionCode _target;

  AppTemperature({required AppRegionCode source, required AppRegionCode target}) : _source = source, _target = target;

  String format(double value, {int fractionDigits = 1, TemperatureSymbolStyle style = TemperatureSymbolStyle.symbol}) {
    final converted = _convertTemperature(value, _source.temperatureUnit, _target.temperatureUnit);
    final formatted = converted.toStringAsFixed(fractionDigits);
    final unit = style == TemperatureSymbolStyle.symbol ? _target.temperatureUnit.symbol : _target.temperatureUnit.name;

    return '$formatted $unit';
  }

  double _convertTemperature(double value, TemperatureUnit from, TemperatureUnit to) {
    if (from == to) return value;

    final celsius = switch (from) {
      TemperatureUnit.celsius => value,
      TemperatureUnit.fahrenheit => (value - 32) * 5 / 9,
      TemperatureUnit.kelvin => value - 273.15,
    };

    return switch (to) {
      TemperatureUnit.celsius => celsius,
      TemperatureUnit.fahrenheit => celsius * 9 / 5 + 32,
      TemperatureUnit.kelvin => celsius + 273.15,
    };
  }
}

extension AppRegionCodeTemperature on AppRegionCode {
  TemperatureUnit get temperatureUnit => switch (this) {
    AppRegionCode.us => TemperatureUnit.fahrenheit,
    AppRegionCode.uk => TemperatureUnit.celsius,
    AppRegionCode.fr => TemperatureUnit.celsius,
  };
}

extension TemperatureUnitExtension on TemperatureUnit {
  String get symbol => switch (this) {
    TemperatureUnit.celsius => '°C',
    TemperatureUnit.fahrenheit => '°F',
    TemperatureUnit.kelvin => 'K',
  };

  String get name => switch (this) {
    TemperatureUnit.celsius => 'Celsius',
    TemperatureUnit.fahrenheit => 'Fahrenheit',
    TemperatureUnit.kelvin => 'Kelvin',
  };
}
