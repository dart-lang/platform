// Copyright (c) 2024, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

// Example code using legacy APIs. Used to test automatic migration.
// Uses every legacy API member.
//
// To test migration of this file, run `dart tool/check_migration.dart` from
// the project root.

// ignore_for_file: omit_local_variable_types, prefer_const_constructors

// REMOVE NEXT LINE BEFORE TESTING MIGRATION DIRECTLY:
// ignore_for_file: deprecated_member_use_from_same_package
// (The `tools/test_migration.dart` script removes the line.)


import 'package:platform/platform.dart';
import 'package:platform/platform.dart' as prefix;

void main() {
  direct();
  withPrefix();
}

void direct() {
  LocalPlatform local = LocalPlatform();
  FakePlatform fakePlatform =
      FakePlatform.fromJson(local.toJson()).copyWith(executable: 'pineapple');

  // Use as type.
  if ((local as dynamic) is! Platform) {
    print('Local platform is not platform?');
  }
  if ((local as dynamic) is! LocalPlatform) {
    print('Local platform is not local platform?');
  }
  if ((fakePlatform as dynamic) is! FakePlatform) {
    print('Fake platform is not fake platform?');
  }

  Platform platform = fakePlatform;
  if (fakePlatform.executable == 'apricot') throw AssertionError('Not it');
  if (platform.executable == 'apricot') throw AssertionError('Not it');
}

void withPrefix() {
  prefix.LocalPlatform local = prefix.LocalPlatform();
  prefix.FakePlatform fakePlatform =
      prefix.FakePlatform.fromJson(local.toJson())
          .copyWith(executable: 'pineapple');

  // Use as type.
  if ((local as dynamic) is! prefix.Platform) {
    print('Local platform is not platform?');
  }
  if ((local as dynamic) is! prefix.LocalPlatform) {
    print('Local platform is not local platform?');
  }
  if ((fakePlatform as dynamic) is! prefix.FakePlatform) {
    print('Fake platform is not fake platform?');
  }

  prefix.Platform platform = fakePlatform;
  if (fakePlatform.executable == 'apricot') throw AssertionError('Not it');
  if (platform.executable == 'apricot') throw AssertionError('Not it');
}
