// Copyright (c) 2024, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

// Example code using legacy APIs. Used to test automatic migration.
// Uses every legacy API member.
//
// To test migration of this file, run `dart tool/check_migration.dart` from
// the project root.

// REMOVE NEXT LINE BEFORE TESTING MIGRATION DIRECTLY:
// ignore_for_file: deprecated_member_use_from_same_package
// (The `tools/test_migration.dart` script removes the line.)

import 'package:platform/platform.dart';

void main() {
  var fakePlatform = FakePlatform(executable: 'pineapple');
  if (fakePlatform.executable == 'apricot') throw AssertionError('Not it');
}
