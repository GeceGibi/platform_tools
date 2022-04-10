import 'dart:async';
// In order to *not* need this ignore, consider extracting the "web" version
// of your plugin as a separate package, instead of inlining it in the same
// package as the core of your plugin.
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html show window, Navigator;
import 'dart:ui';

import 'package:flutter/services.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';

/// A web implementation of the Platformtools plugin.
class PlatformToolsPlugin {
  PlatformToolsPlugin(this._navigator);

  final html.Navigator _navigator;

  static void registerWith(Registrar registrar) {
    final channel = MethodChannel(
      'gecegibi/platform_tools',
      const StandardMethodCodec(),
      registrar,
    );

    final pluginInstance = PlatformToolsPlugin(html.window.navigator);
    channel.setMethodCallHandler(pluginInstance.handleMethodCall);
  }

  /// Handles method calls over the MethodChannel of this plugin.
  /// Note: Check the "federated" architecture for a new way of doing this:
  /// https://flutter.dev/go/federated-plugins
  Future<dynamic> handleMethodCall(MethodCall call) async {
    switch (call.method) {
      case 'badge_update':
      case 'app_settings':
      case 'app_notification_settings':
        // no-op
        break;

      case 'info':
        return getInfo();

      default:
        throw PlatformException(
          code: 'Unimplemented',
          details:
              'platformtools for web doesn\'t implement \'${call.method}\'',
        );
    }
  }

  Future<Map<String, dynamic>> getInfo() {
    return Future.value({
      'appVersion': 'UNKNOWN',
      'appBuild': 'UNKNOWN',
      'appName': 'UNKNOWN',
      "appBundle": 'UNKNOWN',
      "isTablet": false,
      "uuid": 'UNKNOWN',
      "systemVersion": _navigator.userAgent,
      "manufacturer": _navigator.platform,
      "service": "UNKNOWN",
      "brand": 'UNKNOWN',
      "model": 'UNKNOWN',
      "isMIUI": false
    });
  }
}
