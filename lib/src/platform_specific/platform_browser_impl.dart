// Copyright (c) 2024, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

/// Platform specific implementations for `LocalPlatform`
/// when `dart:html` is available , but `dart:io` is not.
/// (That is, when compiling for the web).
library;

import 'dart:convert' show JsonEncoder;

import '../legacy_implementation/legacy_platform_members.dart'
    show LegacyPlatformMembers;
import '../testing/zone_overrides.dart' as override;
import '../util/json_keys.dart' as json_key;
import '../util/platform_browser_interop.dart' as window;
import 'platform_native_interface.dart';

export 'platform_native_interface.dart';

const Platform platformInstance = Platform._();
const BrowserPlatform browserPlatformInstance = BrowserPlatform._();

// For the legacy `LocalPlatform`.
const NativePlatform? nativePlatformInstance = null;

/// Dart runtime platform information.
///
/// Provides information about the current runtime environment.
///
/// If running as native code, the [nativePlatform] object is
/// non-`null` and provides information about that platform,
/// including the [NativePlatform.operatingSystem] name.
///
/// If running in a browser, the [browserPlatform] objects is
/// non-`null` and provides information about the browser.
final class Platform with LegacyPlatformMembers {
  /// The current [Platform] information of the running program.
  @pragma('dart2js:prefer-inline')
  static Platform get current =>
      (override.platformOverride as Platform?) ?? platformInstance;

  /// The current native platform, if running on a native platform.
  @pragma('dart2js:prefer-inline')
  NativePlatform? get nativePlatform => null;

  /// The current browser platform, if running on a browser platform.
  @pragma('dart2js:prefer-inline')
  BrowserPlatform? get browserPlatform => browserPlatformInstance;

  /// Whether currently running on a native platform.
  @pragma('dart2js:prefer-inline')
  bool get isNative => false;

  /// Whether currently running in a browser.
  @pragma('dart2js:prefer-inline')
  bool get isBrowser => true;

  const Platform._();

  @Deprecated('Use NativePlatform.android instead')
  static const String android = NativePlatform.android;
  @Deprecated('Use NativePlatform.fuchsia instead')
  static const String fuchsia = NativePlatform.fuchsia;
  @Deprecated('Use NativePlatform.iOS instead')
  static const String iOS = NativePlatform.iOS;
  @Deprecated('Use NativePlatform.linux instead')
  static const String linux = NativePlatform.linux;
  @Deprecated('Use NativePlatform.macOS instead')
  static const String macOS = NativePlatform.macOS;
  @Deprecated('Use NativePlatform.windows instead')
  static const String windows = NativePlatform.windows;
  @Deprecated('Use NativePlatform.operatingSystemValues instead')
  static const List<String> operatingSystemValues = [
    android,
    fuchsia,
    iOS,
    linux,
    macOS,
    windows
  ];

  /// Produces the default instance of [Platform].
  ///
  /// The default platform instance *cannot be mocked*.
  /// Use [Platform.current] to access an instance that
  /// can be changed for testing.
  ///
  /// In general, prefer using `Platform.current` over this
  /// constructor, which mainly exists as a target for
  /// migration from earlier versions of this package.
  const factory Platform() = _PlatformInstance;
}

// Helper extension type allowing a const factory constructor to
// return the same object every time.
extension type const _PlatformInstance._(Platform _) implements Platform {
  const _PlatformInstance() : this._(platformInstance);
}

abstract base class PlatformTestBase extends Platform {
  const PlatformTestBase() : super._();
}

/// Information about the current browser.
///
/// Only available while running in a browser.
final class BrowserPlatform {
  const BrowserPlatform._();

  /// The current Browser platform, if any.
  ///
  /// Same as [Platform.current.browserPlatform](Platform.browserPlatform).
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
  String get version =>
      window.navigator?.appVersion ?? 'No navigator.appVersion';

  /// The browser's user-agent string, as reported by `Navigator.userAgent`.
  ///
  /// If no `Navigator` object is a available, the value will be
  /// the string `"unknown"`.
  String get userAgent =>
      window.navigator?.userAgent ?? 'No navigator.userAgent';

  /// A JSON representation of the state of this browser platform object.
  String toJson() => const JsonEncoder.withIndent('  ').convert({
        json_key.userAgent: userAgent,
        json_key.version: version,
      });
}

abstract base class BrowserPlatformTestBase implements BrowserPlatform {}
