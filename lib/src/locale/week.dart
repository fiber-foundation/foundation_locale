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

enum Weekday { monday, tuesday, wednesday, thursday, friday, saturday, sunday }

class AppWeek {
  // ignore: unused_field
  final AppRegionCode _source;
  final AppRegionCode _target;

  AppWeek({required AppRegionCode source, required AppRegionCode target}) : _source = source, _target = target;

  Weekday get firstDay => _target.firstDayOfWeek;

  Weekday get today => WeekdayExtension.fromDateTime(DateTime.now());

  List<Weekday> get orderedDays {
    final start = firstDay;
    final values = Weekday.values;
    final startIndex = values.indexOf(start);

    return [...values.sublist(startIndex), ...values.sublist(0, startIndex)];
  }

  String format(Weekday day) => _WeekTranslations.getName(day, _target.languageCode);

  List<String> formattedWeek() => orderedDays.map(format).toList();
}

extension on AppRegionCode {
  Weekday get firstDayOfWeek => switch (this) {
    AppRegionCode.us => Weekday.sunday,
    AppRegionCode.uk => Weekday.monday,
    AppRegionCode.fr => Weekday.monday,
  };
}

extension WeekdayExtension on Weekday {
  int get isoIndex => switch (this) {
    Weekday.monday => 1,
    Weekday.tuesday => 2,
    Weekday.wednesday => 3,
    Weekday.thursday => 4,
    Weekday.friday => 5,
    Weekday.saturday => 6,
    Weekday.sunday => 7,
  };

  static Weekday fromDateTime(DateTime date) => Weekday.values[date.weekday - 1];
}

class _WeekTranslations {
  static const Map<Weekday, Map<String, String>> names = {
    Weekday.monday: {
      "en": "Monday",
      "fr": "Lundi",
      "de": "Montag",
      "es": "Lunes",
      "it": "Lunedì",
      "ru": "Понедельник",
      "zh": "星期一",
    },
    Weekday.tuesday: {
      "en": "Tuesday",
      "fr": "Mardi",
      "de": "Dienstag",
      "es": "Martes",
      "it": "Martedì",
      "ru": "Вторник",
      "zh": "星期二",
    },
    Weekday.wednesday: {
      "en": "Wednesday",
      "fr": "Mercredi",
      "de": "Mittwoch",
      "es": "Miércoles",
      "it": "Mercoledì",
      "ru": "Среда",
      "zh": "星期三",
    },
    Weekday.thursday: {
      "en": "Thursday",
      "fr": "Jeudi",
      "de": "Donnerstag",
      "es": "Jueves",
      "it": "Giovedì",
      "ru": "Четверг",
      "zh": "星期四",
    },
    Weekday.friday: {
      "en": "Friday",
      "fr": "Vendredi",
      "de": "Freitag",
      "es": "Viernes",
      "it": "Venerdì",
      "ru": "Пятница",
      "zh": "星期五",
    },
    Weekday.saturday: {
      "en": "Saturday",
      "fr": "Samedi",
      "de": "Samstag",
      "es": "Sábado",
      "it": "Sabato",
      "ru": "Суббота",
      "zh": "星期六",
    },
    Weekday.sunday: {
      "en": "Sunday",
      "fr": "Dimanche",
      "de": "Sonntag",
      "es": "Domingo",
      "it": "Domenica",
      "ru": "Воскресенье",
      "zh": "星期日",
    },
  };

  static String getName(Weekday day, String languageCode) => names[day]?[languageCode] ?? names[day]?['en'] ?? day.name;
}
