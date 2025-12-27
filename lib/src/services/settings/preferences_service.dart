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

import 'dart:convert';

import 'package:injectable/injectable.dart';
import 'package:rxdart/subjects.dart';
import 'package:shared_preferences/shared_preferences.dart';

class _PreferencesConstants {
  static const String currency = "__fbs__currency";
}

@Singleton(order: -1)
/// A service that manages local persistent preferences using [SharedPreferences].
///
/// Provides typed access to stored values through the [Preference] abstraction,
/// allowing reactive state management via streams (`watch()`).
///
/// Preferences are used to persist application state across sessions,
/// such as finder configurations or temporary directory paths.
///
/// Example:
/// ```dart
/// final preferences = await PreferencesService.create();
/// final paths = preferences.componentUnits();
/// ```
class PreferencesService {
  late SharedPreferences _prefs;

  @FactoryMethod(preResolve: true)
  static Future<PreferencesService> create() async {
    final service = PreferencesService();
    service._prefs = await SharedPreferences.getInstance();
    return service;
  }

  late Preference<Map<String, double>> currency = Preference(this, _PreferencesConstants.currency, {});
}

/// Provides a strongly-typed wrapper around [SharedPreferences] entries,
/// with built-in support for reactive updates via [BehaviorSubject].
///
/// The [Preference] class abstracts away the boilerplate required to
/// read/write settings from shared preferences, and adds support for:
/// - Primitive types: `bool`, `int`, `double`, `String`, `List<String>`
/// - Advanced types: [Enum], [JsonClass]
/// - Stream-based reactivity using `watch()`
///
/// ### Example usage:
/// ```dart
/// final tempDirs = preferences.componentUnits();
/// await tempDirs.set(['/tmp/dir1', '/tmp/dir2']);
///
/// tempDirs.watch().listen((paths) {
///   print('Temporary paths updated: $paths');
/// });
/// ```
class Preference<T> {
  final PreferencesService _preferences;
  final String _key;
  late final T _defaultValue;

  late final _valueSubject = BehaviorSubject<T>.seeded(_fetch());

  Preference(this._preferences, this._key, this._defaultValue) {
    _valueSubject.add(call());
  }

  String get key => _key;

  T get defaultValue => _defaultValue;

  T call() => _valueSubject.value;

  T _fetch() {
    final savedValue = _preferences._prefs.get(key);

    if (savedValue is List<Object?>) {
      return savedValue.mapNotNull((e) => e?.cast<String>()) as T;
    }

    return savedValue is T ? savedValue : defaultValue;
  }

  Future<void> set(T value) async {
    if (value is! List<String> && value == call()) return;

    if (value == null) {
      await _preferences._prefs.remove(key);
    } else if (value is bool) {
      await _preferences._prefs.setBool(key, value);
    } else if (value is int) {
      await _preferences._prefs.setInt(key, value);
    } else if (value is double) {
      await _preferences._prefs.setDouble(key, value);
    } else if (value is String) {
      await _preferences._prefs.setString(key, value);
    } else if (value is List<String>) {
      await _preferences._prefs.setStringList(key, value);
    } else if (value is Enum) {
      await _preferences._prefs.setString(key, value.name);
    } else if (value is JsonClass) {
      final jsonString = jsonEncode(value);
      await _preferences._prefs.setString(key, jsonString);
    }

    _valueSubject.add(value);
  }

  Stream<T> watch() => _valueSubject.stream;

  void reset() => set(_defaultValue);
}

/// A specialized [Preference] for storing and retrieving enum values using their `name` string.
///
/// [PreferenceEnum] allows persisting enum instances in shared preferences
/// by storing their [Enum.name] string representation, and restoring them
/// using the static list of enum [values] provided.
///
/// ### Requirements:
/// - The enum must not override `toString()` in a way that hides `.name`.
/// - The [values] list must contain all enum cases, typically from `MyEnum.values`.
///
/// ### Example:
/// ```dart
/// final themePreference = PreferenceEnum<ThemeMode>(
///   preferences,
///   'theme_mode',
///   ThemeMode.values,
///   ThemeMode.light,
/// );
///
/// final theme = themePreference(); // ThemeMode.light, .dark, etc.
/// ```
///
/// ### Related:
/// - Uses `List<T>.asNameMap()` (from `collection` package or custom helper)
///   to convert a string back to its corresponding enum value.
class PreferenceEnum<T extends Enum> extends Preference<T> {
  final List<T> values;

  PreferenceEnum(super.prefs, super.key, this.values, super.defaultValue);

  @override
  T call() {
    final enumName = _preferences._prefs.getString(key);
    return values.asNameMap()[enumName] ?? defaultValue;
  }
}

/// A specialized [Preference] for storing and retrieving JSON-serializable objects
/// that implement the [JsonClass] interface.
///
/// [PreferenceJsonClass] allows persisting structured data in shared preferences
/// by encoding it as a JSON string. It requires a deserialization constructor
/// to recreate the object from the stored JSON.
///
/// ### Example:
/// ```dart
/// final userPreference = PreferenceJsonClass<User>(
///   preferences,
///   'user_data',
///   null,
///   (json) => User.fromJson(json),
/// );
///
/// final user = userPreference(); // Retrieves and deserializes User
/// ```
///
/// The generic type [T] must either:
/// - Extend [JsonClass], with a constructor to convert from `Map<String, dynamic>`, or
/// - Be `null` (nullable generic) to support optional values.
class PreferenceJsonClass<T extends JsonClass?> extends Preference<T> {
  final T Function(Map<String, dynamic> json)? constructor;

  PreferenceJsonClass(super.prefs, super.key, super.defaultValue, this.constructor);

  @override
  T call() {
    final jsonString = _preferences._prefs.getString(key);
    if (jsonString == null) {
      return defaultValue;
    }

    final json = jsonDecode(jsonString);
    return constructor != null ? constructor!(json as Map<String, dynamic>) : defaultValue;
  }
}

/// An abstract interface representing objects that can be serialized to and from JSON.
///
/// Classes that implement [JsonClass] must provide:
/// - A constructor that initializes an instance from a `Map<String, dynamic>`.
/// - A method [toJson] that converts the instance back into a JSON-compatible map.
///
/// This interface is commonly used in:
/// - Data models backed by REST APIs
/// - Storage layers using JSON (e.g. `shared_preferences`, local DBs)
/// - Message or network protocols
///
/// ### Example:
/// ```dart
/// class User extends JsonClass {
///   final String name;
///
///   User(Map<String, dynamic> json) : name = json['name'];
///
///   @override
///   Map<String, dynamic> toJson() => {'name': name};
/// }
/// ```
abstract class JsonClass {
  /// Constructs an instance from a JSON map.
  ///
  /// Implementations must extract values from the [json] map and initialize
  /// the fields of the object accordingly.
  ///
  /// This constructor is intended to be used like:
  /// ```dart
  /// final user = User(jsonMap);
  /// ```
  JsonClass(Map<String, dynamic> json);

  /// Converts the object into a JSON-compatible map.
  ///
  /// All returned values must be compatible with standard JSON types:
  /// `String`, `num`, `bool`, `null`, `List`, or `Map<String, dynamic>`.
  ///
  /// This method is typically used before:
  /// - Persisting the model to disk
  /// - Sending data over HTTP
  /// - Interacting with platform channels
  Map<String, dynamic> toJson();
}

/// Extension providing a safe casting utility on any object.
extension SafeCastExtension<T> on T {
  /// Attempts to cast the current value to type [R], returning `null` if the cast fails.
  ///
  /// This is a type-safe utility to avoid exceptions from invalid casts.
  /// It returns:
  /// - `this as R` if `this is R`,
  /// - otherwise `null`.
  ///
  /// ### Example:
  /// ```dart
  /// Object value = 'hello';
  /// String? str = value.cast<String>(); // 'hello'
  ///
  /// int? num = value.cast<int>(); // null, since 'hello' is not an int
  /// ```
  ///
  /// This extension is useful in dynamic or heterogeneous contexts, such as:
  /// - Working with maps or JSON
  /// - Handling loosely typed values (e.g. plugin APIs, platform channels)
  ///
  /// Returns:
  /// - The casted value if successful, otherwise `null`.
  R? cast<R>() => this is R ? this as R : null;
}

/// Extension providing utility methods on [Iterable].
extension ListExtension<E> on Iterable<E> {
  /// Maps each element of the iterable using [toElement], and filters out any `null` results.
  ///
  /// This is a shorthand for:
  /// ```dart
  /// iterable.map(toElement).whereType<T>().toList()
  /// ```
  ///
  /// It allows for cleaner mapping when the transform function may return `null`,
  /// and you only want to keep the non-null results.
  ///
  /// ### Example:
  /// ```dart
  /// final list = ['1', 'a', '3'];
  /// final numbers = list.mapNotNull((e) => int.tryParse(e));
  /// // numbers == [1, 3]
  /// ```
  ///
  /// - [T] is the non-nullable target type.
  /// - [toElement] is a mapping function returning `T?` for each element of type [E].
  ///
  /// Returns a `List<T>` containing only the successfully mapped non-null results.
  List<T> mapNotNull<T>(T? Function(E e) toElement) => map(toElement).whereType<T>().toList();
}
