import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GarageSettingsScreen extends StatefulWidget {
  const GarageSettingsScreen({Key? key}) : super(key: key);

  @override
  State<GarageSettingsScreen> createState() => _GarageSettingsScreenState();
}

class _GarageSettingsScreenState extends State<GarageSettingsScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController tuevController;
  late TextEditingController brakeController;
  late TextEditingController oilIntervalController;
  late TextEditingController lastOilChangeDateController;
  late TextEditingController rearProfileController;
  late TextEditingController frontProfileController;
  late TextEditingController tankSizeController;
  late TextEditingController lastFuelAmountController;
  late TextEditingController lastFuelKmController;
  late TextEditingController totalKmController;

  bool isTankFull = false;

  String rearBrand = 'Michelin';
  String rearType = 'Sport';
  String rearModel = '';
  String frontBrand = 'Pirelli';
  String frontType = 'Touring';
  String frontModel = '';

  final Map<String, Map<String, List<String>>> tireOptions = {
    'Michelin': {
      'Sport': ['Power 5', 'Power GP', 'Power RS', 'Power CT2'],
      'Touring': ['Road 5', 'Road 6', 'Pilot Road 4'],
    },
    'Pirelli': {
      'Sport': ['Diablo Rosso IV', 'Diablo Supercorsa SP', 'Angel ST'],
      'Touring': ['Angel GT', 'Angel GT II'],
    },
    'Dunlop': {
      'Sport': ['Sportsmart TT', 'Sportsmart Mk3'],
      'Touring': ['RoadSmart III', 'RoadSmart IV'],
    },
    'Metzeler': {
      'Sport': ['Sportec M7 RR', 'Sportec M9 RR'],
      'Touring': ['Roadtec 01', 'Roadtec Z8'],
    },
    'Bridgestone': {
      'Sport': ['Battlax S22', 'Battlax RS11'],
      'Touring': ['Battlax T31', 'Battlax T32'],
    },
    'Continental': {
      'Sport': ['ContiSportAttack 4'],
      'Touring': ['ContiRoadAttack 3', 'ContiRoadAttack 4'],
    },
  };

  @override
  void initState() {
    super.initState();
    tuevController = TextEditingController();
    brakeController = TextEditingController();
    oilIntervalController = TextEditingController();
    lastOilChangeDateController = TextEditingController();
    rearProfileController = TextEditingController();
    frontProfileController = TextEditingController();
    tankSizeController = TextEditingController();
    lastFuelAmountController = TextEditingController();
    lastFuelKmController = TextEditingController();
    totalKmController = TextEditingController();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      tuevController.text = prefs.getString('tuev') ?? '';
      brakeController.text = prefs.getString('bremsfl') ?? '';
      oilIntervalController.text =
          (prefs.getInt('oel_intervall') ?? 1000).toString();
      lastOilChangeDateController.text =
          prefs.getString('letzter_oelwechsel') ?? '';
      rearProfileController.text =
          (prefs.getDouble('rearProfileMm') ?? 0.0).toString();
      frontProfileController.text =
          (prefs.getDouble('frontProfileMm') ?? 0.0).toString();
      tankSizeController.text = (prefs.getDouble('tankSize') ?? 0.0).toString();
      lastFuelAmountController.text =
          (prefs.getDouble('lastFuelAmount') ?? 0.0).toString();
      lastFuelKmController.text =
          (prefs.getDouble('lastFuelKm') ?? 0.0).toString();
      totalKmController.text = (prefs.getDouble('total_km') ?? 0.0).toString();
      isTankFull = prefs.getBool('isTankFull') ?? false;

      final savedRearBrand = prefs.getString('rearBrand') ?? 'Michelin';
      final savedRearType = prefs.getString('rearType') ?? 'Sport';
      final savedRearModel = prefs.getString('rearModel') ?? '';

      if (tireOptions.containsKey(savedRearBrand)) {
        rearBrand = savedRearBrand;
        if (tireOptions[rearBrand]!.containsKey(savedRearType)) {
          rearType = savedRearType;
          rearModel =
              tireOptions[rearBrand]![rearType]!.contains(savedRearModel)
                  ? savedRearModel
                  : tireOptions[rearBrand]![rearType]!.first;
        }
      }

      final savedFrontBrand = prefs.getString('frontBrand') ?? 'Pirelli';
      final savedFrontType = prefs.getString('frontType') ?? 'Touring';
      final savedFrontModel = prefs.getString('frontModel') ?? '';

      if (tireOptions.containsKey(savedFrontBrand)) {
        frontBrand = savedFrontBrand;
        if (tireOptions[frontBrand]!.containsKey(savedFrontType)) {
          frontType = savedFrontType;
          frontModel =
              tireOptions[frontBrand]![frontType]!.contains(savedFrontModel)
                  ? savedFrontModel
                  : tireOptions[frontBrand]![frontType]!.first;
        }
      }
    });
  }

  Future<void> _saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('tuev', tuevController.text);
    await prefs.setString('bremsfl', brakeController.text);
    await prefs.setInt(
        'oel_intervall', int.tryParse(oilIntervalController.text) ?? 1000);
    await prefs.setString(
        'letzter_oelwechsel', lastOilChangeDateController.text);
    await prefs.setDouble(
        'rearProfileMm',
        double.tryParse(rearProfileController.text.replaceAll(',', '.')) ??
            0.0);
    await prefs.setDouble(
        'frontProfileMm',
        double.tryParse(frontProfileController.text.replaceAll(',', '.')) ??
            0.0);
    await prefs.setString('rearBrand', rearBrand);
    await prefs.setString('rearType', rearType);
    await prefs.setString('rearModel', rearModel);
    await prefs.setString('frontBrand', frontBrand);
    await prefs.setString('frontType', frontType);
    await prefs.setString('frontModel', frontModel);
    await prefs.setDouble('tankSize',
        double.tryParse(tankSizeController.text.replaceAll(',', '.')) ?? 0.0);
    await prefs.setDouble(
        'lastFuelAmount',
        double.tryParse(lastFuelAmountController.text.replaceAll(',', '.')) ??
            0.0);
    await prefs.setDouble('lastFuelKm',
        double.tryParse(lastFuelKmController.text.replaceAll(',', '.')) ?? 0.0);
    await prefs.setDouble('total_km',
        double.tryParse(totalKmController.text.replaceAll(',', '.')) ?? 0.0);
    await prefs.setBool('isTankFull', isTankFull);
    Navigator.pop(context);
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        controller: controller,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Colors.white70),
          enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.cyanAccent)),
          focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.cyanAccent)),
        ),
      ),
    );
  }

  Widget _buildDropdown(String label, String value, List<String> options,
      Function(String) onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: DropdownButtonFormField<String>(
        value: options.contains(value) ? value : options.first,
        dropdownColor: Colors.black,
        decoration: const InputDecoration(
          labelStyle: TextStyle(color: Colors.white70),
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.cyanAccent)),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.cyanAccent)),
        ),
        iconEnabledColor: Colors.white,
        style: const TextStyle(color: Colors.white),
        items: options
            .map((item) => DropdownMenuItem(value: item, child: Text(item)))
            .toList(),
        onChanged: (val) => onChanged(val ?? value),
      ),
    );
  }

  @override
  void dispose() {
    tuevController.dispose();
    brakeController.dispose();
    oilIntervalController.dispose();
    lastOilChangeDateController.dispose();
    rearProfileController.dispose();
    frontProfileController.dispose();
    tankSizeController.dispose();
    lastFuelAmountController.dispose();
    lastFuelKmController.dispose();
    totalKmController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Garage Einstellungen'),
        backgroundColor: Colors.black,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                _buildTextField('TÜV Datum', tuevController),
                _buildTextField('Bremsflüssigkeit gültig bis', brakeController),
                _buildTextField(
                    'Ölwechsel Intervall (km)', oilIntervalController),
                _buildTextField(
                    'Letzter Ölwechsel (Datum)', lastOilChangeDateController),
                _buildTextField(
                    'Reifenprofil hinten (mm)', rearProfileController),
                _buildDropdown(
                    'Marke hinten', rearBrand, tireOptions.keys.toList(),
                    (val) {
                  setState(() {
                    rearBrand = val;
                    rearType = tireOptions[val]!.keys.first;
                    rearModel = tireOptions[val]![rearType]!.first;
                  });
                }),
                _buildDropdown('Typ hinten', rearType,
                    tireOptions[rearBrand]!.keys.toList(), (val) {
                  setState(() {
                    rearType = val;
                    rearModel = tireOptions[rearBrand]![val]!.first;
                  });
                }),
                _buildDropdown('Modell hinten', rearModel,
                    tireOptions[rearBrand]![rearType]!, (val) {
                  setState(() => rearModel = val);
                }),
                const Divider(color: Colors.white54),
                _buildTextField(
                    'Reifenprofil vorne (mm)', frontProfileController),
                _buildDropdown(
                    'Marke vorne', frontBrand, tireOptions.keys.toList(),
                    (val) {
                  setState(() {
                    frontBrand = val;
                    frontType = tireOptions[val]!.keys.first;
                    frontModel = tireOptions[val]![frontType]!.first;
                  });
                }),
                _buildDropdown('Typ vorne', frontType,
                    tireOptions[frontBrand]!.keys.toList(), (val) {
                  setState(() {
                    frontType = val;
                    frontModel = tireOptions[frontBrand]![val]!.first;
                  });
                }),
                _buildDropdown('Modell vorne', frontModel,
                    tireOptions[frontBrand]![frontType]!, (val) {
                  setState(() => frontModel = val);
                }),
                const Divider(color: Colors.white54),
                _buildTextField('Tankgröße (Liter)', tankSizeController),
                _buildTextField(
                    'Letzte getankte Menge (Liter)', lastFuelAmountController),
                _buildTextField(
                    'Kilometerstand beim letzten Tanken', lastFuelKmController),
                _buildTextField('Gesamt Kilometerstand (Original Tacho)',
                    totalKmController),
                Row(
                  children: [
                    Checkbox(
                      value: isTankFull,
                      onChanged: (val) =>
                          setState(() => isTankFull = val ?? false),
                      activeColor: Colors.cyan,
                    ),
                    const Text("Vollgetankt",
                        style: TextStyle(color: Colors.white70)),
                  ],
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _saveSettings,
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.cyan.shade700),
                  child: const Text('Speichern'),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
