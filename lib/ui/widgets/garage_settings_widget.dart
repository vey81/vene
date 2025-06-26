import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/maintenance_provider.dart';

class GarageSettingsWidget extends StatefulWidget {
  const GarageSettingsWidget({super.key});

  @override
  State<GarageSettingsWidget> createState() => _GarageSettingsWidgetState();
}

class _GarageSettingsWidgetState extends State<GarageSettingsWidget> {
  String? selectedModel;
  final TextEditingController kmController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Reifenmodell", style: TextStyle(color: Colors.white)),
        DropdownButton<String>(
          value: selectedModel,
          dropdownColor: Colors.black,
          hint: const Text("Modell wählen",
              style: TextStyle(color: Colors.white)),
          items: MaintenanceProvider.tireLifeMap.keys.map((String model) {
            return DropdownMenuItem<String>(
              value: model,
              child: Text(model, style: const TextStyle(color: Colors.white)),
            );
          }).toList(),
          onChanged: (value) {
            setState(() => selectedModel = value);
          },
        ),
        const SizedBox(height: 10),
        const Text("Aktueller KM-Stand", style: TextStyle(color: Colors.white)),
        TextField(
          controller: kmController,
          keyboardType: TextInputType.number,
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(
            hintText: "z. B. 7800",
            hintStyle: TextStyle(color: Colors.grey),
          ),
        ),
        const SizedBox(height: 10),
        ElevatedButton(
          onPressed: () {
            if (selectedModel != null && kmController.text.isNotEmpty) {
              final int km = int.tryParse(kmController.text) ?? 0;
              Provider.of<MaintenanceProvider>(context, listen: false)
                  .setTireModel(selectedModel!, km);
            }
          },
          child: const Text("Speichern"),
        ),
      ],
    );
  }
}
