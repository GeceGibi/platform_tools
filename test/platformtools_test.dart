import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:platformtools/platformtools.dart';

void main() {
  const channel = MethodChannel('gecegibi/platform_tools');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    // expect(await Platformtools.platformVersion, '42');
  });
}
