import 'package:flutter/material.dart';
import 'dart:async';
import 'package:provider/provider.dart';
import 'package:vene/services/garage_data_service.dart';
import 'package:vene/helpers/garage_warning_helper.dart';
import 'package:vene/helpers/wear_prediction_helper.dart';
import 'package:vene/models/tire_data.dart';
import 'package:vene/providers/sensor_provider.dart';
import 'garage_settings_screen.dart';
import 'session_test_screen.dart'; // versteckter Test-Screen

class GarageScreen extends StatefulWidget {
  const GarageScreen({Key? key}) : super(key: key);

  @override
  State<GarageScreen> createState() => _GarageScreenState();
}

class _GarageScreenState extends State<GarageScreen> {
  Color tuevColor = Colors.white;
  String? tuevDate;
  String? brakeDate;
  int oilInterval = 1000;
  String? lastOilChangeDate;
  double totalKm = 0.0;
  double rearProfile = 0.0;
  double frontProfile = 0.0;
  String rearBrand = '';
  String rearType = '';
  String rearModel = '';
  String frontBrand = '';
  String frontType = '';
  String frontModel = '';
  double tankSize = 0.0;
  double lastFuelAmount = 0.0;
  double lastFuelKm = 0.0;
  bool isTankFull = false;

  bool tuevWarning = false;
  bool brakeWarning = false;
  bool oilWarning = false;
  bool rearTyreWarning = false;
  bool frontTyreWarning = false;

  bool _blink = true;
  Timer? _blinkTimer;

  int _garageTapCount = 0;
  Timer? _tapResetTimer;

  @override
  void initState() {
    super.initState();
    _startBlinking();
    _loadData();
  }

  void _startBlinking() {
    _blinkTimer = Timer.periodic(const Duration(milliseconds: 600), (timer) {
      setState(() {
        _blink = !_blink;
      });
    });
  }

  Future<void> _loadData() async {
    final data = await GarageDataService.loadAllValues();
    setState(() {
      tuevDate = data['tuev'];
      brakeDate = data['bremsfl'];
      oilInterval = data['oel_intervall'];
      lastOilChangeDate = data['letzter_oelwechsel'];
      totalKm = data['total_km'];
      rearProfile = data['rearProfileMm'];
      rearBrand = data['rearBrand'];
      rearType = data['rearType'];
      rearModel = data['rearModel'];
      frontProfile = data['frontProfileMm'];
      frontBrand = data['frontBrand'];
      frontType = data['frontType'];
      frontModel = data['frontModel'];
      tankSize = data['tankSize'];
      lastFuelAmount = data['lastFuelAmount'];
      lastFuelKm = data['lastFuelKm'];
      isTankFull = data['isTankFull'];
      tuevWarning = GarageWarningHelper.isTuvWarning(tuevDate);
      brakeWarning = GarageWarningHelper.isBrakeFluidWarning(brakeDate);
      oilWarning = GarageWarningHelper.isOilWarning(
          oilInterval, totalKm, lastOilChangeDate);
      rearTyreWarning =
          GarageWarningHelper.isTyreWarning(rearProfile, rearModel);
      frontTyreWarning =
          GarageWarningHelper.isTyreWarning(frontProfile, frontModel);
    });
  }

  void _onGarageTapped() {
    _tapResetTimer?.cancel();
    _garageTapCount++;
    if (_garageTapCount >= 5) {
      _garageTapCount = 0;
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const SessionTestScreen()),
      );
    } else {
      _tapResetTimer = Timer(const Duration(seconds: 3), () {
        _garageTapCount = 0;
      });
    }
  }

  @override
  void dispose() {
    _blinkTimer?.cancel();
    _tapResetTimer?.cancel();
    super.dispose();
  }

  Widget _buildWarningIcon(bool condition) {
    return condition && _blink
        ? const Padding(
            padding: EdgeInsets.only(left: 4),
            child: Icon(Icons.warning, color: Colors.red, size: 14),
          )
        : const SizedBox(width: 14);
  }

  // ✅ FIXED: KEIN Parameter mehr!
  double _calculateTankLevel() {
    if (tankSize <= 0 || lastFuelAmount <= 0) return 0.0;
    final usedKm = (totalKm - lastFuelKm).clamp(0.0, double.infinity);
    final estimatedRange = isTankFull ? lastFuelAmount * 20 : tankSize * 20;
    final remaining = (estimatedRange - usedKm).clamp(0.0, estimatedRange);
    return estimatedRange > 0 ? remaining / estimatedRange : 0.0;
  }

  int _calculateTyreKmLeft(double profileMm, String model) {
    final maxKm = GarageWarningHelper.getTyreLifespan(model);
    final restKm = (profileMm / 8.0 * maxKm).round();
    return restKm;
  }

  @override
  Widget build(BuildContext context) {
    final sensor = Provider.of<SensorProvider>(context);
    final oilRest = '${(oilInterval - totalKm).round()} km';
    final oilText =
        (oilInterval - totalKm) < 0 ? 'überfällig' : 'noch $oilRest';
    final rearTyreText =
        '${rearProfile.toStringAsFixed(1)} mm – ${_calculateTyreKmLeft(rearProfile, rearModel)} km';
    final frontTyreText =
        '${frontProfile.toStringAsFixed(1)} mm – ${_calculateTyreKmLeft(frontProfile, frontModel)} km';

    final rearDynamic = WearPredictionHelper.calculateTireRestKm(
      profileMm: rearProfile,
      model: rearModel,
      tiltAngles: sensor.tiltHistory,
      gasValues: sensor.gasHistory,
      brakeValues: sensor.brakeHistory,
    ).round();

    final frontDynamic = WearPredictionHelper.calculateTireRestKm(
      profileMm: frontProfile,
      model: frontModel,
      tiltAngles: sensor.tiltHistory,
      gasValues: sensor.gasHistory,
      brakeValues: sensor.brakeHistory,
    ).round();

    final tankLevel = _calculateTankLevel();
    final tankPercent = (tankLevel * 100).round();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.cyan),
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const GarageSettingsScreen()),
              );
              await _loadData();
            },
          ),
        ],
      ),
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            Center(
              child: Image.asset(
                'assets/images/bike_freigestellt.png',
                fit: BoxFit.contain,
              ),
            ),
            Positioned(
              top: 10,
              left: 0,
              right: 0,
              child: GestureDetector(
                onTap: _onGarageTapped,
                child: Center(
                  child: Text('Garage',
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.cyanAccent)),
                ),
              ),
            ),
            Positioned(
              top: 150,
              left: 20,
              child: _buildInfoColumn('TÜV', tuevDate ?? '', tuevWarning),
            ),
            Positioned(
              top: 150,
              right: 20,
              child: _buildInfoColumn('Bremsfl.', brakeDate ?? '', brakeWarning,
                  isRight: true),
            ),
            Positioned(
              top: 160,
              left: 155,
              child: Column(
                children: [
                  Row(
                    children: [
                      Text('Ölwechsel',
                          style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w400,
                              color:
                                  oilWarning ? Colors.red : Colors.cyanAccent)),
                      _buildWarningIcon(oilWarning),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(oilText,
                      style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w300,
                          color: oilWarning ? Colors.red : Colors.white)),
                  if (lastOilChangeDate != null)
                    Text('am $lastOilChangeDate',
                        style: const TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.w300,
                            color: Colors.grey)),
                ],
              ),
            ),
            Positioned(
              bottom: 210,
              left: 20,
              child: _buildTyreInfo(
                  'Reifen hinten', rearTyreText, rearDynamic, rearTyreWarning),
            ),
            Positioned(
              bottom: 210,
              right: 20,
              child: _buildTyreInfo(
                  'Reifen vorne', frontTyreText, frontDynamic, frontTyreWarning,
                  isRight: true),
            ),
            Positioned(
              bottom: 90,
              left: 0,
              right: 0,
              child: Column(
                children: [
                  Text('Tankfüllung: $tankPercent%',
                      style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w400,
                          color: Colors.white)),
                  const SizedBox(height: 4),
                  Container(
                    height: 8,
                    width: 120,
                    decoration: BoxDecoration(
                      color: Colors.grey[800],
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: FractionallySizedBox(
                      alignment: Alignment.centerLeft,
                      widthFactor: tankLevel.clamp(0.0, 1.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: tankLevel < 0.2
                              ? Colors.red
                              : (tankLevel < 0.5
                                  ? Colors.orange
                                  : Colors.green),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: 10,
              left: 20,
              right: 20,
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.6),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.cyanAccent, width: 1),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildTyreColumn('Hinten', rearBrand, rearType, rearModel),
                    _buildTyreColumn(
                        'Vorne', frontBrand, frontType, frontModel),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoColumn(String label, String value, bool warning,
      {bool isRight = false}) {
    return Column(
      crossAxisAlignment:
          isRight ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisSize: isRight ? MainAxisSize.min : MainAxisSize.max,
          children: [
            Text(label,
                style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w400,
                    color: warning ? Colors.red : Colors.cyanAccent)),
            _buildWarningIcon(warning),
          ],
        ),
        const SizedBox(height: 2),
        Text(value,
            style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w300,
                color: warning ? Colors.red : Colors.white)),
      ],
    );
  }

  Widget _buildTyreInfo(String label, String text, int dynamicKm, bool warning,
      {bool isRight = false}) {
    return Column(
      crossAxisAlignment:
          isRight ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisSize: isRight ? MainAxisSize.min : MainAxisSize.max,
          children: [
            Text(label,
                style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w400,
                    color: warning ? Colors.red : Colors.cyanAccent)),
            _buildWarningIcon(warning),
          ],
        ),
        const SizedBox(height: 2),
        Text(text,
            style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w300,
                color: warning ? Colors.red : Colors.white)),
        Text('Live: $dynamicKm km',
            style: TextStyle(
                fontSize: 9,
                fontWeight: FontWeight.w300,
                color: Colors.grey[400])),
      ],
    );
  }

  Widget _buildTyreColumn(
      String title, String brand, String type, String model) {
    final modelLifespan = GarageWarningHelper.getTyreLifespan(model);
    return Column(
      crossAxisAlignment:
          title == 'Hinten' ? CrossAxisAlignment.start : CrossAxisAlignment.end,
      children: [
        Text('$title:',
            style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: Colors.cyanAccent)),
        const SizedBox(height: 2),
        Text('$brand – $type – $model',
            style: const TextStyle(fontSize: 10, color: Colors.white70)),
        Text('Laufleistung: $modelLifespan km',
            style: const TextStyle(fontSize: 10, color: Colors.white70)),
      ],
    );
  }
}
