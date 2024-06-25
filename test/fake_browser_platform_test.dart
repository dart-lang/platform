// Copyright (c) 2017, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

@OnPlatform({'!browser': Skip('Browser-only functionality')})
library;

import 'dart:convert' show jsonDecode, jsonEncode;

import 'package:platform/src/util/json_keys.dart' as json_key;
import 'package:platform/testing.dart';
import 'package:test/test.dart';

void main() {
  const fakeUA = 'Fake UserAgent';
  const fakeVersion = 'Fake Version';

  final original = BrowserPlatform.current;

  test('Is compiled on browser', () {
    expect(original, isNotNull);
    expect(Platform.current.browserPlatform, same(original));
  });

  if (original == null) return; // Promote to non-null from here.

  group('FakeBrowserPlatform', () {
    group('fromPlatform', () {
      test('copiesAllProperties', () {
        var fake = FakeBrowserPlatform.fromPlatform(original);
        testBrowserFake(
            fake, jsonDecode(original.toJson()) as Map<String, Object?>);
      });
    });

    group('copyWith', () {
      test('overrides a value, but leaves others intact', () {
        var expected = jsonDecode(original.toJson()) as Map<String, Object?>;
        var fake = FakeBrowserPlatform.fromPlatform(original);

        BrowserPlatform copy = fake.copyWith(
          version: '42.0',
        );
        expected[json_key.version] = '42.0';
        testBrowserFake(copy, expected);
      });
      test('can override all values', () {
        var fake = FakeBrowserPlatform.fromPlatform(original);
        var expected = <String, Object?>{
          json_key.userAgent: fakeUA,
          json_key.version: fakeVersion,
        };
        var copy = fake.copyWith(
          userAgent: expected[json_key.userAgent] as String?,
          version: expected[json_key.version] as String?,
        );
        testBrowserFake(copy, expected);
      });
    });

    group('json', () {
      test('fromJson', () {
        var json = <String, Object?>{
          json_key.userAgent: fakeUA,
          json_key.version: fakeVersion,
        };
        var jsonText = jsonEncode(json);
        var fake = FakeBrowserPlatform.fromJson(jsonText);
        testBrowserFake(fake, json);
        // Compare toJson.
        expect(jsonDecode(fake.toJson()), json);
      });

      test('fromEmptyJson', () {
        var fake = FakeBrowserPlatform.fromJson('{}');
        testBrowserFake(fake, {});
      });

      test('fromNullJson', () {
        // Explicit null values are allowed in the JSON, treated as unset value.
        var allNulls = <String, Object?>{
          json_key.userAgent: null,
          json_key.version: null,
        };
        var fake = FakeBrowserPlatform.fromJson(jsonEncode(allNulls));
        testBrowserFake(fake, {});
        expect(fake.toJson(), '{}');
      });

      test('fromJsonToJson', () {
        var current = original;
        var jsonText = current.toJson();
        var json = jsonDecode(jsonText) as Map<String, Object?>;
        var fake = FakeBrowserPlatform.fromJson(jsonText);
        testBrowserFake(fake, json);
        expect(jsonDecode(fake.toJson()), json);
      });

      test('fromJsonErrors', () {
        void fromJsonError(String source) {
          expect(() => FakeBrowserPlatform.fromJson(source),
              throwsFormatException);
        }

        // Not valid JSON at all.
        fromJsonError('not-JSON!');

        // Not a map at top-level.
        fromJsonError('"a"');
        fromJsonError('[]');

        // These properties must be strings or null.
        for (var name in [
          json_key.userAgent,
          json_key.version,
        ]) {
          fromJsonError('{"$name": 42}');
          fromJsonError('{"$name": ["not a string"]}');
          fromJsonError('{"$name": {"not" : "a string"}}');
        }
      });
    });

    test('Throws when unset non-null values are read', () {
      final platform = FakeBrowserPlatform();
      // Sanity check, in case `testBrowserFake` was bugged.
      expect(() => platform.userAgent, throwsA(isStateError));
      expect(() => platform.version, throwsA(isStateError));
    });
  });

  group('runtime override', () {
    test('sync', () {
      var fake = FakeBrowserPlatform.fromPlatform(original)
          .copyWith(userAgent: fakeUA);
      expect(fake.userAgent, fakeUA);
      fake.run(() {
        expect(BrowserPlatform.current, same(fake));
        expect(Platform.current.browserPlatform, same(fake));
        expect(BrowserPlatform.current?.userAgent, fakeUA);
        expect(BrowserPlatform.current?.version, original.version);
      });
    });
    test('async', () async {
      var currentNative = original;
      var fake = FakeBrowserPlatform.fromPlatform(currentNative)
          .copyWith(userAgent: fakeUA);
      var parts = 0;
      var asyncTesting = fake.run(() async {
        // Runs synchronously.
        expect(BrowserPlatform.current, same(fake));
        expect(Platform.current.browserPlatform, same(fake));
        expect(BrowserPlatform.current?.userAgent, fakeUA);
        parts++;
        await Future(() {}); // Timer-delay.
        // Fake platform is still current after async gap.
        expect(BrowserPlatform.current, same(fake));
        expect(Platform.current.browserPlatform, same(fake));
        expect(BrowserPlatform.current?.userAgent, fakeUA);
        parts++;
      });
      expect(parts, 1);
      expect(BrowserPlatform.current, same(original));
      expect(Platform.current.browserPlatform, same(original));
      expect(BrowserPlatform.current?.userAgent, original.userAgent);
      await asyncTesting;
      expect(parts, 2);
    });
  });
  group('nested overrides', () {
    final fakeNative =
        FakeBrowserPlatform.fromPlatform(original).copyWith(userAgent: fakeUA);
    final fakeNative2 = FakeBrowserPlatform.fromPlatform(fakeNative)
        .copyWith(version: fakeVersion);
    test('sync', () {
      fakeNative.run(() {
        expect(BrowserPlatform.current, same(fakeNative));
        expect(Platform.current.browserPlatform, same(fakeNative));
        expect(BrowserPlatform.current?.userAgent, fakeUA);
        expect(BrowserPlatform.current?.version, original.version);
        fakeNative2.run(() {
          expect(BrowserPlatform.current, same(fakeNative2));
          expect(Platform.current.browserPlatform, same(fakeNative2));
          expect(BrowserPlatform.current?.userAgent, fakeUA);
          expect(BrowserPlatform.current?.version, fakeVersion);
        });
        // Previous override restored when done.
        expect(BrowserPlatform.current, same(fakeNative));
        expect(Platform.current.browserPlatform, same(fakeNative));
        expect(BrowserPlatform.current?.userAgent, fakeUA);
        expect(BrowserPlatform.current?.version, original.version);
      });
    });
    test('async', () async {
      await fakeNative.run(() async {
        expect(BrowserPlatform.current, same(fakeNative));
        expect(Platform.current.browserPlatform, same(fakeNative));
        expect(BrowserPlatform.current?.userAgent, fakeUA);
        expect(BrowserPlatform.current?.version, original.version);
        var parts = 0;
        var asyncTesting = fakeNative2.run(() async {
          expect(BrowserPlatform.current, same(fakeNative2));
          expect(Platform.current.browserPlatform, same(fakeNative2));
          expect(BrowserPlatform.current?.userAgent, fakeUA);
          expect(BrowserPlatform.current?.version, fakeVersion);
          parts++;
          await Future(() {});
          expect(BrowserPlatform.current, same(fakeNative2));
          expect(Platform.current.browserPlatform, same(fakeNative2));
          expect(BrowserPlatform.current?.userAgent, fakeUA);
          expect(BrowserPlatform.current?.version, fakeVersion);
          parts++;
        });
        expect(parts, 1);
        // Previous override restored when done.
        expect(BrowserPlatform.current, same(fakeNative));
        expect(Platform.current.browserPlatform, same(fakeNative));
        expect(BrowserPlatform.current?.userAgent, fakeUA);
        expect(BrowserPlatform.current?.version, original.version);
        await asyncTesting;
        expect(parts, 2);
      });
    });
  });
}

/// Checks that the operation `read()` throws if `expected` is `null`,
/// and otherwise it returns a value equal to `expected`.
void _testProperty(Object? Function() read, Object? expected) {
  if (expected == null) {
    expect(read, throwsStateError);
  } else {
    expect(read(), expected);
  }
}

/// Check the properties of a [BrowserPlatform].
///
/// The [expectedValues] is uses the same format as JSON serialization of a
/// [BrowserPlatform].
///
/// If any of the expected values arguments are `null`, reading the
/// corresponding property is expected to throw a `StateError`
/// (except for `NativePackage.packageConfig` which is nullable).
/// If the operating system value is `null`, all the  `isAndroid`..`isWindows`
/// are expected to throw too.
/// Otherwise they are tested to give the expected true/false value
/// for the expected operating system.
void testBrowserFake(
    BrowserPlatform actual, Map<String, Object?> expectedValues) {
  _testProperty(() => actual.userAgent, expectedValues[json_key.userAgent]);
  _testProperty(() => actual.version, expectedValues[json_key.version]);
}
