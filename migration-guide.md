# Migration guide

This migration guide details how to migrate to `package:platform` version 3.2,
from earlier Dart platform APIs located in:

  - `dart:io`
  - `package:platform` version 3.1
  - `package:os_detect`

# From `dart:io`

The `dart:io` core library is only available on Dart native platforms 
(and, for example, not available on Dart web platforms). 
We recommend migration to `package:platform` version 3.2, as the APIs in
`package:platform/platform.dart` are available on all current platforms. For the
additional native-only APIs, those available in `package:platform/native.dart`.

_Note: This migration can be performed automatically by running `dart fix`._

### General platform APIs

The `dart:io` library exposes host platform information as static members of the
`Platform` class. This API has historically been made available on some
platforms that don't otherwise support `dart:io`.

To migrate uses of that API to `package:platform` v4.x, use the similarly-named
members on the `HostPlatform.current` object.

Migrate from:
```dart
import 'dart:io';

bool onAndroid = Platform.isAndroid;
```

To:
```dart
import 'package:platform/platform.dart';

bool onAndroid = Platform.current.isAndroid;
```

### Native-only 

The remaining `dart:io` APIs on the `Platform` class, are only available on
native platforms (and not, for example, on the web).

To migrate those to `package:platform`, use the `nativePlatform` getter. Note
that this will return `null` when not on a native platform. You can test if you
are on a native platform using `Platform.current.isNative`.

Migrate from:
```dart
import 'dart:io';

String hostname = Platform.localHostname;
```

To:
```dart
import 'package:platform/platform.dart';

if (Platform.current.isNative) {
  String hostname = Platform.current.nativePlatform!.localHostname;
}
```

# From `package:platform` version 3.1

_Note: This migration can be performed automatically by running `dart fix`._

### General platform APIs

The general APIs in `package:platform` v3.1, that determine what the host
platform is, rely on instantiating an instance of the `LocalPlatform` class. In
v3.2 a new convenience `.current` getter can be used, which returns the current
host platform.

Migrate from:
```dart
import 'package:platform/platform.dart'; // version 3.1

bool onAndroid = LocalPlatform().isAndroid;
```

To:
```dart
import 'package:platform/platform.dart';     // version 3.2

bool onAndroid = Platform.current.isAndroid;
```

### Native-only 

APIs in `package:platform` which are available only on native platforms (and
not, for example, on the web) have been moved to the `NativePlatform` class,
accessible via the `nativePlatform` getter. Note that this getter will return
`null` when not on a native platform. You can test if you are on a native
platform using `Platform.current.isNative`.


Migrate from:
```dart
import 'package:platform/platform.dart';    // version 3.1

String hostname = LocalPlatform().localHostname;
```

To:
```dart
import 'package:platform/platform.dart';    // version 3.2

if (Platform.current.isNative) {
  String hostname = Platform.current.nativePlatform!.localHostname;
  print(hostname);
}
```

# From package:os_detect

_Note: This migration can be performed automatically by running `dart fix`._

### General platform APIs

Migrate from:
```dart
import 'package:os_detect/os_detect.dart' as Platform;

bool onAndroid = Platform.isAndroid;
```

To:
```dart
import 'package:platform/host.dart';

bool onAndroid = Platform.current.isAndroid;
```

### Native-only 

`package:os_detect` has no native-only APIs.
