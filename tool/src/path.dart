// Copyright (c) 2024, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.
import 'dart:io';

final separator = Platform.pathSeparator;

/// Joins paths with path separators.
///
/// Inserts path separator between segments if neither
/// surrounding part has a path separator already.
///
/// A segment that is empty or a single [separator]
/// adds a separator at the end if needed, but nothing else.
String join(String path, String segment1,
    [String? segment2, String? segment3]) {
  var buffer = StringBuffer(path);
  var needsSeparator = path.isNotEmpty && !path.endsWith(separator);
  void add(String? next) {
    if (next == null) return;
    if (next.isEmpty || next == separator) {
      if (needsSeparator) {
        buffer.write(separator);
        needsSeparator = false;
      }
      return;
    }
    var nextStartsWithSeparator = next.startsWith(separator);
    if (needsSeparator) {
      if (!nextStartsWithSeparator) buffer.write(separator);
    } else if (nextStartsWithSeparator) {
      next = next.substring(1);
    }
    buffer.write(next);
    needsSeparator = !next.endsWith(separator);
  }

  add(segment1);
  add(segment2);
  add(segment3);
  return buffer.toString();
}

/// The file-name of [path].
///
/// Everything after the last path separator.
/// Empty if the path ends with a path separator, or is empty.
String filename(String path) => path.substring(path.lastIndexOf(separator) + 1);

/// The directory of the [path].
///
/// Everything up to and including the last path separator.
/// Empty string if there is no path separator.
/// Always ends with a path separator if not empty.
String directory(String path) {
  var lastSeparator = path.lastIndexOf(separator);
  return path.substring(0, lastSeparator + 1);
}

/// The parent directory of [path].
///
/// Everything up to and including the second-to-last path separator.
/// Empty string if [path] has less than two path separators,
/// unless it starts with a path separator (it's an absolute path),
/// in which case the root path is returned.
///
/// Does not understand embedded `/../` segments and treats them
/// as any other path segment. Don't have such.
///
/// What you would get by resolving `../`.
String parentDirectory(String path) {
  var lastSeparator = path.lastIndexOf(separator);
  if (lastSeparator < 0) return '';
  if (lastSeparator == 0) return separator;
  var secondLastSeparator = path.lastIndexOf(separator, lastSeparator - 1);
  if (secondLastSeparator < 0) return '';
  if (secondLastSeparator == 0) return separator;
  return path.substring(0, secondLastSeparator + 1);
}
