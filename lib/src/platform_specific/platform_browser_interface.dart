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
  /// Same as [Platform.current.browserPlatform].
  static BrowserPlatform? get current => Platform.current.browserPlatform;

  /// The browser's version, as reported by (something).
  String get version;

  /// The browser's user-agent string, as reported by `Navigator.userAgent`.
  String get userAgent;

  /// A JSON representation of the state of this platform object.
  String toJson();
}

abstract base class BrowserPlatformTestBase implements BrowserPlatform {}
