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
  });

  PlatformToolsInfo.fromJson(Map<String, dynamic> json)
      : appVersion = json['app_version'],
        appBundle = json['app_bundle'],
        appBuild = json['app_build'],
        appName = json['app_name'],
        uuid = json['uuid'],
        osVersion = json['os_version'],
        manufacturer = json['manufacturer'],
        brand = json['brand'],
        model = json['model'],
        isTablet = json['is_tablet'],
        isMIUI = json['is_miui'],
        isGMS = json['is_gms'],
        isHMS = json['is_hms'];

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

  @override
  String toString() =>
      'PlatformToolsInfo(appVersion:$appVersion, appBundle:$appBundle, appBuild:$appBuild, appName:$appName, uuid:$uuid, osVersion:$osVersion, manufacturer:$manufacturer, brand:$brand, model:$model, isTablet:$isTablet, isMIUI:$isMIUI, isGMS:$isGMS, isHMS:$isHMS)';
}
