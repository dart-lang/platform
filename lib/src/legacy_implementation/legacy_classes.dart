// Copyright (c) 2024, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

// ignore_for_file: deprecated_member_use_from_same_package

@Deprecated('Import package:platform/testing.dart for testing')
library;

import 'dart:convert' show JsonDecoder, JsonEncoder;

import '../platforms_impl.dart'
    show BrowserPlatform, NativePlatform, Platform, PlatformTestBase;

// Not showing `lineTerminator` which wasn't used in the legacy code.
import '../util/json_keys.dart' as json_key
    show
        environment,
        executable,
        executableArguments,
        localHostname,
        localeName,
        numberOfProcessors,
        operatingSystem,
        operatingSystemVersion,
        packageConfig,
        pathSeparator,
        resolvedExecutable,
        script,
        stdinSupportsAnsi,
        stdoutSupportsAnsi,
        version;

/// Provides a mutable implementation of the [Platform] interface.
///
/// [!WARNING]
/// Use `package:platform/testing.dart` for testing
/// the non-deprecated API, and use `FakeNativePlatform` to
/// fake these properties.
@Deprecated('Use FakeNativePlatform instead')
typedef FakePlatform = LegacyFakePlatform;

/// Provides a mutable implementation of the [Platform] interface.
///
/// [!WARNING]
/// Use `package:platform/testing.dart` for testing
/// the non-deprecated API, and use `FakeNativePlatform` to
/// fake these properties.
@Deprecated('Use FakeNativePlatform instead')
final class LegacyFakePlatform extends PlatformTestBase {
  int? _numberOfProcessors;
  String? _pathSeparator;
  String? _operatingSystem;
  String? _operatingSystemVersion;
  String? _localHostname;
  Map<String, String>? _environment;
  String? _executable;
  String? _resolvedExecutable;
  Uri? _script;
  List<String>? _executableArguments;
  String? _version;
  bool? _stdinSupportsAnsi;
  bool? _stdoutSupportsAnsi;
  String? _localeName;
  @override
  String? packageConfig;

  /// Creates a new legacy [FakePlatform] with the specified properties.
  ///
  /// Unspecified properties will *not* be assigned default values (they will
  /// remain `null`). If an unset non-null value is read, a [StateError] will
  /// be thrown instead of returning `null`.
  LegacyFakePlatform({
    int? numberOfProcessors,
    String? pathSeparator,
    String? operatingSystem,
    String? operatingSystemVersion,
    String? localHostname,
    Map<String, String>? environment,
    String? executable,
    String? resolvedExecutable,
    Uri? script,
    List<String>? executableArguments,
    this.packageConfig,
    String? version,
    bool? stdinSupportsAnsi,
    bool? stdoutSupportsAnsi,
    String? localeName,
  })  : _numberOfProcessors = numberOfProcessors,
        _pathSeparator = pathSeparator,
        _operatingSystem = operatingSystem,
        _operatingSystemVersion = operatingSystemVersion,
        _localHostname = localHostname,
        _environment = environment,
        _executable = executable,
        _resolvedExecutable = resolvedExecutable,
        _script = script,
        _executableArguments = executableArguments,
        _version = version,
        _stdinSupportsAnsi = stdinSupportsAnsi,
        _stdoutSupportsAnsi = stdoutSupportsAnsi,
        _localeName = localeName;

  /// Creates a new [FakePlatform] with properties extracted from the encoded
  /// JSON string.
  ///
  /// [json] must be a JSON string that matches the encoding produced by
  /// [toJson].
  factory LegacyFakePlatform.fromJson(String json) {
    final map = const JsonDecoder().convert(json) as Map<String, dynamic>;
    return LegacyFakePlatform(
      numberOfProcessors: map[json_key.numberOfProcessors] as int?,
      pathSeparator: map[json_key.pathSeparator] as String?,
      operatingSystem: map[json_key.operatingSystem] as String?,
      operatingSystemVersion: map[json_key.operatingSystemVersion] as String?,
      localHostname: map[json_key.localHostname] as String?,
      environment: (map[json_key.environment] as Map<Object?, Object?>)
          .cast<String, String>(),
      executable: map[json_key.executable] as String?,
      resolvedExecutable: map[json_key.resolvedExecutable] as String?,
      script: Uri.parse(map[json_key.script] as String),
      executableArguments:
          (map[json_key.executableArguments] as List<Object?>).cast<String>(),
      packageConfig: map[json_key.packageConfig] as String?,
      version: map[json_key.version] as String?,
      stdinSupportsAnsi: map[json_key.stdinSupportsAnsi] as bool?,
      stdoutSupportsAnsi: map[json_key.stdoutSupportsAnsi] as bool?,
      localeName: map[json_key.localeName] as String?,
    );
  }

  /// Creates a new [FakePlatform] with properties whose initial values mirror
  /// the specified [platform].
  LegacyFakePlatform.fromPlatform(Platform platform)
      : _numberOfProcessors = platform.numberOfProcessors,
        _pathSeparator = platform.pathSeparator,
        _operatingSystem = platform.operatingSystem,
        _operatingSystemVersion = platform.operatingSystemVersion,
        _localHostname = platform.localHostname,
        _environment = Map<String, String>.from(platform.environment),
        _executable = platform.executable,
        _resolvedExecutable = platform.resolvedExecutable,
        _script = platform.script,
        _executableArguments = List<String>.from(platform.executableArguments),
        packageConfig = platform.packageConfig,
        _version = platform.version,
        _stdinSupportsAnsi = platform.stdinSupportsAnsi,
        _stdoutSupportsAnsi = platform.stdoutSupportsAnsi,
        _localeName = platform.localeName;

  @override
  Map<String, String> get environment => _throwIfNull(_environment);

  @override
  String get executable => _throwIfNull(_executable);

  @override
  List<String> get executableArguments => _throwIfNull(_executableArguments);

  @override
  String get localeName => _throwIfNull(_localeName);

  @override
  String get localHostname => _throwIfNull(_localHostname);

  @override
  int get numberOfProcessors => _throwIfNull(_numberOfProcessors);

  @override
  String get operatingSystem => _throwIfNull(_operatingSystem);

  @override
  String get operatingSystemVersion => _throwIfNull(_operatingSystemVersion);

  @override
  String get pathSeparator => _throwIfNull(_pathSeparator);

  @override
  String get resolvedExecutable => _throwIfNull(_resolvedExecutable);

  @override
  Uri get script => _throwIfNull(_script);

  @override
  bool get stdinSupportsAnsi => _throwIfNull(_stdinSupportsAnsi);

  @override
  bool get stdoutSupportsAnsi => _throwIfNull(_stdoutSupportsAnsi);

  @override
  String get version => _throwIfNull(_version);

  /// Creates a new [FakePlatform] from this one,
  /// with some properties replaced by the given properties.
  @Deprecated('Use NativePlatform.copyWith instead')
  FakePlatform copyWith({
    int? numberOfProcessors,
    String? pathSeparator,
    String? operatingSystem,
    String? operatingSystemVersion,
    String? localHostname,
    Map<String, String>? environment,
    String? executable,
    String? resolvedExecutable,
    Uri? script,
    List<String>? executableArguments,
    String? packageConfig,
    String? version,
    bool? stdinSupportsAnsi,
    bool? stdoutSupportsAnsi,
    String? localeName,
  }) {
    return LegacyFakePlatform(
      numberOfProcessors: numberOfProcessors ?? this.numberOfProcessors,
      pathSeparator: pathSeparator ?? this.pathSeparator,
      operatingSystem: operatingSystem ?? this.operatingSystem,
      operatingSystemVersion:
          operatingSystemVersion ?? this.operatingSystemVersion,
      localHostname: localHostname ?? this.localHostname,
      environment: environment ?? this.environment,
      executable: executable ?? this.executable,
      resolvedExecutable: resolvedExecutable ?? this.resolvedExecutable,
      script: script ?? this.script,
      executableArguments: executableArguments ?? this.executableArguments,
      packageConfig: packageConfig ?? this.packageConfig,
      version: version ?? this.version,
      stdinSupportsAnsi: stdinSupportsAnsi ?? this.stdinSupportsAnsi,
      stdoutSupportsAnsi: stdoutSupportsAnsi ?? this.stdoutSupportsAnsi,
      localeName: localeName ?? this.localeName,
    );
  }

  @override
  String toJson() {
    return const JsonEncoder.withIndent('  ').convert(<String, dynamic>{
      json_key.numberOfProcessors: numberOfProcessors,
      json_key.pathSeparator: pathSeparator,
      json_key.operatingSystem: operatingSystem,
      json_key.operatingSystemVersion: operatingSystemVersion,
      json_key.localHostname: localHostname,
      json_key.environment: environment,
      json_key.executable: executable,
      json_key.resolvedExecutable: resolvedExecutable,
      json_key.script: script.toString(),
      json_key.executableArguments: executableArguments,
      json_key.packageConfig: packageConfig,
      json_key.version: version,
      json_key.stdinSupportsAnsi: stdinSupportsAnsi,
      json_key.stdoutSupportsAnsi: stdoutSupportsAnsi,
      json_key.localeName: localeName,
    });
  } // New API on a legacy class. It works, but use the new API instead.

  T _throwIfNull<T>(T? value) {
    if (value == null) {
      throw StateError(
          'Tried to read property of FakePlatform but it was unset.');
    }
    return value;
  }
}

@Deprecated('Use Platform.current.nativePlatform! instead')
final class LocalPlatform extends PlatformTestBase {
  static const _instance = LocalPlatform._();
  @Deprecated('Use Platform.current.nativePlatform! instead')
  const factory LocalPlatform() = _LocalPlatformInstance;

  const LocalPlatform._();

  @Deprecated('Use Platform.current.browserPlatform instead')
  @override
  BrowserPlatform? get browserPlatform;

  @override
  @Deprecated('Use Platform.current.nativePlatform!.environment instead')
  Map<String, String> get environment =>
      Platform.current.nativePlatform!.environment;

  @override
  @Deprecated('Use Platform.current.nativePlatform!.executable instead')
  String get executable => Platform.current.nativePlatform!.executable;

  @override
  @Deprecated(
      'Use Platform.current.nativePlatform!.executableArguments instead')
  List<String> get executableArguments =>
      Platform.current.nativePlatform!.executableArguments;

  @Deprecated('Use Platform.current.isBrowser instead')
  @override
  bool get isBrowser;

  @Deprecated('Use Platform.current.isNative instead')
  @override
  bool get isNative;

  @override
  @Deprecated('Use Platform.current.nativePlatform!.localeName instead')
  String get localeName => Platform.current.nativePlatform!.localeName;

  @override
  @Deprecated('Use Platform.current.nativePlatform!.localHostname instead')
  String get localHostname => Platform.current.nativePlatform!.localHostname;

  @override
  NativePlatform? get nativePlatform;

  @override
  @Deprecated('Use Platform.current.nativePlatform!.numberOfProcessors instead')
  int get numberOfProcessors =>
      Platform.current.nativePlatform!.numberOfProcessors;

  // Implements existing behavior through `NativePlatform`.
  @override
  @Deprecated('Use Platform.current.nativePlatform!.operatingSystem instead')
  String get operatingSystem =>
      Platform.current.nativePlatform!.operatingSystem;

  @override
  @Deprecated(
      'Use Platform.current.nativePlatform!.operatingSystemVersion instead')
  String get operatingSystemVersion =>
      Platform.current.nativePlatform!.operatingSystemVersion;

  @override
  @Deprecated('Use Platform.current.nativePlatform!.packageConfig instead')
  String? get packageConfig => Platform.current.nativePlatform!.packageConfig;

  @override
  @Deprecated('Use Platform.current.nativePlatform!.pathSeparator instead')
  String get pathSeparator => Platform.current.nativePlatform!.pathSeparator;

  @override
  @Deprecated('Use Platform.current.nativePlatform!.resolvedExecutable instead')
  String get resolvedExecutable =>
      Platform.current.nativePlatform!.resolvedExecutable;

  @override
  @Deprecated('Use Platform.current.nativePlatform!.script instead')
  Uri get script => Platform.current.nativePlatform!.script;

  @override
  @Deprecated('Use Platform.current.nativePlatform!.stdinSupportsAnsi instead')
  bool get stdinSupportsAnsi =>
      Platform.current.nativePlatform!.stdinSupportsAnsi;

  @override
  @Deprecated('Use Platform.current.nativePlatform!.stdoutSupportsAnsi instead')
  bool get stdoutSupportsAnsi =>
      Platform.current.nativePlatform!.stdoutSupportsAnsi;

  @override
  @Deprecated('Use Platform.current.nativePlatform!.version instead')
  String get version => Platform.current.nativePlatform!.version;

  @override
  String toJson() => Platform.current.nativePlatform!.toJson();
}

extension type const _LocalPlatformInstance._(LocalPlatform _)
    implements LocalPlatform {
  const _LocalPlatformInstance() : this._(LocalPlatform._instance);
}
