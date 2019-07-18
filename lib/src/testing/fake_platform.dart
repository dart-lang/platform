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
  /// remain `null`).
  FakePlatform({
    this.numberOfProcessors,
    this.pathSeparator,
    this.operatingSystem,
    this.operatingSystemVersion,
    this.localHostname,
    this.environment,
    this.executable,
    this.resolvedExecutable,
    this.script,
    this.executableArguments,
    this.packageRoot,
    this.packageConfig,
    this.version,
    this.stdinSupportsAnsi,
    this.stdoutSupportsAnsi,
    this.localeName,
  });

  /// Creates a new [FakePlatform] with properties whose initial values mirror
  /// the specified [platform].
  FakePlatform.fromPlatform(Platform platform)
      : numberOfProcessors = platform.numberOfProcessors,
        pathSeparator = platform.pathSeparator,
        operatingSystem = platform.operatingSystem,
        operatingSystemVersion = platform.operatingSystemVersion,
        localHostname = platform.localHostname,
        environment = new Map<String, String>.from(platform.environment),
        executable = platform.executable,
        resolvedExecutable = platform.resolvedExecutable,
        script = platform.script,
        executableArguments =
            new List<String>.from(platform.executableArguments),
        packageRoot = platform.packageRoot,
        packageConfig = platform.packageConfig,
        version = platform.version,
        stdinSupportsAnsi = platform.stdinSupportsAnsi,
        stdoutSupportsAnsi = platform.stdoutSupportsAnsi,
        localeName = platform.localeName;

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
  int numberOfProcessors;

  @override
  String pathSeparator;

  @override
  String operatingSystem;

  @override
  String operatingSystemVersion;

  @override
  String localHostname;

  @override
  Map<String, String> environment;

  @override
  String executable;

  @override
  String resolvedExecutable;

  @override
  Uri script;

  @override
  List<String> executableArguments;

  @override
  String packageRoot;

  @override
  String packageConfig;

  @override
  String version;

  @override
  bool stdinSupportsAnsi;

  @override
  bool stdoutSupportsAnsi;

  @override
  String localeName;
}
