import 'package:intl/intl.dart';

class GarageWarningHelper {
  static final Map<String, int> _tyreLifespans = {
    'Michelin Road 5': 10000,
    'Michelin Road 6': 11000,
    'Metzeler M9RR': 7500,
    'Pirelli Diablo Rosso IV': 7000,
    'Pirelli Angel GT II': 10500,
    'Bridgestone S22': 6800,
    'Bridgestone T32': 10000,
    'Dunlop Roadsmart IV': 10500,
    'Dunlop SportSmart TT': 7200,
    'ContiRoadAttack 4': 9500,
    'ContiSportAttack 4': 7500,
    'Michelin Pilot Power 2CT': 6000,
    'Michelin Power GP': 6800,
    'Metzeler Roadtec 01 SE': 9500,
    'Pirelli Diablo Supercorsa SP V3': 5200,
    'Pirelli Scorpion Trail II': 10000,
    'Continental TKC 70': 8500,
    'Avon Spirit ST': 9500,
    'Dunlop Mutant': 9000,
  };

  static bool isTuvWarning(String? dateString) {
    if (dateString == null) return false;
    try {
      final date = DateFormat('dd.MM.yyyy').parse(dateString);
      final now = DateTime.now();
      final difference = date.difference(now).inDays;
      return difference <= 30;
    } catch (_) {
      return false;
    }
  }

  static bool isBrakeFluidWarning(String? dateString) {
    if (dateString == null) return false;
    try {
      final date = DateFormat('dd.MM.yyyy').parse(dateString);
      final now = DateTime.now();
      return date.isBefore(now);
    } catch (_) {
      return false;
    }
  }

  static bool isOilWarning(
      int interval, double currentKm, String? lastOilChangeDate) {
    if (lastOilChangeDate == null) return false;
    final remainingKm = interval - currentKm;
    return remainingKm <= 0;
  }

  static bool isTyreWarning(double profileMm, String model) {
    final lifespan = _tyreLifespans[model] ?? 6000;
    final remainingKm = (profileMm / 8.0 * lifespan).round();
    return remainingKm < 1000;
  }

  static int getTyreLifespan(String model) {
    return _tyreLifespans[model] ?? 6000;
  }

  static Map<String, int> getAllTyreLifespans() {
    return _tyreLifespans;
  }
}
