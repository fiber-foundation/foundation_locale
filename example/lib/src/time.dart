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

class Time extends StatelessWidget {
  const Time({super.key});

  @override
  Widget build(BuildContext context) {
    return Section(
      title: "Time (FR → US)",
      items: [
        SectionItem(label: "Midnight", value: AppLocale.time.format(FoundationTime(hour: 0, minute: 0))),
        SectionItem(label: "Early morning", value: AppLocale.time.format(FoundationTime(hour: 6, minute: 30))),
        SectionItem(label: "Morning", value: AppLocale.time.format(FoundationTime(hour: 9, minute: 15))),
        SectionItem(label: "Noon", value: AppLocale.time.format(FoundationTime(hour: 12, minute: 0))),
        SectionItem(label: "Afternoon", value: AppLocale.time.format(FoundationTime(hour: 15, minute: 45))),
        SectionItem(label: "Evening", value: AppLocale.time.format(FoundationTime(hour: 20, minute: 10))),
        SectionItem(
          label: "With seconds",
          value: AppLocale.time.format(FoundationTime(hour: 14, minute: 5, second: 32)),
        ),
        SectionItem(label: "Edge case (23:59)", value: AppLocale.time.format(FoundationTime(hour: 23, minute: 59))),
      ],
    );
  }
}
