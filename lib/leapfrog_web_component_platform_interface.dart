import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'leapfrog_web_component_method_channel.dart';

abstract class LeapfrogWebComponentPlatform extends PlatformInterface {
  /// Constructs a LeapfrogWebComponentPlatform.
  LeapfrogWebComponentPlatform() : super(token: _token);

  static final Object _token = Object();

  static LeapfrogWebComponentPlatform _instance = MethodChannelLeapfrogWebComponent();

  /// The default instance of [LeapfrogWebComponentPlatform] to use.
  ///
  /// Defaults to [MethodChannelLeapfrogWebComponent].
  static LeapfrogWebComponentPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [LeapfrogWebComponentPlatform] when
  /// they register themselves.
  static set instance(LeapfrogWebComponentPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
