package com.gecegibi.platformtools

import android.annotation.SuppressLint
import android.app.Activity
import android.content.Context
import android.content.Intent
import android.content.pm.ApplicationInfo
import android.content.pm.PackageInfo
import android.content.res.Configuration
import android.net.Uri
import android.os.Build
import android.provider.Settings
import android.text.TextUtils
import androidx.annotation.NonNull
import com.google.android.gms.common.ConnectionResult
import com.google.android.gms.common.GoogleApiAvailability
import com.huawei.hms.api.HuaweiApiAvailability
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import me.leolin.shortcutbadger.ShortcutBadger
import java.io.BufferedReader
import java.io.IOException
import java.io.InputStreamReader

/** PlatforToolsPlugin */
class PlatformToolsPlugin: FlutterPlugin, MethodCallHandler,ActivityAware {
  private lateinit var context: Context
  private lateinit var activity: Activity
  private lateinit var channel : MethodChannel
  private var isBadgeSupported = false;

  override fun onDetachedFromActivity() {
    // no-op
  }

  override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
    // no-op
  }

  override fun onAttachedToActivity(binding: ActivityPluginBinding) {
    activity = binding.activity
  }

  override fun onDetachedFromActivityForConfigChanges() {
    // no-op
  }

  override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    context = flutterPluginBinding.applicationContext
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, "gecegibi/platform_tools")
    channel.setMethodCallHandler(this)
  }

  override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
    when (call.method) {
      "request_tracking_authorization" -> result.success(4)
      "app_settings" -> openAppSettings()
      "app_notification_settings" -> openAppNotificationSettings()
      "badge_update" -> updateBadge(call.arguments as Int)
      "info" -> getInfo(result)
      else -> result.notImplemented()
    }
  }

  override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
  }

  private fun updateBadge(count: Int) {
    if (!isBadgeSupported) return

    if (count == 0) {
      ShortcutBadger.removeCount(context);
    } else {
      ShortcutBadger.applyCount(context, count);
    }
  }


  private fun isTablet(): Boolean {
    val smallestScreenWidthDp: Int = context.resources.configuration.smallestScreenWidthDp
    if (smallestScreenWidthDp == Configuration.SMALLEST_SCREEN_WIDTH_DP_UNDEFINED) {
      return false
    }
    return smallestScreenWidthDp >= 600
  }

  private fun getLongVersionCode(info: PackageInfo): String {
    return if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.P) {
      info.longVersionCode.toString()
    } else info.versionCode.toString()
  }

  private fun getInfo(result: MethodChannel.Result) {
    try {
      val appInfo: ApplicationInfo = context.applicationInfo
      val packageInfo: PackageInfo =
        context.packageManager.getPackageInfo(
          context.packageName, 0,
        );

      var appVersion = packageInfo.versionName;
      var appBuild = getLongVersionCode(packageInfo);
      var appName = appInfo.loadLabel(context.packageManager).toString()

      val info: MutableMap<String, Any> = hashMapOf(
        "app_version" to appVersion,
        "app_build" to appBuild,
        "app_name" to appName,
        "app_bundle" to context.packageName,
        "is_tablet" to isTablet(),
        "uuid" to uuid(),
        "os_version" to Build.VERSION.SDK_INT.toString(),
        "manufacturer" to Build.MANUFACTURER,
        "brand" to Build.BRAND,
        "model" to Build.MODEL,
        "is_miui" to !TextUtils.isEmpty(getSystemProperty("ro.miui.ui.version.name")),
        "is_gms" to isGMSAvailable(),
        "is_hms" to isHMSAvailable(),
      )

      result.success(info);
    } catch (e: Exception) {
      result.error("DEVICE_INFO", "CANNOT GET INFO", e)
    }
  }

  @SuppressLint("HardwareIds")
  fun uuid(): String {
    return Settings.Secure.getString(context.contentResolver, Settings.Secure.ANDROID_ID)
  }

  private fun openAppSettings() {
    val intent = Intent(Settings.ACTION_APPLICATION_DETAILS_SETTINGS)
    intent.data = Uri.fromParts("package", activity.packageName, null)
    activity.startActivity(intent)

  }

  private fun openAppNotificationSettings() {
    val intent = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
      Intent(Settings.ACTION_APP_NOTIFICATION_SETTINGS)
        .putExtra(Settings.EXTRA_APP_PACKAGE, activity.packageName)
    } else {
      Intent(Settings.ACTION_APPLICATION_DETAILS_SETTINGS)
        .setData(Uri.parse("package:${activity.packageName}"))
    }

    activity.startActivity(intent);
  }


  private fun getSystemProperty(prop: String): String? {
    val line: String
    var input: BufferedReader? = null
    try {
      val p = Runtime.getRuntime().exec("getprop $prop")
      input = BufferedReader(InputStreamReader(p.inputStream), 1024)
      line = input.readLine()
      input.close()
    } catch (ex: IOException) {
      return null
    } finally {
      if (input != null) {
        try {
          input.close()
        } catch (e: IOException) {
          e.printStackTrace()
        }
      }
    }
    return line
  }

  private fun isGMSAvailable():Boolean{
    val result = GoogleApiAvailability.getInstance().isGooglePlayServicesAvailable(context);
    return result == ConnectionResult.SUCCESS;
  }

  private fun isHMSAvailable():Boolean{
    val result = HuaweiApiAvailability.getInstance().isHuaweiMobileServicesAvailable(context);
    return result == ConnectionResult.SUCCESS;
  }
}
