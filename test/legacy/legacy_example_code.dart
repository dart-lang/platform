// Copyright (c) 2024, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

// Example code using legacy APIs. Used to test automatic migration.
// Uses every legacy API member.
//
// To test migration of this file, run `dart tool/check_migration.dart` from
// the project root.

// REMOVE NEXT LINE BEFORE TESTING MIGRATION:
// ignore_for_file: deprecated_member_use_from_same_package

import 'package:platform/platform.dart';

void main() {
  print(Platform.android);
  print(Platform.fuchsia);
  print(Platform.iOS);
  print(Platform.linux);
  print(Platform.macOS);
  print(Platform.windows);
  print(Platform.operatingSystemValues);

  // Using `LocalPlatform`.
  var json = useLocalPlatform();

  // Using `FakePlatform`.
  json = useFakePlatform(json);

  // Using `Platform` as interface.
  operateOnPlatform(const LocalPlatform());
  operateOnPlatform(FakePlatform.fromJson(json));
}

String useLocalPlatform() {
  var platform = const LocalPlatform();

  print(platform.operatingSystem);
  print(platform.environment);
  print(platform.executable);
  print(platform.executableArguments);
  print(platform.localeName);
  print(platform.localHostname);
  print(platform.numberOfProcessors);
  print(platform.operatingSystem);
  print(platform.operatingSystemVersion);
  print(platform.packageConfig);
  print(platform.pathSeparator);
  print(platform.resolvedExecutable);
  print(platform.script);
  print(platform.stdinSupportsAnsi);
  print(platform.stdoutSupportsAnsi);
  print(platform.version);

  return platform.toJson();
}

String useFakePlatform(String json) {
  var platform = FakePlatform();
  print(platform.packageConfig); // Doesn't throw.
  platform = FakePlatform.fromJson(json);
  platform = FakePlatform.fromPlatform(platform);
  platform = platform.copyWith(environment: platform.environment);

  // Not deprecated. Implemented as extension getters now.
  print(platform.isAndroid);
  print(platform.isFuchsia);
  print(platform.isIOS);
  print(platform.isLinux);
  print(platform.isMacOS);
  print(platform.isWindows);

  // Deprecated.
  print(platform.operatingSystem);
  print(platform.environment);
  print(platform.executable);
  print(platform.executableArguments);
  print(platform.localeName);
  print(platform.localHostname);
  print(platform.numberOfProcessors);
  print(platform.operatingSystem);
  print(platform.operatingSystemVersion);
  print(platform.packageConfig);
  print(platform.pathSeparator);
  print(platform.resolvedExecutable);
  print(platform.script);
  print(platform.stdinSupportsAnsi);
  print(platform.stdoutSupportsAnsi);
  print(platform.version);

  return platform.toJson();
}

void operateOnPlatform(Platform platform) {
  print(platform.operatingSystem);
  print(platform.environment);
  print(platform.executable);
  print(platform.executableArguments);
  print(platform.localeName);
  print(platform.localHostname);
  print(platform.numberOfProcessors);
  print(platform.operatingSystem);
  print(platform.operatingSystemVersion);
  print(platform.packageConfig);
  print(platform.pathSeparator);
  print(platform.resolvedExecutable);
  print(platform.script);
  print(platform.stdinSupportsAnsi);
  print(platform.stdoutSupportsAnsi);
  print(platform.version);
}
