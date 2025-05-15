import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'leapfrog_web_component_platform_interface.dart';

/// An implementation of [LeapfrogWebComponentPlatform] that uses method channels.
class MethodChannelLeapfrogWebComponent extends LeapfrogWebComponentPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('leapfrog_web_component');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
