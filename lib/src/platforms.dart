// Copyright (c) 2024, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

/// All classes and interfaces exposed by the package.
///
/// All classes are declared in the same library, so that they can all be final,
/// and still depend on each other.
library;

import 'platforms_impl.dart' show Platform;
export 'platforms_impl.dart' show BrowserPlatform, NativePlatform, Platform;

/// Shorthands for checking operating system on the native platform.
///
/// Extension getters on `Platform` which forward to the operating system
/// checks on [Platform.nativePlatform], after checking that this is a native
/// platform.
extension PlatformIsOS on Platform {
  /// Whether this is a [nativePlatform] on [Android](NativePlatform.isAndroid).
  @pragma('vm:prefer-inline')
  @pragma('dart2js:prefer-inline')
  bool get isAndroid => nativePlatform?.isAndroid ?? false;

  /// Whether this is a [nativePlatform] on [Fuchsia](NativePlatform.isFuchsia).
  @pragma('vm:prefer-inline')
  @pragma('dart2js:prefer-inline')
  bool get isFuchsia => nativePlatform?.isFuchsia ?? false;

  /// Whether this is a [nativePlatform] on [iOS](NativePlatform.isIOS).
  @pragma('vm:prefer-inline')
  @pragma('dart2js:prefer-inline')
  bool get isIOS => nativePlatform?.isIOS ?? false;

  /// Whether this is a [nativePlatform] on [Linux](NativePlatform.isLinux).
  @pragma('vm:prefer-inline')
  @pragma('dart2js:prefer-inline')
  bool get isLinux => nativePlatform?.isLinux ?? false;

  /// Whether this is a [nativePlatform] on [MacOS](NativePlatform.isMacOS).
  @pragma('vm:prefer-inline')
  @pragma('dart2js:prefer-inline')
  bool get isMacOS => nativePlatform?.isMacOS ?? false;

  /// Whether this is a [nativePlatform] on [Windows](NativePlatform.isWindows).
  @pragma('vm:prefer-inline')
  @pragma('dart2js:prefer-inline')
  bool get isWindows => nativePlatform?.isWindows ?? false;
}
