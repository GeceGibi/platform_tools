import 'dart:async';
import 'package:flutter/services.dart';
import 'package:platformtools/platform_tools_model.dart';

class PlatformTools {
  static const _channel = MethodChannel('gecegibi/platform_tools');

  static void openAppSettings() {
    _channel.invokeMethod('app_settings');
  }

  static void openAppNotificationSettings() {
    _channel.invokeMethod('app_notification_settings');
  }

  static Future<PlatformToolsInfo> getDeviceInfo() async {
    try {
      final info = await _channel.invokeMapMethod('info');
      return PlatformToolsInfo.fromJson(Map<String, dynamic>.from(info ?? {}));
    } catch (e) {
      return PlatformToolsInfo.fallback();
    }
  }

  static void badgeUpdate(int value) {
    _channel.invokeMethod('badge_update', value);
  }
}
