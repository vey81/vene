// Modell für Motorradreifen-Daten
class TireData {
  final String brand;
  final String model;
  final String type;
  final double newTreadMm;
  final int mileageKm;

  const TireData({
    required this.brand,
    required this.model,
    required this.type,
    required this.newTreadMm,
    required this.mileageKm,
  });
}

// Beispiel-Datensätze
const List<TireData> allTires = [
  TireData(
      brand: 'Michelin',
      model: 'Pilot Road 6 GT',
      type: 'Sport-Touring',
      newTreadMm: 5.0,
      mileageKm: 16000),
  TireData(
      brand: 'Pirelli',
      model: 'Diablo Rosso IV',
      type: 'Sport',
      newTreadMm: 5.5,
      mileageKm: 5000),
  TireData(
      brand: 'Dunlop',
      model: 'RoadSmart IV',
      type: 'Sport-Touring',
      newTreadMm: 5.2,
      mileageKm: 14000),
  TireData(
      brand: 'Metzeler',
      model: 'Tourance',
      type: 'Adventure-Touring',
      newTreadMm: 5.3,
      mileageKm: 15000),
  TireData(
      brand: 'Bridgestone',
      model: 'Battlax T32',
      type: 'Sport-Touring',
      newTreadMm: 5.1,
      mileageKm: 13000),
  TireData(
      brand: 'Continental',
      model: 'ContiRoadAttack 4',
      type: 'Sport-Touring',
      newTreadMm: 5.0,
      mileageKm: 12000),
];
