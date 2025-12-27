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

class Temperature extends StatelessWidget {
  const Temperature({super.key});

  @override
  Widget build(BuildContext context) {
    return Section(
      title: "Temperature (FR → US)",
      items: [
        SectionItem(label: "Freezing point", value: AppLocale.temperature.format(0)),
        SectionItem(label: "Cold weather", value: AppLocale.temperature.format(5)),
        SectionItem(label: "Room temperature", value: AppLocale.temperature.format(20)),
        SectionItem(label: "Warm temperature", value: AppLocale.temperature.format(30)),
        SectionItem(label: "With decimals", value: AppLocale.temperature.format(21.567, fractionDigits: 1)),
        SectionItem(label: "With decimals (2 digits)", value: AppLocale.temperature.format(21.567, fractionDigits: 2)),
        SectionItem(label: "Negative temperature", value: AppLocale.temperature.format(-5)),
        SectionItem(label: "Extreme cold", value: AppLocale.temperature.format(-40)),
        SectionItem(
          label: "Unit name style",
          value: AppLocale.temperature.format(22, style: TemperatureSymbolStyle.unit),
        ),
      ],
    );
  }
}
