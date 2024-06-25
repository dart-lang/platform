// Copyright (c) 2024, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

// Test of [browserPlatform].
@OnPlatform({'!browser': Skip('Browser-only functionality')})
library;

import 'dart:html';

import 'package:platform/platform.dart';
import 'package:test/test.dart';

void main() {
  const isNative = bool.fromEnvironment('dart.library.io');
  const isBrowser = bool.fromEnvironment('dart.library.js_interop');
  final platform = Platform.current;
  final browserPlatform = platform.browserPlatform;

  test('Running on browser', () {
    expect(isBrowser, true, reason: 'dart.library.js_interop');
    expect(isNative, false, reason: 'dart.library.io');
    expect(platform.isNative, false, reason: 'Platform.current.isNative');
    expect(platform.isBrowser, true, reason: 'Platform.current.isBrowser');
    expect(browserPlatform, isNotNull,
        reason: 'Platform.current.browserPlatform');
    expect(platform.nativePlatform, isNull,
        reason: 'Platform.current.nativePlatform');
  });

  if (browserPlatform == null) return; // Promote to non-null.

  test('static properties', () {
    // The `current` getter is the same objects as
    // `Platform.current.browserPlatform`.
    expect(browserPlatform, same(BrowserPlatform.current),
        reason: 'BrowserPlatform.current');
  });

  test('Has same values as JS', () {
    // Everything is taken from browser (`window.navigator`).
    expect(browserPlatform.userAgent, window.navigator.userAgent,
        reason: 'window.navigator.userAgent');
    expect(browserPlatform.version, window.navigator.appVersion,
        reason: 'window.navigator.appVersion');
  });
}
