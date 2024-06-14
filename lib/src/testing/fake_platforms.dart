// Copyright (c) 2024, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:collection';
import 'dart:convert';

import 'package:meta/meta.dart';

import '../platforms_impl.dart';
import '../util/json_keys.dart' as json_key;
import 'zone_overrides.dart' as overrides;

/// Fake Dart runtime platform information.
///
/// Implements [Platform], but allows a [FakeBrowserPlatform] or
/// [FakeNativePlatform] to be the non-`null` platform object.
@visibleForTesting
final class FakePlatform extends PlatformTestBase {
  /// The current native platform, if running on a native platform.
  @override
  final NativePlatform? nativePlatform;

  /// The current browser platform, if running on a browser platform.
  @override
  final BrowserPlatform? browserPlatform;

  /// Whether currently running on a native platform.
  @override
  bool get isNative => nativePlatform != null;

  /// Whether currently running in a browser.
  @override
  bool get isBrowser => browserPlatform != null;

  /// A platform with the given [nativePlatform].
  ///
  /// Used by [FakeNativePlatform.run] to create a fake [Platform]
  /// with it as the [Platform.nativePlatform].
  const FakePlatform._native(NativePlatform this.nativePlatform)
      : browserPlatform = null;

  /// A platform with the given [browserPlatform].
  ///
  /// Used by [FakeBrowserPlatform.run] to create a fake [Platform]
  /// with it as the [Platform.browserPlatform].
  const FakePlatform._browser(BrowserPlatform this.browserPlatform)
      : nativePlatform = null;

  /// A platform with *none* of the native or browser platforms set.
  const FakePlatform.unknown()
      : nativePlatform = null,
        browserPlatform = null;

  /// Runs [fakePlatformCode] with this fake platform as the current platform.
  ///
  /// While [fakePlatformCode] is running, the [Platform.current] refers to this
  /// fake platform, which is likely the [FakePlatform.unknown] platform.
  ///
  /// Prior reads of [Platform.current] will retain their original value,
  /// so the `fakePlatformCode` should make sure to read [Platform.current]
  /// when it's needed, and avoid any caching.
  R run<R>(R Function() fakePlatformCode) =>
      overrides.runWith(fakePlatformCode, this, _OverrideMarker.marker);
}

/// Instance used to mark overrides as used.
enum _OverrideMarker implements overrides.OverrideMarker {
  marker;
}

/// Fake [BrowserPlatform] for testing.
@visibleForTesting
final class FakeBrowserPlatform extends BrowserPlatformTestBase {
  static const _className = 'FakeBrowserPlatform';

  final String? _version;
  final String? _userAgent;

  FakeBrowserPlatform({String? version, String? userAgent})
      : _version = version,
        _userAgent = userAgent;

  factory FakeBrowserPlatform.fromJson(String jsonText) {
    var json = jsonDecode(jsonText);
    if (json is! Map<String, Object?>) {
      throw FormatException('Not a JSON map', jsonText);
    }
    return FakeBrowserPlatform(
      version: _getJsonProperty<String>(json, json_key.version, jsonText),
      userAgent: _getJsonProperty<String>(json, json_key.userAgent, jsonText),
    );
  }

  factory FakeBrowserPlatform.fromPlatform(BrowserPlatform platform) {
    if (platform is FakeBrowserPlatform) {
      return platform.copyWith();
    }
    return FakeBrowserPlatform(
      version: platform.version,
      userAgent: platform.userAgent,
    );
  }

  FakeBrowserPlatform copyWith({
    String? version,
    String? userAgent,
  }) =>
      FakeBrowserPlatform(
        version: version ?? _version,
        userAgent: userAgent ?? _userAgent,
      );

  /// Runs [fakePlatformCode] with this as the current browser platform.
  ///
  /// While [fakePlatformCode] is running, the [Platform.browserPlatform]
  /// of [Platform.current] refers to this [FakeBrowserPlatform].
  ///
  /// Prior reads of [Platform.current] will retain their original value,
  /// so the `fakePlatformCode` should make sure to read [Platform.current]
  /// when it's needed, and avoid any caching.
  R run<R>(R Function() fakePlatformCode) => overrides.runWith(
      fakePlatformCode, FakePlatform._browser(this), _OverrideMarker.marker);

  @override
  String toJson() => const JsonEncoder.withIndent('  ').convert({
        if (_version != null) json_key.version: _version,
        if (_userAgent != null) json_key.userAgent: _userAgent,
      });

  @override
  String get userAgent =>
      _throwIfUnset(_userAgent, _className, json_key.userAgent);

  @override
  String get version => _throwIfUnset(_version, _className, json_key.version);
}

/// A fake [NativePlatform] for testing.
///
/// The individual properties can be left unset by the constructors.
/// Accessing such properties will throw, but a test which doesn't use
/// those properties doesn't have to provide values for them.
///
/// This class should not be used in production, since it reduces the
/// compiler's ability to predict the values of the
/// [NativePlatform.operatingSystem] or, for example, [NativePlatform.isLinux]
/// checks, which can lead to larger compiled programs.
@visibleForTesting
final class FakeNativePlatform extends NativePlatformTestBase {
  static const String _className = 'FakeNativePlatform';

  /// Operating system ID string, or `null` if not configured.
  ///
  /// Use one of the [NativePlatform.android] through [NativePlatform.windows]
  /// constants.
  final String? _operatingSystem;
  final String? _operatingSystemVersion;
  final Map<String, String>? _environment;
  final String? _executable;
  final List<String>? _executableArguments;
  final String? _lineTerminator;
  final String? _localeName;
  final String? _localHostname;
  final int? _numberOfProcessors;
  final String? _pathSeparator;
  @override
  final String? packageConfig;
  final String? _resolvedExecutable;
  final Uri? _script;
  final bool? _stdinSupportsAnsi;
  final bool? _stdoutSupportsAnsi;
  final String? _version;

  /// Creates a new [FakeNativePlatform] with the specified properties.
  ///
  /// Parameters that are not provided with a non-`null` value
  /// will leave the corresponding property without a value.
  ///
  /// Reading, for example, [FakeNativePlatform.operatingSystem]
  /// when it had not been given a value, will throw an error.
  /// This behavior can be used in tests to ensure that code does not
  /// read properties that it is not supposed to.
  ///
  /// The [operatingSystem] string must be one of the known operating system
  /// ID strings in [NativePlatform.operatingSystemValues].
  FakeNativePlatform({
    Map<String, String>? environment,
    String? executable,
    List<String>? executableArguments,
    String? lineTerminator,
    String? localeName,
    String? localHostname,
    int? numberOfProcessors,
    String? operatingSystem,
    String? operatingSystemVersion,
    this.packageConfig,
    String? pathSeparator,
    String? resolvedExecutable,
    Uri? script,
    bool? stdinSupportsAnsi,
    bool? stdoutSupportsAnsi,
    String? version,
  })  : _environment = environment == null
            ? null
            : operatingSystem == NativePlatform.windows
                ? (_caseInsensitiveMap()..addAll(environment))
                : environment,
        _executable = executable,
        _executableArguments = executableArguments,
        _lineTerminator = lineTerminator,
        _localeName = localeName,
        _localHostname = localHostname,
        _numberOfProcessors = numberOfProcessors,
        _operatingSystem = operatingSystem,
        _operatingSystemVersion = operatingSystemVersion,
        _pathSeparator = pathSeparator,
        _resolvedExecutable = resolvedExecutable,
        _script = script,
        _stdinSupportsAnsi = stdinSupportsAnsi,
        _stdoutSupportsAnsi = stdoutSupportsAnsi,
        _version = version;

  /// Creates a new [FakeNativePlatform] with properties from a JSON string.
  ///
  /// The [jsonText] must be a valid JSON string representing a JSON object,
  /// and the values for the [NativePlatform] properties are extracted from
  /// the object's values for keys with the properties names.
  ///
  /// Example:
  /// ```dart
  /// var fake = FakeNativePlatform.fromJson('''{
  ///   "operatingSystem": "linux",
  ///   "operatingSystemVersion": "fakeVersion.2.3",
  ///   "numberOfProcessors": 42,
  ///   "lineTerminator": "\r",
  ///   "packageConfig": null
  /// }''')'
  /// ```
  /// The JSON object's value for such a keys must be either a string or `null`.
  ///
  /// Throws a [FormatException] if the [jsonText] string is not valid
  /// JSON text, or the JSON text does not represent a JSON object.
  /// The property values must have the correct type for the corresponding
  /// [NativePlatform] property, or be `null`.
  /// If the map value of a property key is not a string, integer, boolean,
  /// list of strings, or map with string keys and values,
  /// as required by the corresponding property,
  /// a [FormatException] is also thrown.
  ///
  /// Other keys are ignored. Missing property keys,
  /// or keys with a `null` value, leave the property undefined.
  ///
  /// The [toJson] method will leave out undefined properties, so
  /// `FakeNativePlatform.fromJson(fakeNativePlatform.toJson())` can create
  /// an exact copy at a later time.
  /// (To create a copy _right now_, `fakeNativePlatform.copyWith()`
  /// is easier and more efficient.)
  factory FakeNativePlatform.fromJson(String jsonText) {
    Object? jsonObject = jsonDecode(jsonText);
    if (jsonObject is! Map<String, Object?>) {
      throw FormatException('Not a JSON object', jsonText);
    }

    // Read out the values that require special validation first.
    var environment = _getJsonProperty<Map<String, Object?>>(
        jsonObject, json_key.environment, jsonText);
    var executableArguments = _getJsonProperty<List<Object?>>(
        jsonObject, json_key.executableArguments, jsonText);
    var script = _getJsonProperty<String>(jsonObject, 'script', jsonText);

    return FakeNativePlatform(
      // Check that environment values are strings. Filter out null values.
      environment: environment == null
          ? null
          : <String, String>{
              for (var MapEntry(:key, :value) in environment.entries)
                if (value != null)
                  key: (value is String
                      ? value
                      : _failJsonParse<String>(
                          'environment[$key]', value, jsonText))
            },
      executable:
          _getJsonProperty<String>(jsonObject, json_key.executable, jsonText),
      // Check the executable arguments are strings.
      executableArguments: executableArguments == null
          ? null
          : <String>[
              for (var argument in executableArguments)
                argument is String
                    ? argument
                    : _failJsonParse<String>(
                        'executableArguments', argument, jsonText)
            ],
      lineTerminator: _getJsonProperty<String>(
          jsonObject, json_key.lineTerminator, jsonText),
      localeName:
          _getJsonProperty<String>(jsonObject, json_key.localeName, jsonText),
      localHostname: _getJsonProperty<String>(
          jsonObject, json_key.localHostname, jsonText),
      numberOfProcessors: _getJsonProperty<int>(
          jsonObject, json_key.numberOfProcessors, jsonText),
      operatingSystem: _getJsonProperty<String>(
          jsonObject, json_key.operatingSystem, jsonText),
      operatingSystemVersion: _getJsonProperty<String>(
          jsonObject, json_key.operatingSystemVersion, jsonText),
      packageConfig: _getJsonProperty<String>(
          jsonObject, json_key.packageConfig, jsonText),
      pathSeparator: _getJsonProperty<String>(
          jsonObject, json_key.pathSeparator, jsonText),
      resolvedExecutable: _getJsonProperty<String>(
          jsonObject, json_key.resolvedExecutable, jsonText),
      // Checks that the script is a valid URI.
      script: script == null ? null : Uri.parse(script),
      stdinSupportsAnsi: _getJsonProperty<bool>(
          jsonObject, json_key.stdinSupportsAnsi, jsonText),
      stdoutSupportsAnsi: _getJsonProperty<bool>(
          jsonObject, json_key.stdoutSupportsAnsi, jsonText),
      version: _getJsonProperty<String>(jsonObject, json_key.version, jsonText),
    );
  }

  /// Creates a new [FakeNativePlatform] with the properties of [platform].
  factory FakeNativePlatform.fromPlatform(NativePlatform platform) =>
      platform is FakeNativePlatform // Values may be unset.
          ? platform.copyWith()
          : FakeNativePlatform(
              environment: <String, String>{...platform.environment},
              executable: platform.executable,
              executableArguments: List.of(platform.executableArguments),
              lineTerminator: platform.lineTerminator,
              localeName: platform.localeName,
              localHostname: platform.localHostname,
              numberOfProcessors: platform.numberOfProcessors,
              operatingSystem: platform.operatingSystem,
              operatingSystemVersion: platform.operatingSystemVersion,
              packageConfig: platform.packageConfig,
              pathSeparator: platform.pathSeparator,
              resolvedExecutable: platform.resolvedExecutable,
              script: platform.script,
              stdinSupportsAnsi: platform.stdinSupportsAnsi,
              stdoutSupportsAnsi: platform.stdoutSupportsAnsi,
              version: platform.version,
            );

  /// Whether the operating system is Android.
  @override
  bool get isAndroid => operatingSystem == NativePlatform.android;

  /// Whether the operating system is Fuchsia.
  @override
  bool get isFuchsia => operatingSystem == NativePlatform.fuchsia;

  /// Whether the operating system is iOS.
  @override
  bool get isIOS => operatingSystem == NativePlatform.iOS;

  /// Whether the operating system is Linux.
  @override
  bool get isLinux => operatingSystem == NativePlatform.linux;

  /// Whether the operating system is OS X.
  @override
  bool get isMacOS => operatingSystem == NativePlatform.macOS;

  /// Whether the operating system is Windows.
  @override
  bool get isWindows => operatingSystem == NativePlatform.windows;

  @override
  String get operatingSystem =>
      _throwIfUnset(_operatingSystem, _className, json_key.operatingSystem);

  @override
  String get operatingSystemVersion => _throwIfUnset(
      _operatingSystemVersion, _className, json_key.operatingSystemVersion);

  @override
  Map<String, String> get environment =>
      _throwIfUnset(_environment, _className, json_key.environment);

  @override
  String get executable =>
      _throwIfUnset(_executable, _className, json_key.executable);

  @override
  List<String> get executableArguments => _throwIfUnset<List<String>>(
      _executableArguments, _className, json_key.executableArguments);

  @override
  String get lineTerminator =>
      _throwIfUnset(_lineTerminator, _className, json_key.lineTerminator);

  @override
  String get localeName =>
      _throwIfUnset(_localeName, _className, json_key.localeName);

  @override
  String get localHostname =>
      _throwIfUnset(_localHostname, _className, json_key.localHostname);

  @override
  int get numberOfProcessors => _throwIfUnset(
      _numberOfProcessors, _className, json_key.numberOfProcessors);

  @override
  String get pathSeparator =>
      _throwIfUnset(_pathSeparator, _className, json_key.pathSeparator);

  @override
  String get resolvedExecutable => _throwIfUnset(
      _resolvedExecutable, _className, json_key.resolvedExecutable);

  @override
  Uri get script => _throwIfUnset(_script, _className, json_key.script);

  @override
  bool get stdinSupportsAnsi =>
      _throwIfUnset(_stdinSupportsAnsi, _className, json_key.stdinSupportsAnsi);

  @override
  bool get stdoutSupportsAnsi => _throwIfUnset(
      _stdoutSupportsAnsi, _className, json_key.stdoutSupportsAnsi);

  @override
  String get version => _throwIfUnset(_version, _className, json_key.version);

  /// Creates a new [FakeNativePlatform] from this one.
  ///
  /// If a parameter is given non-`null` argument value,
  /// the created object will have that value for the corresponding property,
  /// otherwise it will use this object's value of that property.
  FakeNativePlatform copyWith({
    Map<String, String>? environment,
    String? executable,
    List<String>? executableArguments,
    String? lineTerminator,
    String? localeName,
    String? localHostname,
    int? numberOfProcessors,
    String? operatingSystem,
    String? operatingSystemVersion,
    String? packageConfig,
    String? pathSeparator,
    String? resolvedExecutable,
    Uri? script,
    bool? stdinSupportsAnsi,
    bool? stdoutSupportsAnsi,
    String? version,
  }) {
    return FakeNativePlatform(
      environment: environment ??
          (_environment == null ? null : <String, String>{..._environment}),
      executable: executable ?? _executable,
      executableArguments:
          (executableArguments ?? _executableArguments)?.toList(),
      lineTerminator: lineTerminator ?? _lineTerminator,
      localeName: localeName ?? _localeName,
      localHostname: localHostname ?? _localHostname,
      numberOfProcessors: numberOfProcessors ?? _numberOfProcessors,
      operatingSystem: operatingSystem ?? _operatingSystem,
      operatingSystemVersion: operatingSystemVersion ?? _operatingSystemVersion,
      packageConfig: packageConfig ?? this.packageConfig,
      pathSeparator: pathSeparator ?? _pathSeparator,
      resolvedExecutable: resolvedExecutable ?? _resolvedExecutable,
      script: script ?? _script,
      stdinSupportsAnsi: stdinSupportsAnsi ?? _stdinSupportsAnsi,
      stdoutSupportsAnsi: stdoutSupportsAnsi ?? _stdoutSupportsAnsi,
      version: version ?? _version,
    );
  }

  /// Runs [fakePlatformCode] with this native platform as current platform.
  ///
  /// If [fakePlatformCode] reads [Platform.current], it gets a platform object
  /// whose [Platform.nativePlatform] is this fake native platform.
  R run<R>(R Function() fakePlatformCode) => overrides.runWith(
      fakePlatformCode, FakePlatform._native(this), _OverrideMarker.marker);

  /// Wraps [withOverride] to run it with this fake native platform as current.
  ///
  /// The returned function runs [withOverride] through [run] every time it's
  /// called, to ensure all the calls will see the same override.
  R Function() bind<R>(R Function() withOverride) => () => run(withOverride);

  /// A JSON-encoded representation of this platform configuration.
  ///
  /// Unset values are not included.
  ///
  /// Can be parsed back by [FakeNativePlatform.fromJson].
  @override
  String toJson() {
    return const JsonEncoder.withIndent('  ').convert(<String, dynamic>{
      if (_environment != null) json_key.environment: _environment,
      if (_executable != null) json_key.executable: _executable,
      if (_executableArguments != null)
        json_key.executableArguments: _executableArguments,
      if (_lineTerminator != null) json_key.lineTerminator: _lineTerminator,
      if (_localeName != null) json_key.localeName: _localeName,
      if (_localHostname != null) json_key.localHostname: _localHostname,
      if (_numberOfProcessors != null)
        json_key.numberOfProcessors: _numberOfProcessors,
      if (_operatingSystem != null) json_key.operatingSystem: _operatingSystem,
      if (_operatingSystemVersion != null)
        json_key.operatingSystemVersion: _operatingSystemVersion,
      if (packageConfig != null) json_key.packageConfig: packageConfig,
      if (_pathSeparator != null) json_key.pathSeparator: _pathSeparator,
      if (_resolvedExecutable != null)
        json_key.resolvedExecutable: _resolvedExecutable,
      if (_script != null) json_key.script: _script.toString(),
      if (_stdinSupportsAnsi != null)
        json_key.stdinSupportsAnsi: _stdinSupportsAnsi,
      if (_stdoutSupportsAnsi != null)
        json_key.stdoutSupportsAnsi: _stdoutSupportsAnsi,
      if (_version != null) json_key.version: _version,
    });
  }
}

Never _failJsonParse<T>(String property, Object? value, String? source) {
  throw FormatException('Property "$property" is not a $T: $value', source);
}

T? _getJsonProperty<T extends Object>(
    Map<String, Object?> jsonMap, String property, String? source) {
  var value = jsonMap[property];
  if (value is T?) return value;
  _failJsonParse<T>(property, value, source);
}

T _throwIfUnset<T>(T? value, String className, String name) {
  if (value == null) {
    throw StateError('$className.$name property is unset');
  }
  return value;
}

/// A simple inefficient case-insensitive map.
///
/// Used by [FakeNativePlatform.environment] when the (possibly fake)
/// operating system is [NativePlatform.windows].
Map<String, String> _caseInsensitiveMap() => HashMap<String, String>(
    equals: (String a, String b) =>
        a == b || a.toLowerCase() == b.toLowerCase(),
    hashCode: (String a) => a.toLowerCase().hashCode);
