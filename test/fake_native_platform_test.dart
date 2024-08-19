// Copyright (c) 2017, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

@OnPlatform({'browser': Skip('Native-only functionality')})
library;

import 'dart:convert' show jsonDecode, jsonEncode;

import 'package:platform/src/util/json_keys.dart' as json_key;
import 'package:platform/testing.dart';
import 'package:test/test.dart';

void main() {
  final original = NativePlatform.current;

  test('Is compiled on native', () {
    expect(original, isNotNull);
    expect(Platform.current.nativePlatform, same(original));
  });

  if (original == null) return; // Promote to non-null from here.

  // For overriding: A valid value guaranteed to be different from
  // the current platform's value.
  final otherOS = original.operatingSystem == NativePlatform.android
      ? NativePlatform.fuchsia
      : NativePlatform.android;
  final otherVersion = original.operatingSystemVersion == '42' ? '87' : '42';

  group('FakeNativePlatform', () {
    group('fromPlatform', () {
      test('copiesAllProperties', () {
        var fake = FakeNativePlatform.from(original);
        testNativeFake(
            fake, jsonDecode(original.toJson()) as Map<String, Object?>);
      });

      test('converts properties to mutable', () {
        var fake = FakeNativePlatform.from(original);
        var key = fake.environment.keys.first;

        expect(fake.environment[key], original.environment[key]);
        fake.environment[key] = 'FAKE';
        expect(fake.environment[key], 'FAKE');

        expect(fake.executableArguments.length,
            original.executableArguments.length);
        fake.executableArguments.add('ARG');
        expect(fake.executableArguments.last, 'ARG');
      });
    });

    group('copyWith', () {
      test('overrides a value, but leaves others intact', () {
        var expected = jsonDecode(original.toJson()) as Map<String, Object?>;
        var fake = FakeNativePlatform.from(original);

        NativePlatform copy = fake.copyWith(
          numberOfProcessors: -1,
        );
        expected[json_key.numberOfProcessors] = -1;
        testNativeFake(copy, expected);
      });
      test('can override all values', () {
        var fake = FakeNativePlatform.from(original);
        var expected = <String, Object?>{
          json_key.environment: <String, String>{'PATH': '.'},
          json_key.executable: 'executable',
          json_key.executableArguments: <String>['script-arg'],
          json_key.lineTerminator: '\r',
          json_key.localeName: 'local',
          json_key.localHostname: 'host',
          json_key.numberOfProcessors: 8,
          json_key.operatingSystem: otherOS,
          json_key.operatingSystemVersion: '0.1.0',
          json_key.pathSeparator: ':',
          json_key.packageConfig: 'config.json',
          json_key.resolvedExecutable: '/executable',
          json_key.script: '/platform/test/fake_platform_test.dart',
          json_key.stdinSupportsAnsi: false,
          json_key.stdoutSupportsAnsi: true,
          json_key.version: '0.1.1',
        };
        var copy = fake.copyWith(
          environment: expected[json_key.environment] as Map<String, String>,
          executable: expected[json_key.executable] as String,
          executableArguments:
              expected[json_key.executableArguments] as List<String>,
          lineTerminator: expected[json_key.lineTerminator] as String,
          localeName: expected[json_key.localeName] as String,
          localHostname: expected[json_key.localHostname] as String,
          numberOfProcessors: expected[json_key.numberOfProcessors] as int,
          operatingSystem: expected[json_key.operatingSystem] as String,
          operatingSystemVersion:
              expected[json_key.operatingSystemVersion] as String,
          packageConfig: expected[json_key.packageConfig] as String?,
          pathSeparator: expected[json_key.pathSeparator] as String,
          script: Uri.parse(expected[json_key.script] as String),
          resolvedExecutable: expected[json_key.resolvedExecutable] as String,
          stdinSupportsAnsi: expected[json_key.stdinSupportsAnsi] as bool,
          stdoutSupportsAnsi: expected[json_key.stdoutSupportsAnsi] as bool,
          version: expected[json_key.version] as String,
        );
        testNativeFake(copy, expected);
      });
    });

    group('json', () {
      test('fromJson', () {
        var json = <String, Object?>{
          json_key.environment: {'PATH': '/bin', 'PWD': '/platform'},
          json_key.executable: '/bin/dart',
          json_key.executableArguments: ['--checked'],
          json_key.lineTerminator: '\r',
          json_key.localeName: 'de/de',
          json_key.localHostname: 'platform.test.org',
          json_key.numberOfProcessors: 8,
          json_key.operatingSystem: 'macos',
          json_key.operatingSystemVersion: '10.14.5',
          json_key.packageConfig: 'config.json',
          json_key.pathSeparator: '/',
          json_key.resolvedExecutable: '/bin/dart',
          json_key.script: 'file:///platform/test/fake_platform_test.dart',
          json_key.stdinSupportsAnsi: true,
          json_key.stdoutSupportsAnsi: false,
          json_key.version: '1.22.0'
        };
        var jsonText = jsonEncode(json);
        var fake = FakeNativePlatform.fromJson(jsonText);
        testNativeFake(fake, json);
        // Compare toJson.
        expect(jsonDecode(fake.toJson()), json);
      });

      test('fromEmptyJson', () {
        var fake = FakeNativePlatform.fromJson('{}');
        testNativeFake(fake, {});
      });

      test('fromNullJson', () {
        // Explicit null values are allowed in the JSON, treated as unset value.
        var allNulls = <String, Object?>{
          json_key.environment: null,
          json_key.executable: null,
          json_key.executableArguments: null,
          json_key.lineTerminator: null,
          json_key.localeName: null,
          json_key.localHostname: null,
          json_key.numberOfProcessors: null,
          json_key.operatingSystem: null,
          json_key.operatingSystemVersion: null,
          json_key.packageConfig: null,
          json_key.pathSeparator: null,
          json_key.resolvedExecutable: null,
          json_key.stdinSupportsAnsi: null,
          json_key.stdoutSupportsAnsi: null,
          json_key.script: null,
          json_key.version: null
        };
        var fake = FakeNativePlatform.fromJson(jsonEncode(allNulls));
        testNativeFake(fake, {});
        expect(fake.toJson(), '{}');
      });

      test('fromJsonToJson', () {
        var current = original;
        var jsonText = current.toJson();
        var json = jsonDecode(jsonText) as Map<String, Object?>;
        var fake = FakeNativePlatform.fromJson(jsonText);
        testNativeFake(fake, json);
        expect(jsonDecode(fake.toJson()), json);
      });

      test('fromJsonErrors', () {
        void fromJsonError(String source) {
          expect(
              () => FakeNativePlatform.fromJson(source), throwsFormatException);
        }

        // Not valid JSON at all.
        fromJsonError('not-JSON!');

        // Not a map at top-level.
        fromJsonError('"a"');
        fromJsonError('[]');

        // `environment`, if present, must be map from string to string.
        fromJsonError('{"${json_key.environment}": "not a map"}');
        fromJsonError('{"${json_key.environment}": ["not a map"]}');
        fromJsonError('{"${json_key.environment}": {"x": 42}}');

        // `executableArguments`, if present, must be list of strings.
        fromJsonError('{"${json_key.executableArguments}": true}');
        fromJsonError('{"${json_key.executableArguments}": {}}');
        fromJsonError('{"${json_key.executableArguments}": [42]}');
        fromJsonError('{"${json_key.executableArguments}": ["a", null, "b"]}');

        // `numberOfProcessors`, if present, must be an integer.
        fromJsonError('{"${json_key.numberOfProcessors}": "42"}');
        fromJsonError('{"${json_key.numberOfProcessors}": [42]}');
        fromJsonError('{"${json_key.numberOfProcessors}": 3.14}');

        // `script`, if present, must be string with valid URI.
        fromJsonError('{"${json_key.script}": false}');
        fromJsonError('{"${json_key.script}": ["valid:///uri"]}');
        fromJsonError('{"${json_key.script}": {"valid": "///uri"}}');
        fromJsonError('{"${json_key.script}": false}');
        fromJsonError('{"${json_key.script}": "4:///"}'); // Invalid URI scheme.

        // `*SupportsAnsi`, if present, must be booleans.
        fromJsonError('{"${json_key.stdinSupportsAnsi}": 42}');
        fromJsonError('{"${json_key.stdinSupportsAnsi}": "false"}');
        fromJsonError('{"${json_key.stdinSupportsAnsi}": []}');
        fromJsonError('{"${json_key.stdoutSupportsAnsi}": 42}');
        fromJsonError('{"${json_key.stdoutSupportsAnsi}": "false"}');
        fromJsonError('{"${json_key.stdoutSupportsAnsi}": []}');

        // Remaining properties must be strings.
        for (var name in [
          json_key.executable,
          json_key.lineTerminator,
          json_key.localeName,
          json_key.localHostname,
          json_key.operatingSystem,
          json_key.operatingSystemVersion,
          json_key.packageConfig,
          json_key.pathSeparator,
          json_key.resolvedExecutable,
          json_key.version,
        ]) {
          fromJsonError('{"$name": 42}');
          fromJsonError('{"$name": ["not a string"]}');
          fromJsonError('{"$name": {"not" : "a string"}}');
        }
      });
    });
    test('Throws when unset non-null values are read', () {
      final platform = FakeNativePlatform();
      // Sanity check, in case `testNativeFake` was bugged.
      expect(() => platform.environment, throwsA(isStateError));
      expect(() => platform.executable, throwsA(isStateError));
      expect(() => platform.executableArguments, throwsA(isStateError));
      expect(() => platform.lineTerminator, throwsA(isStateError));
      expect(() => platform.localeName, throwsA(isStateError));
      expect(() => platform.localHostname, throwsA(isStateError));
      expect(() => platform.numberOfProcessors, throwsA(isStateError));
      expect(() => platform.operatingSystem, throwsA(isStateError));
      expect(() => platform.operatingSystemVersion, throwsA(isStateError));
      expect(platform.packageConfig, isNull);
      expect(() => platform.pathSeparator, throwsA(isStateError));
      expect(() => platform.resolvedExecutable, throwsA(isStateError));
      expect(() => platform.script, throwsA(isStateError));
      expect(() => platform.stdinSupportsAnsi, throwsA(isStateError));
      expect(() => platform.stdoutSupportsAnsi, throwsA(isStateError));
      expect(() => platform.version, throwsA(isStateError));
    });
  });

  group('runtime override', () {
    test('sync', () {
      var fake =
          FakeNativePlatform.from(original)
          .copyWith(operatingSystem: otherOS);
      expect(fake.operatingSystem, otherOS);
      fake.run(() {
        expect(NativePlatform.current, same(fake));
        expect(Platform.current.nativePlatform, same(fake));
        expect(NativePlatform.current?.operatingSystem, otherOS);
      });
    });
    test('async', () async {
      var currentNative = original;
      var fake = FakeNativePlatform.from(currentNative)
          .copyWith(operatingSystem: otherOS);
      var parts = 0;
      var asyncTesting = fake.run(() async {
        // Runs synchronously.
        expect(NativePlatform.current, same(fake));
        expect(Platform.current.nativePlatform, same(fake));
        expect(NativePlatform.current?.operatingSystem, otherOS);
        parts++;
        await Future(() {}); // Timer-delay.
        // Runs later.
        expect(NativePlatform.current, same(fake));
        expect(Platform.current.nativePlatform, same(fake));
        expect(NativePlatform.current?.operatingSystem, otherOS);
        parts++;
      });
      expect(parts, 1);
      expect(NativePlatform.current, same(original));
      expect(Platform.current.nativePlatform, same(original));
      expect(NativePlatform.current?.operatingSystem, original.operatingSystem);
      await asyncTesting;
      expect(parts, 2);
    });
  });
  group('nested overrides', () {
    final fakeNative =
        FakeNativePlatform.from(original)
        .copyWith(operatingSystem: otherOS);
    final fakeNative2 = FakeNativePlatform.from(fakeNative)
        .copyWith(operatingSystemVersion: otherVersion);
    test('sync', () {
      fakeNative.run(() {
        expect(NativePlatform.current, same(fakeNative));
        expect(Platform.current.nativePlatform, same(fakeNative));
        expect(NativePlatform.current?.operatingSystem, otherOS);
        expect(NativePlatform.current?.operatingSystemVersion,
            original.operatingSystemVersion);
        fakeNative2.run(() {
          expect(NativePlatform.current, same(fakeNative2));
          expect(Platform.current.nativePlatform, same(fakeNative2));
          expect(NativePlatform.current?.operatingSystem, otherOS);
          expect(NativePlatform.current?.operatingSystemVersion, otherVersion);
        });
        // Previous override restored when done.
        expect(NativePlatform.current, same(fakeNative));
        expect(Platform.current.nativePlatform, same(fakeNative));
        expect(NativePlatform.current?.operatingSystem, otherOS);
        expect(NativePlatform.current?.operatingSystemVersion,
            original.operatingSystemVersion);
      });
    });
    test('async', () async {
      await fakeNative.run(() async {
        expect(NativePlatform.current, same(fakeNative));
        expect(Platform.current.nativePlatform, same(fakeNative));
        expect(NativePlatform.current?.operatingSystem, otherOS);
        expect(NativePlatform.current?.operatingSystemVersion,
            original.operatingSystemVersion);
        var parts = 0;
        var asyncTesting = fakeNative2.run(() async {
          expect(NativePlatform.current, same(fakeNative2));
          expect(Platform.current.nativePlatform, same(fakeNative2));
          expect(NativePlatform.current?.operatingSystem, otherOS);
          expect(NativePlatform.current?.operatingSystemVersion, otherVersion);
          parts++;
          await Future(() {});
          expect(NativePlatform.current, same(fakeNative2));
          expect(Platform.current.nativePlatform, same(fakeNative2));
          expect(NativePlatform.current?.operatingSystem, otherOS);
          expect(NativePlatform.current?.operatingSystemVersion, otherVersion);
          parts++;
        });
        expect(parts, 1);
        // Previous override restored when done.
        expect(NativePlatform.current, same(fakeNative));
        expect(Platform.current.nativePlatform, same(fakeNative));
        expect(NativePlatform.current?.operatingSystem, otherOS);
        expect(NativePlatform.current?.operatingSystemVersion,
            original.operatingSystemVersion);
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

/// Check the properties of a [NativePlatform].
///
/// The [expectedValues] is uses the same format as JSON serialization of a
/// [NativePlatform].
///
/// If any of the expected values arguments are `null`, reading the
/// corresponding property is expected to throw a `StateError`
/// (except for `NativePackage.packageConfig` which is nullable).
/// If the operating system value is `null`, all the  `isAndroid`..`isWindows`
/// are expected to throw too.
/// Otherwise they are tested to give the expected true/false value
/// for the expected operating system.
void testNativeFake(
    NativePlatform actual, Map<String, Object?> expectedValues) {
  var expectedOS = expectedValues[json_key.operatingSystem] as String?;
  _testProperty(() => actual.operatingSystem, expectedOS);
  if (expectedOS == null) {
    expect(() => actual.isAndroid, throwsStateError);
    expect(() => actual.isFuchsia, throwsStateError);
    expect(() => actual.isIOS, throwsStateError);
    expect(() => actual.isLinux, throwsStateError);
    expect(() => actual.isMacOS, throwsStateError);
    expect(() => actual.isWindows, throwsStateError);
  } else {
    expect(actual.isAndroid, expectedOS == NativePlatform.android);
    expect(actual.isFuchsia, expectedOS == NativePlatform.fuchsia);
    expect(actual.isIOS, expectedOS == NativePlatform.iOS);
    expect(actual.isLinux, expectedOS == NativePlatform.linux);
    expect(actual.isMacOS, expectedOS == NativePlatform.macOS);
    expect(actual.isWindows, expectedOS == NativePlatform.windows);
  }
  _testProperty(() => actual.operatingSystemVersion,
      expectedValues[json_key.operatingSystemVersion]);
  _testProperty(() => actual.environment, expectedValues[json_key.environment]);
  _testProperty(() => actual.executable, expectedValues[json_key.executable]);
  _testProperty(() => actual.executableArguments,
      expectedValues[json_key.executableArguments]);
  _testProperty(
      () => actual.lineTerminator, expectedValues[json_key.lineTerminator]);
  _testProperty(() => actual.localeName, expectedValues[json_key.localeName]);
  _testProperty(
      () => actual.localHostname, expectedValues[json_key.localHostname]);
  _testProperty(() => actual.numberOfProcessors,
      expectedValues[json_key.numberOfProcessors]);
  // Package-config is nullable, so doesn't throw if null.
  expect(actual.packageConfig, expectedValues[json_key.packageConfig]);
  _testProperty(
      () => actual.pathSeparator, expectedValues[json_key.pathSeparator]);
  _testProperty(() => actual.resolvedExecutable,
      expectedValues[json_key.resolvedExecutable]);
  var scriptText = expectedValues[json_key.script] as String?;
  var scriptUri = scriptText != null ? Uri.parse(scriptText) : null;
  _testProperty(() => actual.script, scriptUri);
  _testProperty(() => actual.stdinSupportsAnsi,
      expectedValues[json_key.stdinSupportsAnsi]);
  _testProperty(() => actual.stdoutSupportsAnsi,
      expectedValues[json_key.stdoutSupportsAnsi]);
  _testProperty(() => actual.version, expectedValues[json_key.version]);
}
