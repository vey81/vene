import 'dart:math';
import 'package:vene/models/tire_data.dart';

class WearPredictionHelper {
  static double calculateTireRestKm({
    required double profileMm,
    required String model,
    required List<double> tiltAngles,
    required List<double> gasValues,
    required List<double> brakeValues,
  }) {
    final tire = allTires.firstWhere(
      (t) => t.model == model,
      orElse: () => TireData(
        brand: '',
        model: '',
        type: '',
        newTreadMm: 5.0,
        mileageKm: 6000,
      ),
    );

    final double aggressiveness = _calculateAggressiveness(
      tiltAngles: tiltAngles,
      gasValues: gasValues,
      brakeValues: brakeValues,
    );

    final double baseRestKm = (profileMm / tire.newTreadMm) * tire.mileageKm;

    final double adjustedRestKm =
        baseRestKm * (1 - aggressiveness).clamp(0.6, 1.0);

    return adjustedRestKm.toDouble(); // ✅ Fehlerquelle behoben
  }

  static double _calculateAggressiveness({
    required List<double> tiltAngles,
    required List<double> gasValues,
    required List<double> brakeValues,
  }) {
    if (tiltAngles.isEmpty || gasValues.isEmpty || brakeValues.isEmpty) {
      return 0.0;
    }

    final double avgTilt =
        tiltAngles.map((e) => e.abs()).reduce((a, b) => a + b) /
            tiltAngles.length;
    final double avgGas = gasValues.reduce((a, b) => a + b) / gasValues.length;
    final double avgBrake =
        brakeValues.reduce((a, b) => a + b) / brakeValues.length;

    final double score = (avgTilt / 45.0) * 0.4 + avgGas * 0.3 + avgBrake * 0.3;

    return score.clamp(0.0, 1.0);
  }
}
