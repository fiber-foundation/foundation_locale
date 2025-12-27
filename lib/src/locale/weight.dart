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

enum WeightUnit { kilogram, gram, tonne, pound, ounce }

enum WeightSymbolStyle {
  symbol, // kg, g, lb
  unit, // kilogram, pound
}

class AppWeight {
  final AppRegionCode _source;
  final AppRegionCode _target;

  AppWeight({required AppRegionCode source, required AppRegionCode target}) : _source = source, _target = target;

  String format(double value, {int fractionDigits = 2, WeightSymbolStyle style = WeightSymbolStyle.symbol}) {
    final kg = _toKilogram(value, _source.weightUnit);
    final converted = _fromKilogram(kg, _target.weightUnit);
    final formatted = converted.toStringAsFixed(fractionDigits);

    final unitLabel = style == WeightSymbolStyle.symbol
        ? _target.weightUnit.symbol
        : _WeightTranslations.getName(_target.weightUnit, _target.languageCode);

    return '$formatted $unitLabel';
  }

  double _toKilogram(double value, WeightUnit unit) {
    return switch (unit) {
      WeightUnit.kilogram => value,
      WeightUnit.gram => value / 1000,
      WeightUnit.tonne => value * 1000,
      WeightUnit.pound => value * 0.45359237,
      WeightUnit.ounce => value * 0.0283495231,
    };
  }

  double _fromKilogram(double kg, WeightUnit unit) {
    return switch (unit) {
      WeightUnit.kilogram => kg,
      WeightUnit.gram => kg * 1000,
      WeightUnit.tonne => kg / 1000,
      WeightUnit.pound => kg / 0.45359237,
      WeightUnit.ounce => kg / 0.0283495231,
    };
  }
}

extension AppRegionCodeWeight on AppRegionCode {
  WeightUnit get weightUnit => switch (this) {
    AppRegionCode.us => WeightUnit.pound,
    AppRegionCode.uk => WeightUnit.kilogram,
    AppRegionCode.fr => WeightUnit.kilogram,
  };
}

extension WeightUnitExtension on WeightUnit {
  String get symbol => switch (this) {
    WeightUnit.kilogram => 'kg',
    WeightUnit.gram => 'g',
    WeightUnit.tonne => 't',
    WeightUnit.pound => 'lb',
    WeightUnit.ounce => 'oz',
  };
}

class _WeightTranslations {
  static const Map<WeightUnit, Map<String, String>> names = {
    WeightUnit.kilogram: {
      "ar": "كيلوغرام",
      "bg": "Килограм",
      "ca": "Quilogram",
      "cs": "Kilogram",
      "da": "Kilogram",
      "de": "Kilogramm",
      "el": "Κιλογραμμάριο",
      "en": "Kilogram",
      "es": "Kilogramo",
      "fi": "Kilogramma",
      "fr": "Kilogramme",
      "he": "קילוגרם",
      "hi": "किलोग्राम",
      "hr": "Kilogram",
      "hu": "Kilogramm",
      "id": "Kilogram",
      "it": "Chilogrammo",
      "ja": "キログラム",
      "ko": "킬로그램",
      "lt": "Kilogramas",
      "ms": "Kilogram",
      "nb": "Kilogram",
      "nl": "Kilogram",
      "pl": "Kilogram",
      "pt": "Quilograma",
      "ro": "Kilogram",
      "ru": "Килограмм",
      "sk": "Kilogram",
      "sl": "Kilogram",
      "sv": "Kilogram",
      "th": "กิโลกรัม",
      "tr": "Kilogram",
      "uk": "Кілограм",
      "vi": "Kilôgam",
      "zh": "千克",
    },

    WeightUnit.gram: {
      "ar": "غرام",
      "bg": "Грам",
      "ca": "Gram",
      "cs": "Gram",
      "da": "Gram",
      "de": "Gramm",
      "el": "Γραμμάριο",
      "en": "Gram",
      "es": "Gramo",
      "fi": "Gramma",
      "fr": "Gramme",
      "he": "גרם",
      "hi": "ग्राम",
      "hr": "Gram",
      "hu": "Gramm",
      "id": "Gram",
      "it": "Grammo",
      "ja": "グラム",
      "ko": "그램",
      "lt": "Gramas",
      "ms": "Gram",
      "nb": "Gram",
      "nl": "Gram",
      "pl": "Gram",
      "pt": "Grama",
      "ro": "Gram",
      "ru": "Грамм",
      "sk": "Gram",
      "sl": "Gram",
      "sv": "Gram",
      "th": "กรัม",
      "tr": "Gram",
      "uk": "Грам",
      "vi": "Gam",
      "zh": "克",
    },

    WeightUnit.tonne: {
      "ar": "طن",
      "bg": "Тон",
      "ca": "Tona",
      "cs": "Tuna",
      "da": "Tons",
      "de": "Tonne",
      "el": "Τόνος",
      "en": "Tonne",
      "es": "Tonelada",
      "fi": "Tonni",
      "fr": "Tonne",
      "he": "טון",
      "hi": "टन",
      "hr": "Tona",
      "hu": "Tonna",
      "id": "Ton",
      "it": "Tonnellata",
      "ja": "トン",
      "ko": "톤",
      "lt": "Tona",
      "ms": "Tan",
      "nb": "Tonn",
      "nl": "Ton",
      "pl": "Tona",
      "pt": "Tonelada",
      "ro": "Tonă",
      "ru": "Тонна",
      "sk": "Tona",
      "sl": "Tona",
      "sv": "Ton",
      "th": "ตัน",
      "tr": "Ton",
      "uk": "Тонна",
      "vi": "Tấn",
      "zh": "吨",
    },

    WeightUnit.pound: {
      "ar": "رطل",
      "bg": "Фунт",
      "ca": "Lliura",
      "cs": "Libra",
      "da": "Pund",
      "de": "Pfund",
      "el": "Λίβρα",
      "en": "Pound",
      "es": "Libra",
      "fi": "Pauna",
      "fr": "Livre",
      "he": "פאונד",
      "hi": "पाउंड",
      "hr": "Funta",
      "hu": "Font",
      "id": "Pound",
      "it": "Libbra",
      "ja": "ポンド",
      "ko": "파운드",
      "lt": "Svaras",
      "ms": "Paun",
      "nb": "Pund",
      "nl": "Pond",
      "pl": "Funt",
      "pt": "Libra",
      "ro": "Liră",
      "ru": "Фунт",
      "sk": "Libra",
      "sl": "Funt",
      "sv": "Pund",
      "th": "ปอนด์",
      "tr": "Pound",
      "uk": "Фунт",
      "vi": "Pound",
      "zh": "磅",
    },

    WeightUnit.ounce: {
      "ar": "أونصة",
      "bg": "Унция",
      "ca": "Unça",
      "cs": "Unce",
      "da": "Unse",
      "de": "Unze",
      "el": "Ουγγιά",
      "en": "Ounce",
      "es": "Onza",
      "fi": "Unssi",
      "fr": "Once",
      "he": "אונקיה",
      "hi": "औंस",
      "hr": "Unca",
      "hu": "Uncia",
      "id": "Ons",
      "it": "Oncia",
      "ja": "オンス",
      "ko": "온스",
      "lt": "Uncija",
      "ms": "Auns",
      "nb": "Unse",
      "nl": "Ons",
      "pl": "Uncja",
      "pt": "Onça",
      "ro": "Uncie",
      "ru": "Унция",
      "sk": "Unca",
      "sl": "Unča",
      "sv": "Uns",
      "th": "ออนซ์",
      "tr": "Ons",
      "uk": "Унція",
      "vi": "Ounce",
      "zh": "盎司",
    },
  };

  static String getName(WeightUnit unit, String languageCode) =>
      names[unit]?[languageCode] ?? names[unit]?['en'] ?? unit.name;
}
