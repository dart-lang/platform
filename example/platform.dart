// Copyright (c) 2024, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:platform/platform.dart';

void main(List<String> arguments) {
  final platform = Platform.current.nativePlatform;
  if (platform == null) {
    print('This program only supports execution on native platforms.');
  } else {
    print('Operating System: ${platform.operatingSystem}.');
    print('Local Hostname: ${platform.localHostname}.');
    print('Number of Processors: ${platform.numberOfProcessors}.');
    print('Path Separator: ${platform.pathSeparator}.');
    print('Locale Name: ${platform.localeName}.');
    print('Stdin Supports ANSI: ${yn(platform.stdinSupportsAnsi)}.');
    print('Stdout Supports ANSI: ${yn(platform.stdoutSupportsAnsi)}.');
    print('Executable Arguments: ${platform.executableArguments}.');
    print('Dart Version: ${platform.version}.');
  }
}

String yn(bool yesOrNo) => yesOrNo ? 'yes' : 'no';
