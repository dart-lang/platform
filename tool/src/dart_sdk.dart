// Copyright (c) 2024, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

/// Utilities for finding and running the Dart SDK `dart` CLI command.
library;

import 'dart:convert' show utf8;
import 'dart:io' show File, IOSink, Platform, Process, ProcessResult, stdout;

/// Finds the `dart` executable.
///
/// Checks if [Platform.executable] is called `dart` or `dart.exe`,
/// and if so, returns it. Otherwise returns `null`.
File? findDartExe() {
  var dartExe = File(Platform.executable);
  if (dartExe.existsSync()) {
    var exeUri = dartExe.uri;
    // If someone compiles this file to dart.exe and runs it, we don't want an
    // infinite loop.
    if (exeUri != Platform.script) {
      var exeName = exeUri.pathSegments.last;
      if (exeName == 'dart' || exeName.toLowerCase() == 'dart.exe') {
        return dartExe;
      }
    }
  }
  return null;
}

/// Runs [File] with command line [arguments].
///
/// Used to run the Dart SDK `dart` CLI application.
///
/// Sets stdout/stderr encoding to UTF-8 so that [ProcessResult.stdout]
/// and [ProcessResult.stderr] of the result will be [String]s.
ProcessResult run(File exe, List<String> arguments) => Process.runSync(
    exe.path,
    includeParentEnvironment: true,
    stdoutEncoding: utf8,
    stderrEncoding: utf8,
    arguments);

/// Writes [result.stdout][ProcessResult.stdout] and
/// [result.stderr][ProcessResult.stderr] to [on].
///
/// If [on] is not provided, it defaults to [stdout].
void printProcessOutput(ProcessResult result, {IOSink? on}) {
  on ??= stdout;
  var out = result.stdout as String;
  if (out.isNotEmpty) {
    on
      ..writeln('STDOUT:')
      ..writeln(out);
  }
  var err = result.stderr as String;
  if (err.isNotEmpty) {
    on
      ..writeln('STDERR:')
      ..writeln(err);
  }
}
