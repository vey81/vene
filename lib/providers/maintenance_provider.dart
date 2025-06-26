import 'package:flutter/material.dart';
import '../models/maintenance_data.dart';

class MaintenanceProvider with ChangeNotifier {
  MaintenanceData? _tireData;

  MaintenanceData? get tireData => _tireData;

  void setTireModel(String model, int km) {
    int maxKm = tireLifeMap[model] ?? 2500;
    _tireData = MaintenanceData(
      tireModel: model,
      installKm: km,
      maxKm: maxKm,
    );
    notifyListeners();
  }

  static const Map<String, int> tireLifeMap = {
    'Pirelli Diablo Rosso IV': 2500,
    'Michelin Power 5': 3000,
    'Bridgestone S22': 2800,
    'Continental SportAttack 4': 2700,
    'Metzeler M9 RR': 2600,
  };
}
