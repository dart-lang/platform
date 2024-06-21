// Copyright (c) 2024, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

/// Unknown platform.
library;

import '../legacy_implementation/legacy_platform_members.dart'
    show LegacyPlatformMembers;
import '../testing/zone_overrides.dart' as override;
import 'platform_browser_interface.dart';
import 'platform_native_interface.dart';

export 'platform_browser_interface.dart';
export 'platform_native_interface.dart';

const platformInstance = Platform._();

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
  @pragma('vm:prefer-inline')
  static Platform get current =>
      (override.platformOverride as Platform?) ?? platformInstance;

  /// The current native platform, if running on a native platform.
  @pragma('vm:prefer-inline')
  @pragma('dart2js:prefer-inline')
  NativePlatform? get nativePlatform => null;

  /// The current browser platform, if running on a browser platform.
  @pragma('vm:prefer-inline')
  @pragma('dart2js:prefer-inline')
  BrowserPlatform? get browserPlatform => null;

  /// Whether currently running on a native platform.
  @pragma('vm:prefer-inline')
  @pragma('dart2js:prefer-inline')
  bool get isNative => false;

  /// Whether currently running in a browser.
  @pragma('vm:prefer-inline')
  @pragma('dart2js:prefer-inline')
  bool get isBrowser => false;

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

  /// A list of the known values that [operatingSystem] can have.
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

// Extensible class so testing classes can subclass an otherwise final class.
abstract base class PlatformTestBase extends Platform {
  const PlatformTestBase() : super._();
}
