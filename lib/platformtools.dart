import 'dart:async';

import 'package:flutter/services.dart';

class PlatformTools {
  static const _channel = MethodChannel('gecegibi/platform_tools');

  static void openAppSettings() {
    _channel.invokeMethod('app_settings');
  }

  static void openAppNotificationSettings() {
    _channel.invokeMethod('app_notification_settings');
  }

  static Future<Map<String, dynamic>> getDeviceInfo() async {
    return await _channel.invokeMapMethod<String, dynamic>('info') ?? {};
  }

  static void badgeUpdate(int value) {
    _channel.invokeMethod('badge_update', value);
  }
}
