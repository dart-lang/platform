// Copyright (c) 2024, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

/// Shared functionality for overriding a `Platform` using zones.
library;

import 'dart:async';

/// Class which is only implemented in `fake_platforms.dart`.
abstract class OverrideMarker {}

/// A variable which can only become non-`null` if testing.
///
/// Only set when using the `runWith` function, which is only called from
/// `FakePlatform.run`. When not importing the `testing.dart` library,
/// there are no concrete subclasses of `OverrideMarker` in the program,
/// so compilers should be able to recognize that `marker` is always `null`.
OverrideMarker? _marker;

/// Unfakable key used to set a `Platform` override in zone variables.
const _zoneKey = #_platformOverride;

/// Reads the platform override
@pragma('vm:prefer-inline')
@pragma('dart2js:prefer-inline')
@pragma('dart2wasm:prefer-inline')
Object? get platformOverride => _marker == null ? null : Zone.current[_zoneKey];

/// Runs [code] in a zone with a platform override, and returns its result.
///
/// The [overrideValue] will be a `FakePlatform`, but that type is only
/// available
///
R runWith<R>(R Function() code, Object? overrideValue, OverrideMarker mark) {
  // After this, lookups on `Platform.current` will check for zone overrides.
  _marker = mark;
  return runZoned(code, zoneValues: {_zoneKey: overrideValue});
}
