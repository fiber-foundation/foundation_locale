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
import 'package:timeago/timeago.dart' as timeago;

import '../../extensions/region_code.dart';
import '../../fiber_foundation_locale.dart';

enum DateFormatStyle { short, medium, long, full }

class AppDate {
  // ignore: unused_field
  final AppRegionCode _source;
  final AppRegionCode _target;

  AppDate({required AppRegionCode source, required AppRegionCode target}) : _source = source, _target = target;

  String format(DateTime date, {DateFormatStyle style = DateFormatStyle.medium}) {
    final formatter = style.formatter(_target.localeTag);
    return formatter.format(date);
  }

  String short(DateTime date, {bool showTimeIfToday = false}) {
    final now = DateTime.now();
    final locale = _target.localeTag;
    final languageCode = _target.languageCode;

    final today = DateTime(now.year, now.month, now.day);
    final targetDate = DateTime(date.year, date.month, date.day);

    final difference = today.difference(targetDate).inDays;

    if (difference == 0) {
      if (showTimeIfToday) {
        return DateFormat.jm(locale).format(date);
      }
      return _DateTranslations.getToday(languageCode);
    }
    if (difference == 1) {
      return _DateTranslations.getYesterday(languageCode);
    }
    if (difference < 7) {
      return DateFormat.EEEE(locale).format(date);
    }
    return DateFormat('E d MMM', locale).format(date);
  }

  String medium(DateTime date) => format(date, style: DateFormatStyle.medium);

  String long(DateTime date) => format(date, style: DateFormatStyle.long);

  String full(DateTime date) => format(date, style: DateFormatStyle.full);

  String ago(DateTime date) => timeago.format(date, locale: _target.languageCode);

  String relativeShort(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);

    final seconds = diff.inSeconds;
    final minutes = diff.inMinutes;
    final hours = diff.inHours;
    final days = diff.inDays;

    final languageCode = _target.languageCode;

    if (seconds < 60) {
      final u = _RelativeTimeTranslations.unit('second', languageCode);
      return '$seconds$u';
    }
    if (minutes < 60) {
      final u = _RelativeTimeTranslations.unit('minute', languageCode);
      return '$minutes$u';
    }
    if (hours < 24) {
      final u = _RelativeTimeTranslations.unit('hour', languageCode);
      return '$hours$u';
    }
    if (days < 7) {
      final u = _RelativeTimeTranslations.unit('day', languageCode);
      return '$days$u';
    }
    return DateFormat('E d MMM', _target.localeTag).format(date);
  }

  int compare(DateTime a, DateTime b) {
    final da = DateTime(a.year, a.month, a.day);
    final db = DateTime(b.year, b.month, b.day);
    return da.compareTo(db);
  }

  bool isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year && date.month == now.month && date.day == now.day;
  }

  String formatRange(DateTime start, DateTime end, {DateFormatStyle style = DateFormatStyle.medium}) {
    if (start.isAfter(end)) {
      final tmp = start;
      start = end;
      end = tmp;
    }

    final locale = _target.localeTag;

    if (_isSameDay(start, end)) {
      return format(start, style: style);
    }

    if (start.year == end.year && start.month == end.month) {
      final dayFormatter = DateFormat.d(locale);
      final monthYearFormatter = DateFormat.yMMMM(locale);

      return '${dayFormatter.format(start)}–${dayFormatter.format(end)} '
          '${monthYearFormatter.format(start)}';
    }

    if (start.year == end.year) {
      final dayMonthFormatter = DateFormat.MMMMd(locale);
      final yearFormatter = DateFormat.y(locale);

      return '${dayMonthFormatter.format(start)} – '
          '${dayMonthFormatter.format(end)} '
          '${yearFormatter.format(start)}';
    }

    final fullFormatter = style.formatter(locale);
    return '${fullFormatter.format(start)} – ${fullFormatter.format(end)}';
  }

  bool _isSameDay(DateTime a, DateTime b) => a.year == b.year && a.month == b.month && a.day == b.day;
}

final Map<String, dynamic> foundationTimeago = {
  'ar': timeago.ArMessages(),
  'az': timeago.AzMessages(),
  'ca': timeago.CaMessages(),
  'cs': timeago.CsMessages(),
  'bn': timeago.BnMessages(),
  'da': timeago.DaMessages(),
  'de': timeago.DeMessages(),
  'dv': timeago.DvMessages(),
  'en': timeago.EnMessages(),
  'es': timeago.EsMessages(),
  'et': timeago.EtMessages(),
  'fa': timeago.FaMessages(),
  'fi': timeago.FiMessages(),
  'fr': timeago.FrMessages(),
  'gr': timeago.GrMessages(),
  'he': timeago.HeMessages(),
  'hi': timeago.HiMessages(),
  'hu': timeago.HuMessages(),
  'id': timeago.IdMessages(),
  'it': timeago.ItMessages(),
  'ja': timeago.JaMessages(),
  'km': timeago.KmMessages(),
  'ko': timeago.KoMessages(),
  'ku': timeago.KuMessages(),
  'mn': timeago.MnMessages(),
  'nl': timeago.NlMessages(),
  'pl': timeago.PlMessages(),
  'ro': timeago.RoMessages(),
  'ru': timeago.RuMessages(),
  'rw': timeago.RwMessages(),
  'sv': timeago.SvMessages(),
  'ta': timeago.TaMessages(),
  'th': timeago.ThMessages(),
  'tk': timeago.TkMessages(),
  'tr': timeago.TrMessages(),
  'uk': timeago.UkMessages(),
  'ur': timeago.UrMessages(),
  'vi': timeago.ViMessages(),
  'zh': timeago.ZhMessages(),
};

extension on DateFormatStyle {
  DateFormat formatter(String locale) {
    return switch (this) {
      DateFormatStyle.short => DateFormat.yMd(locale),
      DateFormatStyle.medium => DateFormat.yMMMd(locale),
      DateFormatStyle.long => DateFormat.yMMMMd(locale),
      DateFormatStyle.full => DateFormat.yMMMMEEEEd(locale),
    };
  }
}

class _DateTranslations {
  static const Map<String, String> today = {
    "ar": "اليوم",
    "bg": "Днес",
    "ca": "Avui",
    "cs": "Dnes",
    "da": "I dag",
    "de": "Heute",
    "el": "Σήμερα",
    "en": "Today",
    "es": "Hoy",
    "fi": "Tänään",
    "fr": "Aujourd'hui",
    "he": "היום",
    "hi": "आज",
    "hr": "Danas",
    "hu": "Ma",
    "id": "Hari ini",
    "it": "Oggi",
    "ja": "今日",
    "ko": "오늘",
    "lt": "Šiandien",
    "ms": "Hari ini",
    "nb": "I dag",
    "nl": "Vandaag",
    "pl": "Dzisiaj",
    "pt": "Hoje",
    "ro": "Astăzi",
    "ru": "Сегодня",
    "sk": "Dnes",
    "sl": "Danes",
    "sv": "Idag",
    "th": "วันนี้",
    "tr": "Bugün",
    "uk": "Сьогодні",
    "vi": "Hôm nay",
    "zh": "今天",
  };

  static const Map<String, String> yesterday = {
    "ar": "أمس",
    "bg": "Вчера",
    "ca": "Ahir",
    "cs": "Včera",
    "da": "I går",
    "de": "Gestern",
    "el": "Χθες",
    "en": "Yesterday",
    "es": "Ayer",
    "fi": "Eilen",
    "fr": "Hier",
    "he": "אתמול",
    "hi": "कल",
    "hr": "Jučer",
    "hu": "Tegnap",
    "id": "Kemarin",
    "it": "Ieri",
    "ja": "昨日",
    "ko": "어제",
    "lt": "Vakar",
    "ms": "Semalam",
    "nb": "I går",
    "nl": "Gisteren",
    "pl": "Wczoraj",
    "pt": "Ontem",
    "ro": "Ieri",
    "ru": "Вчера",
    "sk": "Včera",
    "sl": "Včeraj",
    "sv": "I går",
    "th": "เมื่อวาน",
    "tr": "Dün",
    "uk": "Вчора",
    "vi": "Hôm qua",
    "zh": "昨天",
  };

  static String getToday(String languageCode) => today[languageCode] ?? today['en']!;

  static String getYesterday(String languageCode) => yesterday[languageCode] ?? yesterday['en']!;
}

class _RelativeTimeTranslations {
  static const Map<String, Map<String, String>> units = {
    "second": {
      "ar": "ث",
      "bg": "с",
      "ca": "s",
      "cs": "s",
      "da": "s",
      "de": "s",
      "el": "δ",
      "en": "s",
      "es": "s",
      "fi": "s",
      "fr": "s",
      "he": "ש׳",
      "hi": "से",
      "hr": "s",
      "hu": "mp",
      "id": "dtk",
      "it": "s",
      "ja": "秒",
      "ko": "초",
      "lt": "s",
      "ms": "s",
      "nb": "s",
      "nl": "s",
      "pl": "s",
      "pt": "s",
      "ro": "s",
      "ru": "с",
      "sk": "s",
      "sl": "s",
      "sv": "s",
      "th": "วิ",
      "tr": "sn",
      "uk": "с",
      "vi": "giây",
      "zh": "秒",
    },
    "minute": {
      "ar": "د",
      "bg": "м",
      "ca": "min",
      "cs": "min",
      "da": "min",
      "de": "min",
      "el": "λ",
      "en": "m",
      "es": "min",
      "fi": "min",
      "fr": "min",
      "he": "ד׳",
      "hi": "मि",
      "hr": "min",
      "hu": "p",
      "id": "mnt",
      "it": "min",
      "ja": "分",
      "ko": "분",
      "lt": "min",
      "ms": "min",
      "nb": "min",
      "nl": "m",
      "pl": "min",
      "pt": "min",
      "ro": "min",
      "ru": "м",
      "sk": "min",
      "sl": "min",
      "sv": "min",
      "th": "น",
      "tr": "dk",
      "uk": "хв",
      "vi": "ph",
      "zh": "分",
    },
    "hour": {
      "ar": "س",
      "bg": "ч",
      "ca": "h",
      "cs": "h",
      "da": "t",
      "de": "h",
      "el": "ω",
      "en": "h",
      "es": "h",
      "fi": "h",
      "fr": "h",
      "he": "ש׳",
      "hi": "घं",
      "hr": "h",
      "hu": "ó",
      "id": "j",
      "it": "h",
      "ja": "時",
      "ko": "시",
      "lt": "val",
      "ms": "j",
      "nb": "t",
      "nl": "u",
      "pl": "h",
      "pt": "h",
      "ro": "h",
      "ru": "ч",
      "sk": "h",
      "sl": "h",
      "sv": "h",
      "th": "ชม",
      "tr": "sa",
      "uk": "г",
      "vi": "giờ",
      "zh": "时",
    },
    "day": {
      "ar": "ي",
      "bg": "д",
      "ca": "d",
      "cs": "d",
      "da": "d",
      "de": "T",
      "el": "η",
      "en": "d",
      "es": "d",
      "fi": "pv",
      "fr": "j",
      "he": "י׳",
      "hi": "दि",
      "hr": "d",
      "hu": "n",
      "id": "hr",
      "it": "g",
      "ja": "日",
      "ko": "일",
      "lt": "d",
      "ms": "h",
      "nb": "d",
      "nl": "d",
      "pl": "d",
      "pt": "d",
      "ro": "z",
      "ru": "д",
      "sk": "d",
      "sl": "d",
      "sv": "d",
      "th": "ว",
      "tr": "g",
      "uk": "д",
      "vi": "ng",
      "zh": "天",
    },
  };

  static String unit(String key, String languageCode) {
    return units[key]?[languageCode] ?? units[key]?['en'] ?? key;
  }
}
