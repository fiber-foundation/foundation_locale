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
import '../services/services.dart';

enum CurrencyCode { eur, usd, gbp }

enum CurrencySymbolStyle {
  symbol, // €, $
  code, // EUR, USD
  name, // euro, dollar
}

enum CurrencySeparatorStyle {
  locale, // selon la région (1 000,00 € / $1,000.00)
  compact, // 1k, 1M (optionnel plus tard)
}

class AppCurrency {
  final AppRegionCode _source;
  final AppRegionCode _target;

  AppCurrency({required AppRegionCode source, required AppRegionCode target}) : _source = source, _target = target;

  String convert(
    double amount, {
    CurrencySymbolStyle style = CurrencySymbolStyle.symbol,
    CurrencySeparatorStyle separator = CurrencySeparatorStyle.locale,
  }) {
    final currency = _target.code;
    final bool isCompact = separator == CurrencySeparatorStyle.compact;
    final NumberFormat format = isCompact ? _compactFormat(currency, style) : _standardFormat(currency, style);

    return format.format(amount);
  }

  String convertWithExchange(
    double amount, {
    CurrencySymbolStyle style = CurrencySymbolStyle.symbol,
    CurrencySeparatorStyle separator = CurrencySeparatorStyle.locale,
  }) {
    final sourceCode = _source.code;
    final targetCode = _target.code;

    final value = FoundationLocaleServices.local.currencyService.convert(
      amount: amount,
      from: sourceCode.code,
      to: targetCode.code,
    );

    if (value == null) return _CurrencyTranslations.getUnavailable(_target.languageCode);

    return convert(value, style: style, separator: separator);
  }

  NumberFormat _standardFormat(CurrencyCode currency, CurrencySymbolStyle style) {
    return switch (style) {
      CurrencySymbolStyle.symbol => NumberFormat.currency(
        locale: _target.localeTag,
        symbol: currency.symbol,
        decimalDigits: currency.decimals,
      ),
      CurrencySymbolStyle.code => NumberFormat.currency(
        locale: _target.localeTag,
        name: currency.code,
        symbol: currency.code,
        decimalDigits: currency.decimals,
      ),
      CurrencySymbolStyle.name => NumberFormat.currency(
        locale: _target.localeTag,
        name: currency.name,
        decimalDigits: currency.decimals,
      ),
    };
  }

  NumberFormat _compactFormat(CurrencyCode currency, CurrencySymbolStyle style) {
    return switch (style) {
      CurrencySymbolStyle.symbol => NumberFormat.compactCurrency(locale: _target.localeTag, symbol: currency.symbol),
      CurrencySymbolStyle.code => NumberFormat.compactCurrency(
        locale: _target.localeTag,
        name: currency.code,
        symbol: currency.code,
      ),
      CurrencySymbolStyle.name => NumberFormat.compactCurrency(locale: _target.localeTag, name: currency.code),
    };
  }
}

extension on AppRegionCode {
  CurrencyCode get code => switch (this) {
    AppRegionCode.us => CurrencyCode.usd,
    AppRegionCode.uk => CurrencyCode.gbp,
    AppRegionCode.fr => CurrencyCode.eur,
  };
}

extension CurrencyCodeExtension on CurrencyCode {
  String get symbol => switch (this) {
    CurrencyCode.usd => r'$',
    CurrencyCode.gbp => '£',
    CurrencyCode.eur => '€',
  };

  String get code => switch (this) {
    CurrencyCode.usd => 'USD',
    CurrencyCode.gbp => 'GBP',
    CurrencyCode.eur => 'EUR',
  };

  String get name => switch (this) {
    CurrencyCode.usd => 'Dollar',
    CurrencyCode.gbp => 'Pound',
    CurrencyCode.eur => 'Euro',
  };

  int get decimals => switch (this) {
    CurrencyCode.usd => 2,
    CurrencyCode.gbp => 2,
    CurrencyCode.eur => 2,
  };
}

class _CurrencyTranslations {
  static const Map<String, String> unavailable = {
    "ar": "غير متوفر",
    "bg": "Недостъпно",
    "ca": "No disponible",
    "cs": "Nedostupné",
    "da": "Ikke tilgængelig",
    "de": "Nicht verfügbar",
    "el": "Μη διαθέσιμο",
    "en": "Unavailable",
    "es": "No disponible",
    "fi": "Ei saatavilla",
    "fr": "Indisponible",
    "he": "לא זמין",
    "hi": "उपलब्ध नहीं",
    "hr": "Nedostupno",
    "hu": "Nem elérhető",
    "id": "Tidak tersedia",
    "it": "Non disponibile",
    "ja": "利用不可",
    "ko": "사용할 수 없음",
    "lt": "Nepasiekiama",
    "ms": "Tidak tersedia",
    "nb": "Ikke tilgjengelig",
    "nl": "Niet beschikbaar",
    "pl": "Niedostępne",
    "pt": "Indisponível",
    "ro": "Indisponibil",
    "ru": "Недоступно",
    "sk": "Nedostupné",
    "sl": "Ni na voljo",
    "sv": "Inte tillgänglig",
    "th": "ไม่พร้อมใช้งาน",
    "tr": "Kullanılamıyor",
    "uk": "Недоступно",
    "vi": "Không khả dụng",
    "zh": "不可用",
  };

  static String getUnavailable(String languageCode) => unavailable[languageCode] ?? 'Unavailable';
}
