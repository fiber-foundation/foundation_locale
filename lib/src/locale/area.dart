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

import '../../extensions/region_code.dart';
import '../../fiber_foundation_locale.dart';

enum AreaUnit { squareMeter, squareKilometer, hectare, squareFoot, squareMile, acre }

enum AreaSymbolStyle {
  symbol, // m², km², ft², acre
  unit, // square meter, acre…
}

class AppArea {
  final AppRegionCode _source;
  final AppRegionCode _target;

  AppArea({required AppRegionCode source, required AppRegionCode target}) : _source = source, _target = target;

  String format(double value, {int fractionDigits = 2, AreaSymbolStyle style = AreaSymbolStyle.symbol}) {
    final sqm = _toSquareMeter(value, _source.areaUnit);
    final converted = _fromSquareMeter(sqm, _target.areaUnit);
    final formatted = converted.toStringAsFixed(fractionDigits);
    final unitLabel = style == AreaSymbolStyle.symbol
        ? _target.areaUnit.symbol
        : _AreaTranslations.getName(_target.areaUnit, _target.languageCode);

    return '$formatted $unitLabel';
  }

  double _toSquareMeter(double value, AreaUnit unit) {
    return switch (unit) {
      AreaUnit.squareMeter => value,
      AreaUnit.squareKilometer => value * 1e6,
      AreaUnit.hectare => value * 10000,
      AreaUnit.squareFoot => value * 0.092903,
      AreaUnit.squareMile => value * 2.59e6,
      AreaUnit.acre => value * 4046.8564224,
    };
  }

  double _fromSquareMeter(double sqm, AreaUnit unit) {
    return switch (unit) {
      AreaUnit.squareMeter => sqm,
      AreaUnit.squareKilometer => sqm / 1e6,
      AreaUnit.hectare => sqm / 10000,
      AreaUnit.squareFoot => sqm / 0.092903,
      AreaUnit.squareMile => sqm / 2.59e6,
      AreaUnit.acre => sqm / 4046.8564224,
    };
  }
}

extension AppRegionCodeArea on AppRegionCode {
  AreaUnit get areaUnit => switch (this) {
    AppRegionCode.us => AreaUnit.acre,
    AppRegionCode.uk => AreaUnit.squareMeter,
    AppRegionCode.fr => AreaUnit.squareMeter,
  };
}

extension AreaUnitExtension on AreaUnit {
  String get symbol => switch (this) {
    AreaUnit.squareMeter => 'm²',
    AreaUnit.squareKilometer => 'km²',
    AreaUnit.hectare => 'ha',
    AreaUnit.squareFoot => 'ft²',
    AreaUnit.squareMile => 'mi²',
    AreaUnit.acre => 'acre',
  };
}

class _AreaTranslations {
  static const Map<AreaUnit, Map<String, String>> names = {
    AreaUnit.squareMeter: {
      "ar": "متر مربع",
      "bg": "Квадратен метър",
      "ca": "Metre quadrat",
      "cs": "Čtvereční metr",
      "da": "Kvadratmeter",
      "de": "Quadratmeter",
      "el": "Τετραγωνικό μέτρο",
      "en": "Square meter",
      "es": "Metro cuadrado",
      "fi": "Neliömetri",
      "fr": "Mètre carré",
      "he": "מטר רבוע",
      "hi": "वर्ग मीटर",
      "hr": "Kvadratni metar",
      "hu": "Négyzetméter",
      "id": "Meter persegi",
      "it": "Metro quadrato",
      "ja": "平方メートル",
      "ko": "제곱미터",
      "lt": "Kvadratinis metras",
      "ms": "Meter persegi",
      "nb": "Kvadratmeter",
      "nl": "Vierkante meter",
      "pl": "Metr kwadratowy",
      "pt": "Metro quadrado",
      "ro": "Metru pătrat",
      "ru": "Квадратный метр",
      "sk": "Štvorcový meter",
      "sl": "Kvadratni meter",
      "sv": "Kvadratmeter",
      "th": "ตารางเมตร",
      "tr": "Metrekare",
      "uk": "Квадратний метр",
      "vi": "Mét vuông",
      "zh": "平方米",
    },

    AreaUnit.squareKilometer: {
      "ar": "كيلومتر مربع",
      "bg": "Квадратен километър",
      "ca": "Quilòmetre quadrat",
      "cs": "Čtvereční kilometr",
      "da": "Kvadratkilometer",
      "de": "Quadratkilometer",
      "el": "Τετραγωνικό χιλιόμετρο",
      "en": "Square kilometer",
      "es": "Kilómetro cuadrado",
      "fi": "Neliökilometri",
      "fr": "Kilomètre carré",
      "he": "קילומטר רבוע",
      "hi": "वर्ग किलोमीटर",
      "hr": "Kvadratni kilometar",
      "hu": "Négyzetkilométer",
      "id": "Kilometer persegi",
      "it": "Chilometro quadrato",
      "ja": "平方キロメートル",
      "ko": "제곱킬로미터",
      "lt": "Kvadratinis kilometras",
      "ms": "Kilometer persegi",
      "nb": "Kvadratkilometer",
      "nl": "Vierkante kilometer",
      "pl": "Kilometr kwadratowy",
      "pt": "Quilómetro quadrado",
      "ro": "Kilometru pătrat",
      "ru": "Квадратный километр",
      "sk": "Štvorcový kilometer",
      "sl": "Kvadratni kilometer",
      "sv": "Kvadratkilometer",
      "th": "ตารางกิโลเมตร",
      "tr": "Kilometrekare",
      "uk": "Квадратний кілометр",
      "vi": "Kilômét vuông",
      "zh": "平方公里",
    },

    AreaUnit.hectare: {
      "ar": "هكتار",
      "bg": "Хектар",
      "ca": "Hectàrea",
      "cs": "Hektar",
      "da": "Hektar",
      "de": "Hektar",
      "el": "Εκτάριο",
      "en": "Hectare",
      "es": "Hectárea",
      "fi": "Hehtaari",
      "fr": "Hectare",
      "he": "הקטר",
      "hi": "हेक्टेयर",
      "hr": "Hektar",
      "hu": "Hektár",
      "id": "Hektar",
      "it": "Ettaro",
      "ja": "ヘクタール",
      "ko": "헥타르",
      "lt": "Hektaras",
      "ms": "Hektar",
      "nb": "Hektar",
      "nl": "Hectare",
      "pl": "Hektar",
      "pt": "Hectare",
      "ro": "Hectar",
      "ru": "Гектар",
      "sk": "Hektár",
      "sl": "Hektar",
      "sv": "Hektar",
      "th": "เฮกตาร์",
      "tr": "Hektar",
      "uk": "Гектар",
      "vi": "Hecta",
      "zh": "公顷",
    },

    AreaUnit.squareFoot: {
      "ar": "قدم مربع",
      "bg": "Квадратен фут",
      "ca": "Peu quadrat",
      "cs": "Čtvereční stopa",
      "da": "Kvadratfod",
      "de": "Quadratfuß",
      "el": "Τετραγωνικό πόδι",
      "en": "Square foot",
      "es": "Pie cuadrado",
      "fi": "Neliöjalka",
      "fr": "Pied carré",
      "he": "רגל רבוע",
      "hi": "वर्ग फुट",
      "hr": "Kvadratna stopa",
      "hu": "Négyzetláb",
      "id": "Kaki persegi",
      "it": "Piede quadrato",
      "ja": "平方フィート",
      "ko": "제곱피트",
      "lt": "Kvadratinė pėda",
      "ms": "Kaki persegi",
      "nb": "Kvadratfot",
      "nl": "Vierkante voet",
      "pl": "Stopa kwadratowa",
      "pt": "Pé quadrado",
      "ro": "Picior pătrat",
      "ru": "Квадратный фут",
      "sk": "Štvorcová stopa",
      "sl": "Kvadratni čevelj",
      "sv": "Kvadratfot",
      "th": "ตารางฟุต",
      "tr": "Fit kare",
      "uk": "Квадратний фут",
      "vi": "Feet vuông",
      "zh": "平方英尺",
    },

    AreaUnit.squareMile: {
      "ar": "ميل مربع",
      "bg": "Квадратна миля",
      "ca": "Milla quadrada",
      "cs": "Čtvereční míle",
      "da": "Kvadratmile",
      "de": "Quadratmeile",
      "el": "Τετραγωνικό μίλι",
      "en": "Square mile",
      "es": "Milla cuadrada",
      "fi": "Neliömaili",
      "fr": "Mille carré",
      "he": "מייל רבוע",
      "hi": "वर्ग मील",
      "hr": "Kvadratna milja",
      "hu": "Négyzetmérföld",
      "id": "Mil persegi",
      "it": "Miglio quadrato",
      "ja": "平方マイル",
      "ko": "제곱마일",
      "lt": "Kvadratinė mylia",
      "ms": "Batu persegi",
      "nb": "Kvadratmile",
      "nl": "Vierkante mijl",
      "pl": "Mila kwadratowa",
      "pt": "Milha quadrada",
      "ro": "Milă pătrată",
      "ru": "Квадратная миля",
      "sk": "Štvorcová míľa",
      "sl": "Kvadratna milja",
      "sv": "Kvadratmil",
      "th": "ตารางไมล์",
      "tr": "Mil kare",
      "uk": "Квадратна миля",
      "vi": "Dặm vuông",
      "zh": "平方英里",
    },

    AreaUnit.acre: {
      "ar": "فدان",
      "bg": "Акър",
      "ca": "Acre",
      "cs": "Akr",
      "da": "Acre",
      "de": "Acre",
      "el": "Έικρ",
      "en": "Acre",
      "es": "Acre",
      "fi": "Eekkeri",
      "fr": "Acre",
      "he": "אקר",
      "hi": "एकड़",
      "hr": "Akr",
      "hu": "Acre",
      "id": "Acre",
      "it": "Acri",
      "ja": "エーカー",
      "ko": "에이커",
      "lt": "Akrų",
      "ms": "Acre",
      "nb": "Acre",
      "nl": "Acre",
      "pl": "Akr",
      "pt": "Acre",
      "ro": "Acru",
      "ru": "Акр",
      "sk": "Aker",
      "sl": "Aker",
      "sv": "Acre",
      "th": "เอเคอร์",
      "tr": "Acre",
      "uk": "Акр",
      "vi": "Mẫu Anh",
      "zh": "英亩",
    },
  };

  static String getName(AreaUnit unit, String languageCode) =>
      names[unit]?[languageCode] ?? names[unit]?['en'] ?? unit.name;
}
