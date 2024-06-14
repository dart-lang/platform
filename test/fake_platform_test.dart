// Copyright (c) 2022, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

// Check that fake platforms can be created for any platform.

import 'package:platform/testing.dart';
import 'package:test/test.dart';

void main() {
  test('Fake native platform', () {
    final currentNative = NativePlatform.current;
    final fakeNative = FakeNativePlatform(operatingSystem: 'banana');
    fakeNative.run(() {
      expect(NativePlatform.current, isNot(same(currentNative)));
      expect(NativePlatform.current, same(fakeNative));
      expect(Platform.current.nativePlatform, same(fakeNative));
      expect(NativePlatform.current?.operatingSystem, 'banana');
    });
  });

  test('Fake browser platform', () {
    final currentBrowser = BrowserPlatform.current;
    final fakeBrowser = FakeBrowserPlatform(version: 'banana');
    fakeBrowser.run(() {
      expect(BrowserPlatform.current, isNot(same(currentBrowser)));
      expect(BrowserPlatform.current, same(fakeBrowser));
      expect(Platform.current.browserPlatform, same(fakeBrowser));
      expect(BrowserPlatform.current?.version, 'banana');
    });
  });
}
