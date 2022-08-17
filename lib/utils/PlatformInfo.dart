import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;

class PlatformInfo {
  bool isMobile() {
    return Platform.isAndroid || Platform.isIOS;
  }

  bool isDesktop() {
    return Platform.isLinux || Platform.isWindows || Platform.isMacOS;
  }

  bool isWeb() {
    return kIsWeb;
  }

  PlatformType getPlatformType() {
    if (kIsWeb) {
      return PlatformType.web;
    } else if (Platform.isMacOS) {
      return PlatformType.macOS;
    } else if (Platform.isWindows) {
      return PlatformType.windows;
    } else if (Platform.isLinux) {
      return PlatformType.linux;
    } else if (Platform.isAndroid) {
      return PlatformType.android;
    } else if (Platform.isIOS) {
      return PlatformType.iOS;
    }
    return PlatformType.unknown;
  }
}

enum PlatformType { web, android, iOS, macOS, windows, linux, unknown }
