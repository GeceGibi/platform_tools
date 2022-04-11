import 'dart:async';
// In order to *not* need this ignore, consider extracting the "web" version
// of your plugin as a separate package, instead of inlining it in the same
// package as the core of your plugin.
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html show window, Navigator;

import 'package:flutter/services.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:platformtools/platform_tools_model.dart';

/// A web implementation of the Platformtools plugin.
class PlatformToolsPlugin {
  const PlatformToolsPlugin(this._navigator);

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

  Future<PlatformToolsInfo> getInfo() async {
    return PlatformToolsInfo.fallback(
      appVersion: _navigator.appVersion,
      appBuild: _navigator.appCodeName,
      appName: _navigator.appName,
    );
  }
}
