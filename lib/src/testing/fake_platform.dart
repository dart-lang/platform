// Copyright (c) 2017, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:convert';

import '../interface/platform.dart';

/// Provides a mutable implementation of the [Platform] interface.
class FakePlatform extends Platform {
  /// Creates a new [FakePlatform] with the specified properties.
  ///
  /// Unspecified properties will *not* be assigned default values (they will
  /// remain `null`). If an unset non-null value is read, a [StateError] will
  /// be thrown instead of returnin `null`.
  FakePlatform({
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
    this.packageRoot,
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

  /// Creates a new [FakePlatform] with properties whose initial values mirror
  /// the specified [platform].
  FakePlatform.fromPlatform(Platform platform)
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
        packageRoot = platform
            .packageRoot, // ignore: deprecated_member_use_from_same_package
        packageConfig = platform.packageConfig,
        _version = platform.version,
        _stdinSupportsAnsi = platform.stdinSupportsAnsi,
        _stdoutSupportsAnsi = platform.stdoutSupportsAnsi,
        _localeName = platform.localeName;

  /// Creates a new [FakePlatform] with properties extracted from the encoded
  /// JSON string.
  ///
  /// [json] must be a JSON string that matches the encoding produced by
  /// [toJson].
  factory FakePlatform.fromJson(String json) {
    Map<String, dynamic> map = new JsonDecoder().convert(json);
    return new FakePlatform(
      numberOfProcessors: map['numberOfProcessors'],
      pathSeparator: map['pathSeparator'],
      operatingSystem: map['operatingSystem'],
      operatingSystemVersion: map['operatingSystemVersion'],
      localHostname: map['localHostname'],
      environment: map['environment'].cast<String, String>(),
      executable: map['executable'],
      resolvedExecutable: map['resolvedExecutable'],
      script: Uri.parse(map['script']),
      executableArguments: map['executableArguments'].cast<String>(),
      packageRoot: map['packageRoot'],
      packageConfig: map['packageConfig'],
      version: map['version'],
      stdinSupportsAnsi: map['stdinSupportsAnsi'],
      stdoutSupportsAnsi: map['stdoutSupportsAnsi'],
      localeName: map['localeName'],
    );
  }

  @override
  int get numberOfProcessors => _throwIfNull(_numberOfProcessors);
  int? _numberOfProcessors;

  @override
  String get pathSeparator => _throwIfNull(_pathSeparator);
  String? _pathSeparator;

  @override
  String get operatingSystem => _throwIfNull(_operatingSystem);
  String? _operatingSystem;

  @override
  String get operatingSystemVersion => _throwIfNull(_operatingSystemVersion);
  String? _operatingSystemVersion;

  @override
  String get localHostname => _throwIfNull(_localHostname);
  String? _localHostname;

  @override
  Map<String, String> get environment => _throwIfNull(_environment);
  Map<String, String>? _environment;

  @override
  String get executable => _throwIfNull(_executable);
  String? _executable;

  @override
  String get resolvedExecutable => _throwIfNull(_resolvedExecutable);
  String? _resolvedExecutable;

  @override
  Uri get script => _throwIfNull(_script);
  Uri? _script;

  @override
  List<String> get executableArguments => _throwIfNull(_executableArguments);
  List<String>? _executableArguments;

  @override
  String? packageRoot;

  @override
  String? packageConfig;

  @override
  String get version => _throwIfNull(_version);
  String? _version;

  @override
  bool get stdinSupportsAnsi => _throwIfNull(_stdinSupportsAnsi);
  bool? _stdinSupportsAnsi;

  @override
  bool get stdoutSupportsAnsi => _throwIfNull(_stdoutSupportsAnsi);
  bool? _stdoutSupportsAnsi;

  @override
  String get localeName => _throwIfNull(_localeName);
  String? _localeName;

  T _throwIfNull<T>(T? value) {
    if (value == null) {
      throw StateError(
          'Tried to read property of FakePlatform but it was unset.');
    }
    return value;
  }
}
