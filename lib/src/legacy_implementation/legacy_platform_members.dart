// Copyright (c) 2024, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import '../platforms_impl.dart' as p;

// The members of the legacy `Platform` class, added to the new `Platform`
// class for backwards interface compatibility.
// Only works when used on a legacy [LocalPlatform] object or a
// legacy [FakePlatform] object (created using the deprecated constructors).
// Other instances of `Platform` uses this mixin to throw.
mixin LegacyPlatformMembers {
  /// A string representing the operating system.
  ///
  /// [!WARNING]
  /// This property is deprecated on `Platform`.
  /// It is only implemented by the legacy `LocalPlatform` and `FakePlatform`
  /// classes, and cannot be accessed through `Platform.current`.
  /// Use `NativePlatform` to access these properties instead, accessed as
  /// `Platform.current.nativePlatform`.
  @Deprecated('Use Platform.current.nativePlatform!.operatingSystem instead')
  String get operatingSystem =>
      throw UnimplementedError('Use Platform.current.nativePlatform instead');

  /// A string representing the version of the operating system or platform.
  ///
  /// [!WARNING]
  /// This property is deprecated on `Platform`.
  /// It is only implemented by the legacy `LocalPlatform` and `FakePlatform`
  /// classes, and cannot be accessed through `Platform.current`.
  /// Use `NativePlatform` to access these properties instead, accessed as
  /// `Platform.current.nativePlatform`.
  @Deprecated(
      'Use Platform.current.nativePlatform!.operatingSystemVersion instead')
  String get operatingSystemVersion => throw UnimplementedError(
      'Use Platform.current.nativePlatform!.operatingSystemVersion instead');

  /// The environment for this process.
  ///
  /// [!WARNING]
  /// This property is deprecated on `Platform`.
  /// It is only implemented by the legacy `LocalPlatform` and `FakePlatform`
  /// classes, and cannot be accessed through `Platform.current`.
  /// Use `NativePlatform` to access these properties instead, accessed as
  /// `Platform.current.nativePlatform`.
  ///
  /// The returned environment is an unmodifiable map whose content is
  /// retrieved from the operating system on its first use.
  ///
  /// Environment variables on Windows are case-insensitive. The map
  /// returned on Windows is therefore case-insensitive and will convert
  /// all keys to upper case. On other platforms the returned map is
  /// a standard case-sensitive map.
  @Deprecated('Use Platform.current.nativePlatform!.version instead')
  Map<String, String> get environment => throw UnimplementedError(
      'Use Platform.current.nativePlatform!.environment instead');

  /// The file path of the executable used to run the script in this isolate.
  ///
  /// [!WARNING]
  /// This property is deprecated on `Platform`.
  /// It is only implemented by the legacy `LocalPlatform` and `FakePlatform`
  /// classes, and cannot be accessed through `Platform.current`.
  /// Use `NativePlatform` to access these properties instead, accessed as
  /// `Platform.current.nativePlatform`.
  ///
  /// The file path returned is the literal path used to run the script.
  /// This path might be relative or just be a name from which the executable
  /// was found by searching the system path.
  ///
  /// For the absolute path to the resolved executable use [resolvedExecutable].
  @Deprecated('Use Platform.current.nativePlatform!.executable instead')
  String get executable => p.Platform.current.nativePlatform!.executable;

  /// The flags passed to the executable used to run the script of this program.
  ///
  /// [!WARNING]
  /// This property is deprecated on `Platform`.
  /// It is only implemented by the legacy `LocalPlatform` and `FakePlatform`
  /// classes, and cannot be accessed through `Platform.current`.
  /// Use `NativePlatform` to access these properties instead, accessed as
  /// `Platform.current.nativePlatform`.
  ///
  /// These are the command-line entries between the executable name
  /// and the script name. Each access to `executableArguments` returns a new
  /// list containing the flags passed to the executable.
  @Deprecated(
      'Use Platform.current.nativePlatform!.List!<executableArguments instead')
  List<String> get executableArguments => throw UnimplementedError(
      'Use Platform.current.nativePlatform!.executableArguments instead');

  /// Get the name of the current locale.
  ///
  /// [!WARNING]
  /// This property is deprecated on `Platform`.
  /// It is only implemented by the legacy `LocalPlatform` and `FakePlatform`
  /// classes, and cannot be accessed through `Platform.current`.
  /// Use `NativePlatform` to access these properties instead, accessed as
  /// `Platform.current.nativePlatform`.
  @Deprecated('Use Platform.current.nativePlatform!.localeName instead')
  String get localeName => throw UnimplementedError(
      'Use Platform.current.nativePlatform!.localeName instead');

  /// Get the local hostname for the system.
  ///
  /// [!WARNING]
  /// This property is deprecated on `Platform`.
  /// It is only implemented by the legacy `LocalPlatform` and `FakePlatform`
  /// classes, and cannot be accessed through `Platform.current`.
  /// Use `NativePlatform` to access these properties instead, accessed as
  /// `Platform.current.nativePlatform`.
  @Deprecated('Use Platform.current.nativePlatform!.localHostname instead')
  String get localHostname => throw UnimplementedError(
      'Use Platform.current.nativePlatform!.localHostname instead');

  /// The number of processors of the machine.
  ///
  /// [!WARNING]
  /// This property is deprecated on `Platform`.
  /// It is only implemented by the legacy `LocalPlatform` and `FakePlatform`
  /// classes, and cannot be accessed through `Platform.current`.
  /// Use `NativePlatform` to access these properties instead, accessed as
  /// `Platform.current.nativePlatform`.
  @Deprecated('Use Platform.current.nativePlatform!.numberOfProcessors instead')
  int get numberOfProcessors => throw UnimplementedError(
      'Use Platform.current.nativePlatform!.numberOfProcessors instead');

  /// The value of the `--packages` flag passed to the executable
  /// used to run the script in this isolate. This is the configuration which
  /// specifies how Dart packages are looked up.
  ///
  /// [!WARNING]
  /// This property is deprecated on `Platform`.
  /// It is only implemented by the legacy `LocalPlatform` and `FakePlatform`
  /// classes, and cannot be accessed through `Platform.current`.
  /// Use `NativePlatform` to access these properties instead, accessed as
  /// `Platform.current.nativePlatform`.
  ///
  /// If there is no `--packages` flag, `null` is returned.
  @Deprecated('Use Platform.current.nativePlatform!.packageConfig instead')
  String? get packageConfig => throw UnimplementedError(
      'Use Platform.current.nativePlatform!.packageConfig instead');

  /// The path separator used by the operating system to separate
  /// components in file paths.
  ///
  /// [!WARNING]
  /// This property is deprecated on `Platform`.
  /// It is only implemented by the legacy `LocalPlatform` and `FakePlatform`
  /// classes, and cannot be accessed through `Platform.current`.
  /// Use `NativePlatform` to access these properties instead, accessed as
  /// `Platform.current.nativePlatform`.
  @Deprecated('Use Platform.current.nativePlatform!.pathSeparator instead')
  String get pathSeparator => throw UnimplementedError(
      'Use Platform.current.nativePlatform!.pathSeparator instead');

  /// The path of the executable used to run the script in this
  /// isolate after it has been resolved by the OS.
  ///
  /// [!WARNING]
  /// This property is deprecated on `Platform`.
  /// It is only implemented by the legacy `LocalPlatform` and `FakePlatform`
  /// classes, and cannot be accessed through `Platform.current`.
  /// Use `NativePlatform` to access these properties instead, accessed as
  /// `Platform.current.nativePlatform`.
  ///
  /// This is the absolute path, with all symlinks resolved, to the
  /// executable used to run the script.
  @Deprecated('Use Platform.current.nativePlatform!.resolvedExecutable instead')
  String get resolvedExecutable => throw UnimplementedError(
      'Use Platform.current.nativePlatform!.resolvedExecutable instead');

  /// The absolute URI of the script being run in this isolate.
  ///
  /// [!WARNING]
  /// This property is deprecated on `Platform`.
  /// It is only implemented by the legacy `LocalPlatform` and `FakePlatform`
  /// classes, and cannot be accessed through `Platform.current`.
  /// Use `NativePlatform` to access these properties instead, accessed as
  /// `Platform.current.nativePlatform`.
  ///
  /// If the script argument on the command line is relative,
  /// it is resolved to an absolute URI before fetching the script, and
  /// this absolute URI is returned.
  ///
  /// URI resolution only does string manipulation on the script path, and this
  /// may be different from the file system's path resolution behavior. For
  /// example, a symbolic link immediately followed by '..' will not be
  /// looked up.
  ///
  /// If the executable environment does not support [script] an empty
  /// [Uri] is returned.
  @Deprecated('Use Platform.current.nativePlatform!.script instead')
  Uri get script => throw UnimplementedError(
      'Use Platform.current.nativePlatform!.script instead');

  /// When stdin is connected to a terminal, whether ANSI codes are supported.
  ///
  /// [!WARNING]
  /// This property is deprecated on `Platform`.
  /// It is only implemented by the legacy `LocalPlatform` and `FakePlatform`
  /// classes, and cannot be accessed through `Platform.current`.
  /// Use `NativePlatform` to access these properties instead, accessed as
  /// `Platform.current.nativePlatform`.
  @Deprecated('Use Platform.current.nativePlatform!.stdinSupportsAnsi instead')
  bool get stdinSupportsAnsi => throw UnimplementedError(
      'Use Platform.current.nativePlatform!.stdinSupportsAnsi instead');

  /// When stdout is connected to a terminal, whether ANSI codes are supported.
  ///
  /// [!WARNING]
  /// This property is deprecated on `Platform`.
  /// It is only implemented by the legacy `LocalPlatform` and `FakePlatform`
  /// classes, and cannot be accessed through `Platform.current`.
  /// Use `NativePlatform` to access these properties instead, accessed as
  /// `Platform.current.nativePlatform`.
  @Deprecated('Use Platform.current.nativePlatform!.stdoutSupportsAnsi instead')
  bool get stdoutSupportsAnsi => throw UnimplementedError(
      'Use Platform.current.nativePlatform!.stdoutSupportsAnsi instead');

  /// The version of the current Dart runtime.
  ///
  /// [!WARNING]
  /// This property is deprecated on `Platform`.
  /// It is only implemented by the legacy `LocalPlatform` and `FakePlatform`
  /// classes, and cannot be accessed through `Platform.current`.
  /// Use `NativePlatform` to access these properties instead, accessed as
  /// `Platform.current.nativePlatform`.
  ///
  /// The returned `String` is formatted as the [semver](http://semver.org)
  /// version string of the current dart runtime, possibly followed by
  /// whitespace and other version and build details.
  @Deprecated('Use Platform.current.nativePlatform!.version instead')
  String get version => throw UnimplementedError(
      'Use Platform.current.nativePlatform!.version instead');

  /// A JSON-encoded representation of platform information.
  ///
  /// [!WARNING]
  /// This property is deprecated on `Platform`.
  /// It is only implemented by the legacy `LocalPlatform` and `FakePlatform`
  /// classes, and cannot be accessed through `Platform.current`.
  /// Use `NativePlatform` to access these properties instead, accessed as
  /// `Platform.current.nativePlatform`.
  ///
  /// Can be emitted for debugging, or be used as input to a fake environment
  /// used for debugging.
  String toJson() => throw UnimplementedError(
      'Use Platform.current.nativePlatform!.toJson instead');
}
