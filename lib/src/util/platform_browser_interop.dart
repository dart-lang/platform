// Copyright (c) 2024, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

/// Browser API interaction used by the browser platform implementation.
library;

import 'dart:js_interop';

@JS()
extension type Navigator(JSObject _) {
  @JS()
  external String? get userAgent;
  @JS()
  external String? get appVersion;
}

@JS()
external Navigator? get navigator;
