class MaintenanceData {
  String tireModel;
  int installKm;
  int maxKm;

  MaintenanceData({
    required this.tireModel,
    required this.installKm,
    required this.maxKm,
  });

  int get remainingKm {
    final int nowKm = 7800; // später dynamisch aus Sensorik
    final int used = nowKm - installKm;
    return (maxKm - used).clamp(0, maxKm);
  }
}
