import 'package:flutter_test/flutter_test.dart';
import 'package:leapfrog_web_component/leapfrog_web_component.dart';
import 'package:leapfrog_web_component/leapfrog_web_component_platform_interface.dart';
import 'package:leapfrog_web_component/leapfrog_web_component_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockLeapfrogWebComponentPlatform
    with MockPlatformInterfaceMixin
    implements LeapfrogWebComponentPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final LeapfrogWebComponentPlatform initialPlatform = LeapfrogWebComponentPlatform.instance;

  test('$MethodChannelLeapfrogWebComponent is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelLeapfrogWebComponent>());
  });

  test('getPlatformVersion', () async {
    LeapfrogWebComponent leapfrogWebComponentPlugin = LeapfrogWebComponent();
    MockLeapfrogWebComponentPlatform fakePlatform = MockLeapfrogWebComponentPlatform();
    LeapfrogWebComponentPlatform.instance = fakePlatform;

    expect(await leapfrogWebComponentPlugin.getPlatformVersion(), '42');
  });
}
