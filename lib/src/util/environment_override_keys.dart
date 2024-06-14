// Copyright (c) 2023, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

/// Compilation environment overrides for native OS name and version.
///
/// Only used on native platforms.
library;

/// Compilation environment key for overriding the operating system string
///
/// Only has effect on native platforms.
const String _osKey = 'pkg.platform.operatingSystem';

/// Compilation environment key for overriding the operating system version
/// string.
///
/// Only has effect on native platforms.
const String _versionKey = 'pkg.platform.operatingSystemVersion';

/// Compilation environment value for operating system override.
const String? operatingSystem =
    bool.hasEnvironment(_osKey) ? String.fromEnvironment(_osKey) : null;

/// Compilation environment value for operating system version override.
const String? operatingSystemVersion = bool.hasEnvironment(_versionKey)
    ? String.fromEnvironment(_versionKey)
    : null;
