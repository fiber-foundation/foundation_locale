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

import 'dart:async';

import 'package:http/http.dart' as http;
import 'package:injectable/injectable.dart';
import 'package:rxdart/subjects.dart';
import 'package:xml/xml.dart';

import '../device/network_service.dart';
import '../settings/preferences_service.dart';

const _ecbUrl = 'https://www.ecb.europa.eu/stats/eurofxref/eurofxref-daily.xml';

/// {@template currency_service}
/// Public service contract for accessing and converting **currency exchange rates**.
///
/// This service exposes:
/// - the latest known exchange rates as a read-only map,
/// - a deterministic conversion method between two currencies.
///
/// Rates are expected to be expressed relative to a **common reference
/// currency** (typically EUR), but the contract does not mandate a specific
/// source or update strategy.
///
/// Implementations are responsible for:
/// - fetching and refreshing exchange rates,
/// - persisting them if necessary,
/// - ensuring consistency of the exposed values.
///
/// Consumers should treat this service as the **single source of truth**
/// for currency conversion within the application.
/// {@endtemplate}
abstract class CurrencyService {
  /// Returns the **current exchange rates** indexed by currency code.
  ///
  /// The returned map uses **ISO 4217 currency codes** (e.g. `EUR`, `USD`, `GBP`)
  /// as keys and their corresponding exchange rate as values.
  ///
  /// Rates must all share the same base currency. A value of `1.0` therefore
  /// represents the base currency itself.
  ///
  /// The map is read-only from the consumer perspective and reflects the
  /// latest known state. It may be empty if no rates have been loaded yet.
  Map<String, double> get values;

  /// Converts a monetary [amount] from one currency to another.
  ///
  /// - [amount] is the value to convert.
  /// - [from] is the source currency code (ISO 4217).
  /// - [to] is the target currency code (ISO 4217).
  ///
  /// The conversion is performed using the exchange rates exposed by [values].
  /// If the source and target currencies are identical, the original [amount]
  /// is returned unchanged.
  ///
  /// Implementations should assume that missing currency codes fall back
  /// to the base currency rate when appropriate.
  double? convert({required double amount, required String from, required String to});
}

@Singleton(as: CurrencyService)
class CurrencyServiceImpl implements CurrencyService {
  final PreferencesService _preferences;
  final NetworkService network;

  CurrencyServiceImpl(this._preferences, this.network);

  final _currencySubject = BehaviorSubject<Map<String, double>>.seeded({});

  @override
  Map<String, double> get values => _currencySubject.value;

  @override
  double? convert({required double amount, required String from, required String to}) {
    from = from.toUpperCase();
    to = to.toUpperCase();

    if (from == to) return amount;
    if (values.isEmpty) return null;

    final fromRate = values[from] ?? 1.0;
    final toRate = values[to] ?? 1.0;

    return amount / fromRate * toRate;
  }

  @PostConstruct()
  init() async {
    listenCurrency();
    getExchangeRate();
  }

  StreamSubscription<bool>? _isReachableSub;
}

extension on CurrencyServiceImpl {
  void listenCurrency() {
    _preferences.currency.watch().listen((currency) => _currencySubject.value = currency);
  }

  void getExchangeRate() {
    _isReachableSub = network.dataStream.distinct().listen((isReachable) {
      if (isReachable) {
        _isReachableSub?.cancel();
        _isReachableSub = null;

        try {
          _fetchEcbRates().then((rates) {
            if (rates.isNotEmpty) {
              _preferences.currency.set(rates);
            }
          });
        } catch (_) {}
      }
    });
  }

  Future<Map<String, double>> _fetchEcbRates() async {
    final response = await http.get(Uri.parse(_ecbUrl));
    if (response.statusCode != 200) {
      throw Exception('ECB fetch failed');
    }
    return _parseEcbXml(response.body);
  }

  Map<String, double> _parseEcbXml(String xmlString) {
    final document = XmlDocument.parse(xmlString);
    final rates = <String, double>{'EUR': 1.0};
    final cubes = document.findAllElements('Cube');

    for (final cube in cubes) {
      final currency = cube.getAttribute('currency');
      final rate = cube.getAttribute('rate');

      if (currency != null && rate != null) {
        rates[currency] = double.parse(rate);
      }
    }
    return rates;
  }
}
