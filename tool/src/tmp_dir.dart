// Copyright (c) 2024, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

/// Utility for creating a `tmp/` directory.
library;

import 'dart:io';

import 'path.dart';

/// Finds or creates a subdirectory of `tmp/` directory in the package root.
///
/// The `tmp/` directory is listed in `.gitignore`, so it should
/// not affect version control.
/// If the `tmp/$subDirectoryName` already exists, it is deleted
/// and then recreated.
///
/// If [verbose] is provided and greater than 0, creation is reported.
/// If greater than 1, deleting of an existing directory is also reported.
Directory createTmpDir(String subDirectoryName, {int verbose = 0}) {
  var tmpPath =
      join(parentDirectory(File.fromUri(Platform.script).path), 'tmp');
  var tmpDir = Directory(tmpPath);
  if (!tmpDir.existsSync()) {
    if (verbose > 1) {
      stderr.writeln('Creating tmp/ directory: $tmpPath');
    }
    tmpDir.createSync(); // Throws if exists as non-directory.
  }
  var subDirPath = join(tmpDir.path, subDirectoryName, '');
  var subDir = Directory(subDirPath);
  if (subDir.existsSync()) {
    if (verbose > 1) {
      stderr.writeln('Deleting directory: ${subDir.path}');
    }
    subDir.deleteSync(recursive: true);
  }
  if (verbose > 0) {
    stderr.writeln('Creating directory: ${subDir.path}');
  }
  subDir.createSync(recursive: true);
  return subDir;
}
