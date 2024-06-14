// Copyright 2024 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// ignore_for_file: deprecated_member_use_from_same_package

/// Properties of the current platform.
///
/// The [Platform.current] object represents the current runtime platform
/// by having one of [Platform.nativePlatform] or [Platform.browserPlatform]
/// being non-`null`, depending on the runtime system the current program is
/// running on.
///
/// That value can the provide more information about the current native,
/// or browser platform.
///
/// [!NOTE]
/// This library currently provides a deprecated legacy [LocalPlatform]
/// and [FakePlatform] classes, and exposes deprecated members on the
/// [Platform] interface.
/// Code using those deprecated members or the class [LocalPlatform] should use
/// [Platform.current.nativePlatform] instead.
/// Code using [FakePlatform] should import `package:platform/testing.dart`
/// and use `FakeNativePlatform` instead.
/// Be aware that `package:platform/testing.dart` exposes a
/// *different* class named `FakePlatform`, so using the two libraries
/// together requires hiding `FakePlatform` from `testing.dart`
/// until all legacy [FakePlatform] uses have been removed.
/// The legacy [FakePlatform] is also available as [LegacyFakePlatform].
library;

import 'src/legacy_implementation/legacy_classes.dart'; // For DartDoc.
import 'src/platforms.dart'; // For DartDoc.

// Legacy classes, `LocalPlatform` and `FakePlatform`
// (not the same as `FakePlatform` from `testing.dart`).
export 'src/legacy_implementation/legacy_classes.dart'
    show FakePlatform, LegacyFakePlatform, LocalPlatform;

export 'src/platforms.dart'
    show BrowserPlatform, NativePlatform, Platform, PlatformIsOS;
