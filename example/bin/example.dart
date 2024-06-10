import 'package:platform/platform.dart';

void main(List<String> arguments) {
  const LocalPlatform platform = LocalPlatform();

  print('Operating System: ${platform.operatingSystem}.');
  print('Local Hostname: ${platform.localHostname}.');
  print('Number of Processors: ${platform.numberOfProcessors}.');
  print('Path Separator: ${platform.pathSeparator}.');
  print('Locale Name: ${platform.localeName}.');
  print('Stdin Supports ANSI: ${platform.stdinSupportsAnsi}.');
  print('Stdout Supports ANSI: ${platform.stdoutSupportsAnsi}.');
  print('Executable Arguments: ${platform.executableArguments}.');
  print('Dart Version: ${platform.version}.');
}
