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

import 'package:injectable/injectable.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:rxdart/subjects.dart';

/// {@template network_service}
/// Public service contract for observing the application's **network reachability**.
///
/// This interface exposes the current connectivity state as a
/// **read-only reactive value**, allowing consumers to:
/// - synchronously check whether the network is currently reachable,
/// - react to connectivity changes in real time.
///
/// The service represents **reachability**, not network quality or speed.
/// A value of `true` indicates that network access is available, while
/// `false` indicates that the application should consider itself offline.
///
/// Consumers must treat this service as the single source of truth for
/// network availability and should rely exclusively on the exposed API
/// for observation.
///
/// Typical usage:
/// ```dart
/// final network = networkService.data;
///
/// if (!network.value) {
///   // Handle offline state
/// }
///
/// network.stream.listen((reachable) {
///   if (reachable) {
///     // Resume network-dependent operations
///   }
/// });
/// ```
///
/// This contract does not prescribe how connectivity is detected.
/// Implementation details are intentionally left undefined.
///
/// {@endtemplate}
abstract class NetworkService {
  /// Returns the **current network reachability state**.
  ///
  /// This getter provides a synchronous snapshot of whether the application
  /// currently has network access.
  ///
  /// - `true` indicates that the network is reachable.
  /// - `false` indicates that the application should be considered offline.
  ///
  /// This value reflects the **latest known state** and does not actively
  /// trigger network checks. Consumers should use it for immediate decisions
  /// (e.g. guarding a request) and rely on [dataStream] for continuous
  /// observation of connectivity changes.
  bool get data;

  /// A **reactive stream of network reachability updates**.
  ///
  /// This stream emits a new boolean value each time the network availability
  /// changes:
  ///
  /// - `true` when network access becomes available,
  /// - `false` when the application loses network connectivity.
  ///
  /// The stream is intended for long-lived listeners that need to react
  /// in real time to connectivity changes, such as retrying pending operations,
  /// pausing network-dependent tasks, or updating UI state.
  ///
  /// Implementations should guarantee that emitted values are consistent
  /// with [data] and represent the same source of truth.
  Stream<bool> get dataStream;
}

/// the latest network status and broadcasts updates through a stream.
@Singleton(as: NetworkService, order: -1)
class NetworkServiceImpl implements NetworkService {
  final _isReachableSubject = BehaviorSubject<bool>.seeded(true);

  @override
  bool get data => _isReachableSubject.value;

  @override
  Stream<bool> get dataStream => _isReachableSubject.stream;

  @PostConstruct()
  void init() async {
    listenToNetwork();
  }
}

extension on NetworkServiceImpl {
  void listenToNetwork() async {
    final hasConnection = await InternetConnection().hasInternetAccess;
    _isReachableSubject.value = hasConnection;

    InternetConnection().onStatusChange.distinct().listen((dataConnectionStatus) {
      final isReachable = dataConnectionStatus == InternetStatus.connected;

      if (data == isReachable) return;

      _isReachableSubject.value = dataConnectionStatus == InternetStatus.connected;
    });
  }
}
