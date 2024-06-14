// Copyright (c) 2024, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

/// Shared functionality for overriding a `Platform` using zones.
library;

import 'dart:async';

abstract class OverrideMarker {}

/// A variable which can only become non-`null` if testing.
///
/// Only set when using the `runWith` function, which is only called from
/// `FakePlatform.run`. When not importing the `testing.dart` library,
/// there are no concrete subclasses of `OverrideMarker` in the program,
/// so compilers should be able to recognize that `marker` is always `null`.
OverrideMarker? marker;

/// Unfakable key used to set a `Platform` override in zone variables.
const zoneKey = #_platformOverride;

R runWith<R>(R Function() code, Object? overrideValue, OverrideMarker mark) {
  // After this, lookups on `Platform.current` will check for zone overrides.
  marker = mark;
  return runZoned(code, zoneValues: {zoneKey: overrideValue});
}
