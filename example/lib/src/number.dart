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

class Number extends StatelessWidget {
  const Number({super.key});

  @override
  Widget build(BuildContext context) {
    return Section(
      title: "Number (FR → US)",
      items: [
        SectionItem(
          label: "Integer",
          value: AppLocale.number.format(1234),
          // 1,234
        ),
        SectionItem(
          label: "Decimal",
          value: AppLocale.number.format(1234.56),
          // 1,234.56
        ),
        SectionItem(
          label: "Fixed decimals",
          value: AppLocale.number.format(12.3, fractionDigits: 2),
          // 12.30
        ),
        SectionItem(
          label: "Negative number",
          value: AppLocale.number.format(-9876.54),
          // -9,876.54
        ),
        SectionItem(
          label: "Always signed",
          value: AppLocale.number.format(42, sign: NumberSignStyle.always),
          // +42
        ),
        SectionItem(
          label: "Compact (thousands)",
          value: AppLocale.number.format(1234, separator: NumberSeparatorStyle.compact),
          // 1.2K
        ),
        SectionItem(
          label: "Compact (millions)",
          value: AppLocale.number.format(1234567, separator: NumberSeparatorStyle.compact),
          // 1.2M
        ),
        SectionItem(
          label: "Percentage",
          value: AppLocale.number.percent(0.256, fractionDigits: 1),
          // 25.6%
        ),
      ],
    );
  }
}
