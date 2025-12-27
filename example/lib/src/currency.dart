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

import 'package:fiber_foundation_locale/fiber_foundation_locale.dart';
import 'package:flutter/material.dart';

import '../widgets/section.dart';

class Currency extends StatelessWidget {
  const Currency({super.key});

  @override
  Widget build(BuildContext context) {
    return Section(
      title: "Currency (FR → US)",
      items: [
        SectionItem(
          label: "Code (small amount)",
          value: AppLocale.currency.convert(1, style: CurrencySymbolStyle.code),
        ),
        SectionItem(
          label: "Name (small amount)",
          value: AppLocale.currency.convert(1, style: CurrencySymbolStyle.name),
        ),
        SectionItem(
          label: "Symbol (small amount)",
          value: AppLocale.currency.convert(1, style: CurrencySymbolStyle.symbol),
        ),
        SectionItem(
          label: "Code (decimal amount)",
          value: AppLocale.currency.convert(10.50, style: CurrencySymbolStyle.code),
        ),
        SectionItem(
          label: "Name (decimal amount)",
          value: AppLocale.currency.convert(15.55, style: CurrencySymbolStyle.name),
        ),
        SectionItem(
          label: "Symbol (decimal amount)",
          value: AppLocale.currency.convert(19.99, style: CurrencySymbolStyle.symbol),
        ),
        SectionItem(
          label: "Symbol (compact – thousands)",
          value: AppLocale.currency.convert(
            1999.99,
            style: CurrencySymbolStyle.symbol,
            separator: CurrencySeparatorStyle.compact,
          ),
        ),
        SectionItem(
          label: "Symbol (compact – millions)",
          value: AppLocale.currency.convert(
            199999999.99,
            style: CurrencySymbolStyle.symbol,
            separator: CurrencySeparatorStyle.compact,
          ),
        ),
        SectionItem(
          label: "Symbol (compact – millions)",
          value: AppLocale.currency.convertWithExchange(
            199999999.99,
            style: CurrencySymbolStyle.symbol,
            separator: CurrencySeparatorStyle.compact,
          ),
        ),
        SectionItem(
          label: "Exchange (small amount – symbol)",
          value: AppLocale.currency.convertWithExchange(1, style: CurrencySymbolStyle.symbol),
        ),
        SectionItem(
          label: "Exchange (small amount – code)",
          value: AppLocale.currency.convertWithExchange(1, style: CurrencySymbolStyle.code),
        ),
        SectionItem(
          label: "Exchange (decimal amount – symbol)",
          value: AppLocale.currency.convertWithExchange(19.99, style: CurrencySymbolStyle.symbol),
        ),
        SectionItem(
          label: "Exchange (decimal amount – name)",
          value: AppLocale.currency.convertWithExchange(15.55, style: CurrencySymbolStyle.name),
        ),
        SectionItem(
          label: "Exchange (thousands – compact)",
          value: AppLocale.currency.convertWithExchange(
            1999.99,
            style: CurrencySymbolStyle.symbol,
            separator: CurrencySeparatorStyle.compact,
          ),
        ),
        SectionItem(
          label: "Exchange (millions – compact)",
          value: AppLocale.currency.convertWithExchange(
            199999999.99,
            style: CurrencySymbolStyle.symbol,
            separator: CurrencySeparatorStyle.compact,
          ),
        ),
      ],
    );
  }
}
