part of 'platform_tools.dart';

class PlatformToolsInfo {
  PlatformToolsInfo.fallback({
    this.appVersion = '-',
    this.appBuild = '-',
    this.appName = '-',
    this.appBundle = '-',
    this.uuid = '-',
    this.osVersion = '-',
    this.manufacturer = '-',
    this.brand = '-',
    this.model = '-',
    this.isTablet = false,
    this.isMIUI = false,
    this.isGMS = false,
    this.isHMS = false,
  }) : _json = const {};

  PlatformToolsInfo.fromJson(this._json)
      : appVersion = _json['app_version'],
        appBundle = _json['app_bundle'],
        appBuild = _json['app_build'],
        appName = _json['app_name'],
        uuid = _json['uuid'],
        osVersion = _json['os_version'],
        manufacturer = _json['manufacturer'],
        brand = _json['brand'],
        model = _json['model'],
        isTablet = _json['is_tablet'],
        isMIUI = _json['is_miui'],
        isGMS = _json['is_gms'],
        isHMS = _json['is_hms'];

  final Map<String, dynamic> _json;

  final String appVersion;
  final String appBundle;
  final String appBuild;
  final String appName;

  final String uuid;
  final String osVersion;
  final String manufacturer;
  final String brand;
  final String model;
  final bool isTablet;
  final bool isMIUI;
  final bool isGMS;
  final bool isHMS;

  Map<String, dynamic> toJson() => _json;

  @override
  String toString() =>
      'PlatformToolsInfo(appVersion:$appVersion, appBundle:$appBundle, appBuild:$appBuild, appName:$appName, uuid:$uuid, osVersion:$osVersion, manufacturer:$manufacturer, brand:$brand, model:$model, isTablet:$isTablet, isMIUI:$isMIUI, isGMS:$isGMS, isHMS:$isHMS)';
}
