// Copyright (c) 2024, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

/// Implementation of the *current* platform,
/// and abstract interfaces for the rest.
library;

export 'platform_specific/platform_unknown_impl.dart'
    if (dart.library.js_interop) 'platform_specific/platform_browser_impl.dart'
    if (dart.library.io) 'platform_specific/platform_native_impl.dart'
    show
        BrowserPlatform,
        BrowserPlatformTestBase,
        NativePlatform,
        NativePlatformTestBase,
        Platform,
        PlatformTestBase;
