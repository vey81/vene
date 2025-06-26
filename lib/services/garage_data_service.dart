import 'package:shared_preferences/shared_preferences.dart';

class GarageDataService {
  static Future<Map<String, dynamic>> loadAllValues() async {
    final prefs = await SharedPreferences.getInstance();

    return {
      'tuev': prefs.getString('tuev'),
      'bremsfl': prefs.getString('bremsfl'),
      'oel_intervall': prefs.getInt('oel_intervall') ?? 1000,
      'letzter_oelwechsel': prefs.getString('letzter_oelwechsel'),
      'total_km': prefs.getDouble('total_km') ?? 0.0,
      'rearProfileMm': prefs.getDouble('rearProfileMm') ?? 0.0,
      'rearBrand': prefs.getString('rearBrand') ?? '',
      'rearType': prefs.getString('rearType') ?? '',
      'rearModel': prefs.getString('rearModel') ?? '',
      'frontProfileMm': prefs.getDouble('frontProfileMm') ?? 0.0,
      'frontBrand': prefs.getString('frontBrand') ?? '',
      'frontType': prefs.getString('frontType') ?? '',
      'frontModel': prefs.getString('frontModel') ?? '',
      'tankSize': prefs.getDouble('tankSize') ?? 0.0,
      'lastFuelAmount': prefs.getDouble('lastFuelAmount') ?? 0.0,
      'lastFuelKm': prefs.getDouble('lastFuelKm') ?? 0.0,
      'isTankFull': prefs.getBool('isTankFull') ?? false,
    };
  }

  static Future<void> saveValue(String key, dynamic value) async {
    final prefs = await SharedPreferences.getInstance();
    if (value is String) await prefs.setString(key, value);
    if (value is int) await prefs.setInt(key, value);
    if (value is double) await prefs.setDouble(key, value);
    if (value is bool) await prefs.setBool(key, value);
  }
}
