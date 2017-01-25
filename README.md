# Platform

[![Build Status -](https://travis-ci.org/tvolkert/platform.svg?branch=master)](https://travis-ci.org/tvolkert/platform)
[![Coverage Status -](https://coveralls.io/repos/github/tvolkert/platform/badge.svg?branch=master)](https://coveralls.io/github/tvolkert/platform?branch=master)

A generic platform abstraction for Dart.

Like `dart:io`, `package:platform` supplies a rich, Dart-idiomatic API for
accessing platform-specific information.

`package:platform` provides a lightweight wrapper around the static `Platform`
properties that exist in `dart:io`. However, it uses instance properties rather
than static properties, making it possible to mock out in tests.
