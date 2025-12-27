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

class Volume extends StatelessWidget {
  const Volume({super.key});

  @override
  Widget build(BuildContext context) {
    return Section(
      title: "Volume (FR → US)",
      items: [
        SectionItem(label: "Small volume", value: AppLocale.volume.format(1)),
        SectionItem(label: "Bottle size", value: AppLocale.volume.format(0.5)),
        SectionItem(
          label: "Large container",
          value: AppLocale.volume.format(10),
          // 10 L → 2.64 gal
        ),
        SectionItem(label: "With more precision", value: AppLocale.volume.format(2, fractionDigits: 3)),
        SectionItem(
          label: "Unit name style",
          value: AppLocale.volume.format(5, style: VolumeSymbolStyle.unit),
          // 1.32 Gallon
        ),
      ],
    );
  }
}
