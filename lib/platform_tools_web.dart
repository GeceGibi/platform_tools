import 'dart:async';
import 'dart:html' as html;

import 'package:flutter/services.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:platform_tools/platform_tools.dart' show PlatformToolsInfo;

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
