import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class DeviceIdService {
  static const String _key = "device_id";

  /// Returns a persistent unique ID for this device/app installation
  static Future<String> getDeviceId() async {
    final prefs = await SharedPreferences.getInstance();
    String? savedId = prefs.getString(_key);

    if (savedId != null) return savedId;

    // generate new ID if none stored yet
    String newId = const Uuid().v4();
    await prefs.setString(_key, newId);
    return newId;
  }
}
