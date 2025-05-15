
import 'leapfrog_web_component_platform_interface.dart';

class LeapfrogWebComponent {
  Future<String?> getPlatformVersion() {
    return LeapfrogWebComponentPlatform.instance.getPlatformVersion();
  }
}
