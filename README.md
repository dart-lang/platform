[![Pub](https://img.shields.io/pub/v/platform.svg)](https://pub.dartlang.org/packages/platform)

## Moved

The source for the `platform` package has moved to [the `flutter/packages`
repository](https://github.com/flutter/packages/tree/main/packages/platform).

-----

A generic platform abstraction for Dart.

Like `dart:io`, `package:platform` supplies a rich, Dart-idiomatic API for
accessing platform-specific information.

`package:platform` provides a lightweight wrapper around the static `Platform`
properties that exist in `dart:io`. However, it uses instance properties rather
than static properties, making it possible to mock out in tests.
