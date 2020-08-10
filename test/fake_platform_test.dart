// Copyright (c) 2017, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:io' as io;

import 'package:platform/platform.dart';
import 'package:test/test.dart';

void _expectPlatformsEqual(Platform actual, Platform expected) {
  expect(actual.numberOfProcessors, expected.numberOfProcessors);
  expect(actual.pathSeparator, expected.pathSeparator);
  expect(actual.operatingSystem, expected.operatingSystem);
  expect(actual.operatingSystemVersion, expected.operatingSystemVersion);
  expect(actual.localHostname, expected.localHostname);
  expect(actual.environment, expected.environment);
  expect(actual.executable, expected.executable);
  expect(actual.resolvedExecutable, expected.resolvedExecutable);
  expect(actual.script, expected.script);
  expect(actual.executableArguments, expected.executableArguments);
  expect(
      actual.packageRoot, // ignore: deprecated_member_use_from_same_package
      expected.packageRoot); // ignore: deprecated_member_use_from_same_package
  expect(actual.packageConfig, expected.packageConfig);
  expect(actual.version, expected.version);
  expect(actual.localeName, expected.localeName);
}

void main() {
  group('FakePlatform', () {
    late FakePlatform fake;
    late LocalPlatform local;

    setUp(() {
      fake = new FakePlatform();
      local = new LocalPlatform();
    });

    group('fromPlatform', () {
      setUp(() {
        fake = new FakePlatform.fromPlatform(local);
      });

      test('copiesAllProperties', () {
        _expectPlatformsEqual(fake, local);
      });

      test('convertsPropertiesToMutable', () {
        String key = fake.environment.keys.first;

        expect(fake.environment[key], local.environment[key]);
        fake.environment[key] = 'FAKE';
        expect(fake.environment[key], 'FAKE');

        expect(
            fake.executableArguments.length, local.executableArguments.length);
        fake.executableArguments.add('ARG');
        expect(fake.executableArguments.last, 'ARG');
      });
    });

    group('json', () {
      test('fromJson', () {
        String json = new io.File('test/platform.json').readAsStringSync();
        fake = new FakePlatform.fromJson(json);
        expect(fake.numberOfProcessors, 8);
        expect(fake.pathSeparator, '/');
        expect(fake.operatingSystem, 'macos');
        expect(fake.operatingSystemVersion, '10.14.5');
        expect(fake.localHostname, 'platform.test.org');
        expect(fake.environment, <String, String>{
          'PATH': '/bin',
          'PWD': '/platform',
        });
        expect(fake.executable, '/bin/dart');
        expect(fake.resolvedExecutable, '/bin/dart');
        expect(fake.script,
            new Uri.file('/platform/test/fake_platform_test.dart'));
        expect(fake.executableArguments, <String>['--checked']);
        expect(fake.packageRoot, null);
        expect(fake.packageConfig, null);
        expect(fake.version, '1.22.0');
        expect(fake.localeName, 'de/de');
      });

      test('fromJsonToJson', () {
        fake = new FakePlatform.fromJson(local.toJson());
        _expectPlatformsEqual(fake, local);
      });
    });
  });

  test('Throws when unset non-null values are read', () {
    final FakePlatform platform = FakePlatform();

    expect(() => platform.numberOfProcessors, throwsA(isStateError));
    expect(() => platform.pathSeparator, throwsA(isStateError));
    expect(() => platform.operatingSystem, throwsA(isStateError));
    expect(() => platform.operatingSystemVersion, throwsA(isStateError));
    expect(() => platform.localHostname, throwsA(isStateError));
    expect(() => platform.environment, throwsA(isStateError));
    expect(() => platform.executable, throwsA(isStateError));
    expect(() => platform.resolvedExecutable, throwsA(isStateError));
    expect(() => platform.script, throwsA(isStateError));
    expect(() => platform.executableArguments, throwsA(isStateError));
    expect(() => platform.version, throwsA(isStateError));
    expect(() => platform.localeName, throwsA(isStateError));
  });
}
