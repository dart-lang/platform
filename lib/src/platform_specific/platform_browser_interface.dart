// Copyright (c) 2024, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

/// Platform specific interface for `BrowserPlatform`.
library;

import '../platforms_impl.dart' show Platform;

/// Information about the current browser.
///
/// Only available while running in a browser.
abstract final class BrowserPlatform {
  const BrowserPlatform._();

  /// The current Browser platform, if any.
  ///
  /// Same as [Platform.current.browserPlatform][Platform.browserPlatform].
  static BrowserPlatform? get current => Platform.current.browserPlatform;

  /// The browser's version, as reported by `Navigator.appVersion` by default.
  ///
  /// If a particular browser provides a more specific version string,
  /// it may be used instead of the default.
  ///
  /// No guarantees are made about the format of the string, it may differ
  /// between different browser types, and between different browser versions
  /// or versions of this package.
  ///
  /// If no `Navigator` object is a available,
  /// the string content is unspecified.
  String get version;

  /// The browser's user-agent string, as reported by `Navigator.userAgent`.
  ///
  /// If no `Navigator` object is a available, the value will be
  /// the string `"unknown"`.
  String get userAgent;

  /// A JSON representation of the state of this browser platform object.
  String toJson();
}

abstract base class BrowserPlatformTestBase implements BrowserPlatform {}
