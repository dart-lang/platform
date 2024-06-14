// Copyright (c) 2024, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

// Compile this file for a specific platform, for example as:
//
//    dart compile exe --target-os=linux tree_shake_shorthand.dart
//    dart compile js -o tree_shake_shorthand.js tree_shake_shorthand.dart
//
// and check that the executable does not contain the strings for
// other platforms. For example on Linux, use:
//
//     strings tree_shake_shorthand.{exe,js} | grep "RUNNING"
//
// and check that the only retained value is either `RUNNING ON LINUX` or
// `RUNNING IN A BROWSER`.

import 'package:platform/platform.dart';

void main() {
  const expectedPlatform = bool.fromEnvironment('dart.library.js_interop')
      ? 'browser'
      : bool.fromEnvironment('dart.library.io')
          ? 'native'
          : 'unknown';
  print('Expected platform: $expectedPlatform');

  if (Platform.current.isBrowser) {
    print('RUNNING IN A BROWSER');
  } else if (Platform.current.isLinux) {
    print('RUNNING ON LINUX');
  } else if (Platform.current.isMacOS) {
    print('RUNNING ON MACOS');
  } else if (Platform.current.isWindows) {
    print('RUNNING ON WINDOWS');
  }
}
