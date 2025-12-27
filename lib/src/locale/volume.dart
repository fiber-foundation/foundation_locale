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

enum VolumeUnit { liter, milliliter, cubicMeter, gallon, fluidOunce }

enum VolumeSymbolStyle {
  symbol, // L, mL, gal, fl oz
  unit, // liter, milliliter, gallon
}

class AppVolume {
  final AppRegionCode _source;
  final AppRegionCode _target;

  AppVolume({required AppRegionCode source, required AppRegionCode target}) : _source = source, _target = target;

  String format(double value, {int fractionDigits = 2, VolumeSymbolStyle style = VolumeSymbolStyle.symbol}) {
    final liter = _toLiter(value, _source.volumeUnit);
    final converted = _fromLiter(liter, _target.volumeUnit);
    final formatted = converted.toStringAsFixed(fractionDigits);
    final unit = style == VolumeSymbolStyle.symbol
        ? _target.volumeUnit.symbol
        : _VolumeTranslations.getName(_target.volumeUnit, _target.languageCode);

    return '$formatted $unit';
  }

  double _toLiter(double value, VolumeUnit unit) {
    return switch (unit) {
      VolumeUnit.liter => value,
      VolumeUnit.milliliter => value / 1000,
      VolumeUnit.cubicMeter => value * 1000,
      VolumeUnit.gallon => value * 3.78541,
      VolumeUnit.fluidOunce => value * 0.0295735,
    };
  }

  double _fromLiter(double liter, VolumeUnit unit) {
    return switch (unit) {
      VolumeUnit.liter => liter,
      VolumeUnit.milliliter => liter * 1000,
      VolumeUnit.cubicMeter => liter / 1000,
      VolumeUnit.gallon => liter / 3.78541,
      VolumeUnit.fluidOunce => liter / 0.0295735,
    };
  }
}

extension AppRegionCodeVolume on AppRegionCode {
  VolumeUnit get volumeUnit => switch (this) {
    AppRegionCode.us => VolumeUnit.gallon,
    AppRegionCode.uk => VolumeUnit.liter, // UK = metric pour volume
    AppRegionCode.fr => VolumeUnit.liter,
  };
}

extension VolumeUnitExtension on VolumeUnit {
  String get symbol => switch (this) {
    VolumeUnit.liter => 'L',
    VolumeUnit.milliliter => 'mL',
    VolumeUnit.cubicMeter => 'm³',
    VolumeUnit.gallon => 'gal',
    VolumeUnit.fluidOunce => 'fl oz',
  };

  String get name => switch (this) {
    VolumeUnit.liter => 'Liter',
    VolumeUnit.milliliter => 'Milliliter',
    VolumeUnit.cubicMeter => 'Cubic meter',
    VolumeUnit.gallon => 'Gallon',
    VolumeUnit.fluidOunce => 'Fluid ounce',
  };
}

class _VolumeTranslations {
  static const Map<VolumeUnit, Map<String, String>> names = {
    VolumeUnit.liter: {
      "ar": "لتر",
      "bg": "Литър",
      "ca": "Litre",
      "cs": "Litr",
      "da": "Liter",
      "de": "Liter",
      "el": "Λίτρο",
      "en": "Liter",
      "es": "Litro",
      "fi": "Litra",
      "fr": "Litre",
      "he": "ליטר",
      "hi": "लीटर",
      "hr": "Litra",
      "hu": "Liter",
      "id": "Liter",
      "it": "Litro",
      "ja": "リットル",
      "ko": "리터",
      "lt": "Litras",
      "ms": "Liter",
      "nb": "Liter",
      "nl": "Liter",
      "pl": "Litr",
      "pt": "Litro",
      "ro": "Litru",
      "ru": "Литр",
      "sk": "Liter",
      "sl": "Liter",
      "sv": "Liter",
      "th": "ลิตร",
      "tr": "Litre",
      "uk": "Літр",
      "vi": "Lít",
      "zh": "升",
    },

    VolumeUnit.milliliter: {
      "ar": "ملليلتر",
      "bg": "Милилитър",
      "ca": "Mil·lilitre",
      "cs": "Mililitr",
      "da": "Milliliter",
      "de": "Milliliter",
      "el": "Χιλιοστόλιτρο",
      "en": "Milliliter",
      "es": "Mililitro",
      "fi": "Millilitra",
      "fr": "Millilitre",
      "he": "מיליליטר",
      "hi": "मिलीलीटर",
      "hr": "Mililitra",
      "hu": "Milliliter",
      "id": "Mililiter",
      "it": "Millilitro",
      "ja": "ミリリットル",
      "ko": "밀리리터",
      "lt": "Mililitras",
      "ms": "Mililiter",
      "nb": "Milliliter",
      "nl": "Milliliter",
      "pl": "Mililitr",
      "pt": "Mililitro",
      "ro": "Mililitru",
      "ru": "Миллилитр",
      "sk": "Mililiter",
      "sl": "Mililiter",
      "sv": "Milliliter",
      "th": "มิลลิลิตร",
      "tr": "Mililitre",
      "uk": "Мілілітр",
      "vi": "Mililit",
      "zh": "毫升",
    },

    VolumeUnit.cubicMeter: {
      "ar": "متر مكعب",
      "bg": "Кубичен метър",
      "ca": "Metre cúbic",
      "cs": "Kubický metr",
      "da": "Kubikmeter",
      "de": "Kubikmeter",
      "el": "Κυβικό μέτρο",
      "en": "Cubic meter",
      "es": "Metro cúbico",
      "fi": "Kuutiometri",
      "fr": "Mètre cube",
      "he": "מטר מעוקב",
      "hi": "घन मीटर",
      "hr": "Kubni metar",
      "hu": "Köbméter",
      "id": "Meter kubik",
      "it": "Metro cubo",
      "ja": "立方メートル",
      "ko": "세제곱미터",
      "lt": "Kubinis metras",
      "ms": "Meter padu",
      "nb": "Kubikkmeter",
      "nl": "Kubieke meter",
      "pl": "Metr sześcienny",
      "pt": "Metro cúbico",
      "ro": "Metru cub",
      "ru": "Кубический метр",
      "sk": "Kubický meter",
      "sl": "Kubični meter",
      "sv": "Kubikmeter",
      "th": "ลูกบาศก์เมตร",
      "tr": "Metreküp",
      "uk": "Кубічний метр",
      "vi": "Mét khối",
      "zh": "立方米",
    },

    VolumeUnit.gallon: {
      "ar": "غالون",
      "bg": "Галон",
      "ca": "Galó",
      "cs": "Galon",
      "da": "Gallon",
      "de": "Gallone",
      "el": "Γαλόνι",
      "en": "Gallon",
      "es": "Galón",
      "fi": "Gallona",
      "fr": "Gallon",
      "he": "גלון",
      "hi": "गैलन",
      "hr": "Galon",
      "hu": "Gallon",
      "id": "Galon",
      "it": "Gallone",
      "ja": "ガロン",
      "ko": "갤런",
      "lt": "Galonas",
      "ms": "Gelen",
      "nb": "Gallon",
      "nl": "Gallon",
      "pl": "Galon",
      "pt": "Galão",
      "ro": "Galon",
      "ru": "Галлон",
      "sk": "Galón",
      "sl": "Galona",
      "sv": "Gallon",
      "th": "แกลลอน",
      "tr": "Galon",
      "uk": "Галон",
      "vi": "Gallon",
      "zh": "加仑",
    },

    VolumeUnit.fluidOunce: {
      "ar": "أونصة سائلة",
      "bg": "Течна унция",
      "ca": "Unça líquida",
      "cs": "Tekutá unce",
      "da": "Flydende ounce",
      "de": "Flüssigunze",
      "el": "Υγρή ουγγιά",
      "en": "Fluid ounce",
      "es": "Onza líquida",
      "fi": "Nesteyncia",
      "fr": "Once liquide",
      "he": "אונקיה נוזלית",
      "hi": "द्रव औंस",
      "hr": "Tekuća unca",
      "hu": "Folyékony uncia",
      "id": "Ons cair",
      "it": "Oncia fluida",
      "ja": "液量オンス",
      "ko": "액량 온스",
      "lt": "Skysčio uncija",
      "ms": "Auns cecair",
      "nb": "Flytende unse",
      "nl": "Vloeibare ounce",
      "pl": "Uncja płynna",
      "pt": "Onça fluida",
      "ro": "Uncie lichidă",
      "ru": "Жидкая унция",
      "sk": "Tekutá unca",
      "sl": "Tekoča unča",
      "sv": "Fluid ounce",
      "th": "ออนซ์ของเหลว",
      "tr": "Sıvı ons",
      "uk": "Рідка унція",
      "vi": "Ounce lỏng",
      "zh": "液量盎司",
    },
  };

  static String getName(VolumeUnit unit, String languageCode) =>
      names[unit]?[languageCode] ?? names[unit]?['en'] ?? unit.name;
}
