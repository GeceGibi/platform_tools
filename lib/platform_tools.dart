import 'dart:async';
import 'package:flutter/services.dart';

part 'platform_tools_model.dart';

enum TrackingRequestReponse {
  notDetermined,
  restricted,
  denied,
  authorized,
  notSupported
}

class PlatformTools {
  static const _channel = MethodChannel('gecegibi/platform_tools');

  static void openAppSettings() {
    _channel.invokeMethod('app_settings');
  }

  static void openAppNotificationSettings() {
    _channel.invokeMethod('app_notification_settings');
  }

  static Future<DeviceInfo> getDeviceInfo() async {
    try {
      final info = await _channel.invokeMapMethod('info');
      return DeviceInfo.fromJson(Map<String, dynamic>.from(info ?? {}));
    } catch (e) {
      return DeviceInfo.fallback();
    }
  }

  static void badgeUpdate(int value) {
    _channel.invokeMethod('badge_update', value);
  }

  static Future<TrackingRequestReponse> requestTrackingAuthorization() async {
    //? notDetermined = 0
    //? restricted = 1
    //? denied = 2
    //? authorized = 3
    //? notSupported = 4
    switch (await _channel.invokeMethod('request_tracking_authorization')) {
      case 1:
        return TrackingRequestReponse.restricted;
      case 2:
        return TrackingRequestReponse.denied;
      case 3:
        return TrackingRequestReponse.authorized;
      case 4:
        return TrackingRequestReponse.notSupported;

      case 0:
      default:
        return TrackingRequestReponse.notDetermined;
    }
  }
}
