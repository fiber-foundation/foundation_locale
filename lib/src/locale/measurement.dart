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

enum DistanceUnit { millimeter, centimeter, meter, kilometer, inch, foot, mile }

enum SpeedUnit { meterPerSecond, kilometerPerHour, milePerHour }

class AppMeasurement {
  final AppRegionCode _source;
  final AppRegionCode _target;

  AppMeasurement({required AppRegionCode source, required AppRegionCode target}) : _source = source, _target = target;

  AppDistance get distance => AppDistance(source: _source, target: _target);
  AppSpeed get speed => AppSpeed(source: _source, target: _target);
}

class AppDistance {
  final AppRegionCode _source;
  final AppRegionCode _target;

  AppDistance({required AppRegionCode source, required AppRegionCode target}) : _source = source, _target = target;

  double convert(double value) {
    final meters = value * _source.distanceUnit.toMeter;
    return _target.distanceUnit.fromMeter(meters);
  }

  String format(double value, {int fractionDigits = 2}) {
    final converted = convert(value);
    final number = NumberFormat.decimalPattern(_target.localeTag)..maximumFractionDigits = fractionDigits;
    final unitName = _DistanceTranslations.getName(_target.distanceUnit, _target.languageCode);

    return '${number.format(converted)} $unitName';
  }
}

class AppSpeed {
  final AppRegionCode _source;
  final AppRegionCode _target;

  AppSpeed({required AppRegionCode source, required AppRegionCode target}) : _source = source, _target = target;

  double convert(double value) {
    final metersPerSecond = value * _source.speedUnit.toMetersPerSecond;
    return _target.speedUnit.fromMetersPerSecond(metersPerSecond);
  }

  String format(double value, {int fractionDigits = 1}) {
    final converted = convert(value);
    final number = NumberFormat.decimalPattern(_target.localeTag)..maximumFractionDigits = fractionDigits;
    final unitName = _SpeedTranslations.getName(_target.speedUnit, _target.languageCode);

    return '${number.format(converted)} $unitName';
  }
}

extension on AppRegionCode {
  DistanceUnit get distanceUnit => switch (this) {
    AppRegionCode.fr => DistanceUnit.kilometer,
    AppRegionCode.uk => DistanceUnit.mile,
    AppRegionCode.us => DistanceUnit.mile,
  };

  SpeedUnit get speedUnit => switch (this) {
    AppRegionCode.fr => SpeedUnit.kilometerPerHour,
    AppRegionCode.uk => SpeedUnit.milePerHour,
    AppRegionCode.us => SpeedUnit.milePerHour,
  };
}

extension SpeedUnitExtension on SpeedUnit {
  double get toMetersPerSecond => switch (this) {
    SpeedUnit.meterPerSecond => 1.0,
    SpeedUnit.kilometerPerHour => 1000 / 3600,
    SpeedUnit.milePerHour => 1609.344 / 3600,
  };

  double fromMetersPerSecond(double value) => value / toMetersPerSecond;
}

extension DistanceUnitExtension on DistanceUnit {
  double get toMeter => switch (this) {
    DistanceUnit.millimeter => 0.001,
    DistanceUnit.centimeter => 0.01,
    DistanceUnit.meter => 1.0,
    DistanceUnit.kilometer => 1000.0,
    DistanceUnit.inch => 0.0254,
    DistanceUnit.foot => 0.3048,
    DistanceUnit.mile => 1609.344,
  };

  double fromMeter(double meters) => meters / toMeter;
}

class _DistanceTranslations {
  static const Map<DistanceUnit, Map<String, String>> names = {
    DistanceUnit.meter: {
      "ar": "متر",
      "bg": "Метър",
      "ca": "Metre",
      "cs": "Metr",
      "da": "Meter",
      "de": "Meter",
      "el": "Μέτρο",
      "en": "Meter",
      "es": "Metro",
      "fi": "Metri",
      "fr": "Mètre",
      "he": "מטר",
      "hi": "मीटर",
      "hr": "Metar",
      "hu": "Méter",
      "id": "Meter",
      "it": "Metro",
      "ja": "メートル",
      "ko": "미터",
      "lt": "Metras",
      "ms": "Meter",
      "nb": "Meter",
      "nl": "Meter",
      "pl": "Metr",
      "pt": "Metro",
      "ro": "Metru",
      "ru": "Метр",
      "sk": "Meter",
      "sl": "Meter",
      "sv": "Meter",
      "th": "เมตร",
      "tr": "Metre",
      "uk": "Метр",
      "vi": "Mét",
      "zh": "米",
    },

    DistanceUnit.kilometer: {
      "ar": "كيلومتر",
      "bg": "Километър",
      "ca": "Quilòmetre",
      "cs": "Kilometr",
      "da": "Kilometer",
      "de": "Kilometer",
      "el": "Χιλιόμετρο",
      "en": "Kilometer",
      "es": "Kilómetro",
      "fi": "Kilometri",
      "fr": "Kilomètre",
      "he": "קילומטר",
      "hi": "किलोमीटर",
      "hr": "Kilometar",
      "hu": "Kilométer",
      "id": "Kilometer",
      "it": "Chilometro",
      "ja": "キロメートル",
      "ko": "킬로미터",
      "lt": "Kilometras",
      "ms": "Kilometer",
      "nb": "Kilometer",
      "nl": "Kilometer",
      "pl": "Kilometr",
      "pt": "Quilómetro",
      "ro": "Kilometru",
      "ru": "Километр",
      "sk": "Kilometer",
      "sl": "Kilometer",
      "sv": "Kilometer",
      "th": "กิโลเมตร",
      "tr": "Kilometre",
      "uk": "Кілометр",
      "vi": "Kilômét",
      "zh": "公里",
    },

    DistanceUnit.mile: {
      "ar": "ميل",
      "bg": "Миля",
      "ca": "Milla",
      "cs": "Míle",
      "da": "Mil",
      "de": "Meile",
      "el": "Μίλι",
      "en": "Mile",
      "es": "Milla",
      "fi": "Maili",
      "fr": "Mile",
      "he": "מייל",
      "hi": "मील",
      "hr": "Milja",
      "hu": "Mérföld",
      "id": "Mil",
      "it": "Miglio",
      "ja": "マイル",
      "ko": "마일",
      "lt": "Mylia",
      "ms": "Batu",
      "nb": "Mil",
      "nl": "Mijl",
      "pl": "Mila",
      "pt": "Milha",
      "ro": "Milă",
      "ru": "Миля",
      "sk": "Míľa",
      "sl": "Milja",
      "sv": "Mil",
      "th": "ไมล์",
      "tr": "Mil",
      "uk": "Миля",
      "vi": "Dặm",
      "zh": "英里",
    },

    DistanceUnit.foot: {
      "ar": "قدم",
      "bg": "Фут",
      "ca": "Peu",
      "cs": "Stopa",
      "da": "Fod",
      "de": "Fuß",
      "el": "Πόδι",
      "en": "Foot",
      "es": "Pie",
      "fi": "Jalka",
      "fr": "Pied",
      "he": "רגל",
      "hi": "फुट",
      "hr": "Stopa",
      "hu": "Láb",
      "id": "Kaki",
      "it": "Piede",
      "ja": "フィート",
      "ko": "피트",
      "lt": "Pėda",
      "ms": "Kaki",
      "nb": "Fot",
      "nl": "Voet",
      "pl": "Stopa",
      "pt": "Pé",
      "ro": "Picior",
      "ru": "Фут",
      "sk": "Stopa",
      "sl": "Čevelj",
      "sv": "Fot",
      "th": "ฟุต",
      "tr": "Fit",
      "uk": "Фут",
      "vi": "Foot",
      "zh": "英尺",
    },

    DistanceUnit.inch: {
      "ar": "بوصة",
      "bg": "Инч",
      "ca": "Polzada",
      "cs": "Palec",
      "da": "Tomme",
      "de": "Zoll",
      "el": "Ίντσα",
      "en": "Inch",
      "es": "Pulgada",
      "fi": "Tuuma",
      "fr": "Pouce",
      "he": "אינץ׳",
      "hi": "इंच",
      "hr": "Inč",
      "hu": "Hüvelyk",
      "id": "Inci",
      "it": "Pollice",
      "ja": "インチ",
      "ko": "인치",
      "lt": "Colis",
      "ms": "Inci",
      "nb": "Tommer",
      "nl": "Inch",
      "pl": "Cal",
      "pt": "Polegada",
      "ro": "Inch",
      "ru": "Дюйм",
      "sk": "Palec",
      "sl": "Palec",
      "sv": "Tum",
      "th": "นิ้ว",
      "tr": "İnç",
      "uk": "Дюйм",
      "vi": "Inch",
      "zh": "英寸",
    },
  };

  static String getName(DistanceUnit unit, String languageCode) =>
      names[unit]?[languageCode] ?? names[unit]?['en'] ?? unit.name;
}

class _SpeedTranslations {
  static const Map<SpeedUnit, Map<String, String>> names = {
    SpeedUnit.meterPerSecond: {
      "ar": "متر في الثانية",
      "bg": "Метър в секунда",
      "ca": "Metre per segon",
      "cs": "Metr za sekundu",
      "da": "Meter per sekund",
      "de": "Meter pro Sekunde",
      "el": "Μέτρο ανά δευτερόλεπτο",
      "en": "Meter per second",
      "es": "Metro por segundo",
      "fi": "Metri sekunnissa",
      "fr": "Mètre par seconde",
      "he": "מטר לשנייה",
      "hi": "मीटर प्रति सेकंड",
      "hr": "Metar u sekundi",
      "hu": "Méter per másodperc",
      "id": "Meter per detik",
      "it": "Metro al secondo",
      "ja": "メートル毎秒",
      "ko": "미터/초",
      "lt": "Metrai per sekundę",
      "ms": "Meter sesaat",
      "nb": "Meter per sekund",
      "nl": "Meter per seconde",
      "pl": "Metr na sekundę",
      "pt": "Metro por segundo",
      "ro": "Metru pe secundă",
      "ru": "Метр в секунду",
      "sk": "Meter za sekundu",
      "sl": "Meter na sekundo",
      "sv": "Meter per sekund",
      "th": "เมตรต่อวินาที",
      "tr": "Saniyede metre",
      "uk": "Метр за секунду",
      "vi": "Mét trên giây",
      "zh": "米每秒",
    },

    SpeedUnit.kilometerPerHour: {
      "ar": "كيلومتر في الساعة",
      "bg": "Километър в час",
      "ca": "Quilòmetre per hora",
      "cs": "Kilometr za hodinu",
      "da": "Kilometer i timen",
      "de": "Kilometer pro Stunde",
      "el": "Χιλιόμετρο ανά ώρα",
      "en": "Kilometer per hour",
      "es": "Kilómetro por hora",
      "fi": "Kilometri tunnissa",
      "fr": "Kilomètre par heure",
      "he": "קילומטר לשעה",
      "hi": "किलोमीटर प्रति घंटा",
      "hr": "Kilometar na sat",
      "hu": "Kilométer per óra",
      "id": "Kilometer per jam",
      "it": "Chilometro all'ora",
      "ja": "キロメートル毎時",
      "ko": "킬로미터/시간",
      "lt": "Kilometrai per valandą",
      "ms": "Kilometer sejam",
      "nb": "Kilometer i timen",
      "nl": "Kilometer per uur",
      "pl": "Kilometr na godzinę",
      "pt": "Quilómetro por hora",
      "ro": "Kilometru pe oră",
      "ru": "Километр в час",
      "sk": "Kilometer za hodinu",
      "sl": "Kilometer na uro",
      "sv": "Kilometer i timmen",
      "th": "กิโลเมตรต่อชั่วโมง",
      "tr": "Saatte kilometre",
      "uk": "Кілометр за годину",
      "vi": "Kilômét trên giờ",
      "zh": "公里每小时",
    },

    SpeedUnit.milePerHour: {
      "ar": "ميل في الساعة",
      "bg": "Миля в час",
      "ca": "Milla per hora",
      "cs": "Míle za hodinu",
      "da": "Mil i timen",
      "de": "Meile pro Stunde",
      "el": "Μίλι ανά ώρα",
      "en": "Mile per hour",
      "es": "Milla por hora",
      "fi": "Mailia tunnissa",
      "fr": "Mile par heure",
      "he": "מייל לשעה",
      "hi": "मील प्रति घंटा",
      "hr": "Milja na sat",
      "hu": "Mérföld per óra",
      "id": "Mil per jam",
      "it": "Miglio all'ora",
      "ja": "マイル毎時",
      "ko": "마일/시간",
      "lt": "Mylios per valandą",
      "ms": "Batu sejam",
      "nb": "Mil i timen",
      "nl": "Mijl per uur",
      "pl": "Mila na godzinę",
      "pt": "Milha por hora",
      "ro": "Milă pe oră",
      "ru": "Миля в час",
      "sk": "Míľa za hodinu",
      "sl": "Milja na uro",
      "sv": "Mil i timmen",
      "th": "ไมล์ต่อชั่วโมง",
      "tr": "Saatte mil",
      "uk": "Миля за годину",
      "vi": "Dặm trên giờ",
      "zh": "英里每小时",
    },
  };

  static String getName(SpeedUnit unit, String languageCode) =>
      names[unit]?[languageCode] ?? names[unit]?['en'] ?? unit.name;
}
