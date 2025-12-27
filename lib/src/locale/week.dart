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
      "ar": "الاثنين",
      "bg": "Понеделник",
      "ca": "Dilluns",
      "cs": "Pondělí",
      "da": "Mandag",
      "de": "Montag",
      "el": "Δευτέρα",
      "en": "Monday",
      "es": "Lunes",
      "fi": "Maanantai",
      "fr": "Lundi",
      "he": "יום שני",
      "hi": "सोमवार",
      "hr": "Ponedjeljak",
      "hu": "Hétfő",
      "id": "Senin",
      "it": "Lunedì",
      "ja": "月曜日",
      "ko": "월요일",
      "lt": "Pirmadienis",
      "ms": "Isnin",
      "nb": "Mandag",
      "nl": "Maandag",
      "pl": "Poniedziałek",
      "pt": "Segunda-feira",
      "ro": "Luni",
      "ru": "Понедельник",
      "sk": "Pondelok",
      "sl": "Ponedeljek",
      "sv": "Måndag",
      "th": "วันจันทร์",
      "tr": "Pazartesi",
      "uk": "Понеділок",
      "vi": "Thứ Hai",
      "zh": "星期一",
    },

    Weekday.tuesday: {
      "ar": "الثلاثاء",
      "bg": "Вторник",
      "ca": "Dimarts",
      "cs": "Úterý",
      "da": "Tirsdag",
      "de": "Dienstag",
      "el": "Τρίτη",
      "en": "Tuesday",
      "es": "Martes",
      "fi": "Tiistai",
      "fr": "Mardi",
      "he": "יום שלישי",
      "hi": "मंगलवार",
      "hr": "Utorak",
      "hu": "Kedd",
      "id": "Selasa",
      "it": "Martedì",
      "ja": "火曜日",
      "ko": "화요일",
      "lt": "Antradienis",
      "ms": "Selasa",
      "nb": "Tirsdag",
      "nl": "Dinsdag",
      "pl": "Wtorek",
      "pt": "Terça-feira",
      "ro": "Marți",
      "ru": "Вторник",
      "sk": "Utorok",
      "sl": "Torek",
      "sv": "Tisdag",
      "th": "วันอังคาร",
      "tr": "Salı",
      "uk": "Вівторок",
      "vi": "Thứ Ba",
      "zh": "星期二",
    },

    Weekday.wednesday: {
      "ar": "الأربعاء",
      "bg": "Сряда",
      "ca": "Dimecres",
      "cs": "Středa",
      "da": "Onsdag",
      "de": "Mittwoch",
      "el": "Τετάρτη",
      "en": "Wednesday",
      "es": "Miércoles",
      "fi": "Keskiviikko",
      "fr": "Mercredi",
      "he": "יום רביעי",
      "hi": "बुधवार",
      "hr": "Srijeda",
      "hu": "Szerda",
      "id": "Rabu",
      "it": "Mercoledì",
      "ja": "水曜日",
      "ko": "수요일",
      "lt": "Trečiadienis",
      "ms": "Rabu",
      "nb": "Onsdag",
      "nl": "Woensdag",
      "pl": "Środa",
      "pt": "Quarta-feira",
      "ro": "Miercuri",
      "ru": "Среда",
      "sk": "Streda",
      "sl": "Sreda",
      "sv": "Onsdag",
      "th": "วันพุธ",
      "tr": "Çarşamba",
      "uk": "Середа",
      "vi": "Thứ Tư",
      "zh": "星期三",
    },

    Weekday.thursday: {
      "ar": "الخميس",
      "bg": "Четвъртък",
      "ca": "Dijous",
      "cs": "Čtvrtek",
      "da": "Torsdag",
      "de": "Donnerstag",
      "el": "Πέμπτη",
      "en": "Thursday",
      "es": "Jueves",
      "fi": "Torstai",
      "fr": "Jeudi",
      "he": "יום חמישי",
      "hi": "गुरुवार",
      "hr": "Četvrtak",
      "hu": "Csütörtök",
      "id": "Kamis",
      "it": "Giovedì",
      "ja": "木曜日",
      "ko": "목요일",
      "lt": "Ketvirtadienis",
      "ms": "Khamis",
      "nb": "Torsdag",
      "nl": "Donderdag",
      "pl": "Czwartek",
      "pt": "Quinta-feira",
      "ro": "Joi",
      "ru": "Четверг",
      "sk": "Štvrtok",
      "sl": "Četrtek",
      "sv": "Torsdag",
      "th": "วันพฤหัสบดี",
      "tr": "Perşembe",
      "uk": "Четвер",
      "vi": "Thứ Năm",
      "zh": "星期四",
    },

    Weekday.friday: {
      "ar": "الجمعة",
      "bg": "Петък",
      "ca": "Divendres",
      "cs": "Pátek",
      "da": "Fredag",
      "de": "Freitag",
      "el": "Παρασκευή",
      "en": "Friday",
      "es": "Viernes",
      "fi": "Perjantai",
      "fr": "Vendredi",
      "he": "יום שישי",
      "hi": "शुक्रवार",
      "hr": "Petak",
      "hu": "Péntek",
      "id": "Jumat",
      "it": "Venerdì",
      "ja": "金曜日",
      "ko": "금요일",
      "lt": "Penktadienis",
      "ms": "Jumaat",
      "nb": "Fredag",
      "nl": "Vrijdag",
      "pl": "Piątek",
      "pt": "Sexta-feira",
      "ro": "Vineri",
      "ru": "Пятница",
      "sk": "Piatok",
      "sl": "Petek",
      "sv": "Fredag",
      "th": "วันศุกร์",
      "tr": "Cuma",
      "uk": "П’ятниця",
      "vi": "Thứ Sáu",
      "zh": "星期五",
    },

    Weekday.saturday: {
      "ar": "السبت",
      "bg": "Събота",
      "ca": "Dissabte",
      "cs": "Sobota",
      "da": "Lørdag",
      "de": "Samstag",
      "el": "Σάββατο",
      "en": "Saturday",
      "es": "Sábado",
      "fi": "Lauantai",
      "fr": "Samedi",
      "he": "שבת",
      "hi": "शनिवार",
      "hr": "Subota",
      "hu": "Szombat",
      "id": "Sabtu",
      "it": "Sabato",
      "ja": "土曜日",
      "ko": "토요일",
      "lt": "Šeštadienis",
      "ms": "Sabtu",
      "nb": "Lørdag",
      "nl": "Zaterdag",
      "pl": "Sobota",
      "pt": "Sábado",
      "ro": "Sâmbătă",
      "ru": "Суббота",
      "sk": "Sobota",
      "sl": "Sobota",
      "sv": "Lördag",
      "th": "วันเสาร์",
      "tr": "Cumartesi",
      "uk": "Субота",
      "vi": "Thứ Bảy",
      "zh": "星期六",
    },

    Weekday.sunday: {
      "ar": "الأحد",
      "bg": "Неделя",
      "ca": "Diumenge",
      "cs": "Neděle",
      "da": "Søndag",
      "de": "Sonntag",
      "el": "Κυριακή",
      "en": "Sunday",
      "es": "Domingo",
      "fi": "Sunnuntai",
      "fr": "Dimanche",
      "he": "יום ראשון",
      "hi": "रविवार",
      "hr": "Nedjelja",
      "hu": "Vasárnap",
      "id": "Minggu",
      "it": "Domenica",
      "ja": "日曜日",
      "ko": "일요일",
      "lt": "Sekmadienis",
      "ms": "Ahad",
      "nb": "Søndag",
      "nl": "Zondag",
      "pl": "Niedziela",
      "pt": "Domingo",
      "ro": "Duminică",
      "ru": "Воскресенье",
      "sk": "Nedeľa",
      "sl": "Nedelja",
      "sv": "Söndag",
      "th": "วันอาทิตย์",
      "tr": "Pazar",
      "uk": "Неділя",
      "vi": "Chủ Nhật",
      "zh": "星期日",
    },
  };

  static String getName(Weekday day, String languageCode) => names[day]?[languageCode] ?? names[day]?['en'] ?? day.name;
}
