#! /bin/env dart
// Copyright (c) 2024, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

// Run this script as
//
//     dart check_migration.dart
//
// or
//
//     dart tool/check_migration.dart
//
// from the package root directory.
//
// It will compile copy `../test/legacy/legacy_example_code.dart` to
// a temporary directory (`../tmp/`), remove the line guarding its
// deprecated uses, and run `dart fix` on the code.
// It will then run `dart analyze` to see if there are any deprecated
// uses left.
//
// (The script uses `Platform.executable` from `dart:io` as the compiler,
// which is why it must be invoked with that compiler.)

// ignore_for_file: prefer_single_quotes

import 'dart:io';

import 'src/dart_sdk.dart';
import 'src/path.dart' as path;
import 'src/tmp_dir.dart';

int verbose = 0;

void main(List<String> args) {
  // Keep the files after running.
  var retain = false;
  var retainOnError = false;
  for (var arg in args) {
    if (arg == '-r') {
      retainOnError = true;
    } else if (arg == '-R') {
      retain = retainOnError = true;
    } else if (arg == '-v') {
      verbose++;
    } else {
      stderr.writeln('Unexpected argument: $arg');
    }
  }

  // Try to detect whether this script was run by the `dart` CLI.
  //
  // Currently it assumes so if the executable exists and is named `dart`
  // or `dart.exe`.
  var dartExe = findDartExe();
  if (dartExe == null) {
    stderr.writeln('Must be run with the Dart CLI executable.');
    exit(1);
  }

  var selfPath = File.fromUri(Platform.script).path;

  var migrationTestDir = createTmpDir('migration_test', verbose: verbose);

  var sourceFileDir = path.join(path.directory(selfPath), 'src', 'sample');
  for (var sourceFile in Directory(sourceFileDir).listSync()) {
    var sourceFilePath = sourceFile.path;
    if (sourceFile is! File ||
        !sourceFilePath.endsWith('dart') ||
        !sourceFilePath.contains('example_code')) {
      continue;
    }
    var fileName = sourceFilePath.substring(sourceFileDir.length + 1);
    var content = sourceFile.readAsStringSync();
    content = content.replaceFirst(
        ' ignore_for_file: deprecated_member_use_from_same_package', '');
    var testFile = File(path.join(migrationTestDir.path, fileName));
    testFile.writeAsStringSync(content);
    // Run `dart fix` on file.
    if (verbose > 0) {
      stdout.writeln("Running: dart fix --apply ${testFile.path}");
    }
    var dartFixResult = run(dartExe, [
      'fix',
      '--apply',
      testFile.path,
    ]);
    if (dartFixResult.exitCode != 0) {
      stderr.writeln('FAILED($dartFixResult.exitCode):'
          'dart fix --apply ${testFile.path}');
      printProcessOutput(dartFixResult);
      if (!retainOnError) {
        migrationTestDir.deleteSync(recursive: true);
      }
      exit(1);
    }
    stderr.writeln(dartFixResult.stdout);

    if (verbose > 0) {
      stdout.writeln('Running: dart analyze ${testFile.path}');
    }
    var dartAnalyzeResult = run(dartExe, [
      'analyze',
      testFile.path,
    ]);
    stdout.writeln(dartAnalyzeResult.stdout);
    var diffres = Process.runSync("/bin/diff", [sourceFilePath, testFile.path],
        runInShell: true);
    print(diffres.stdout);
  }

  if (!retain) {
    if (verbose > 1) {
      stderr.writeln('Deleting directory: ${migrationTestDir.path}');
    }
    migrationTestDir.deleteSync(recursive: true);
  }
}
