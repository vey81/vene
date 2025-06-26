import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:vene/models/ghost_model.dart';

class GhostLoadService {
  static const String _folderName = 'ghosts';

  // 📁 Verzeichnispfad holen oder erstellen
  Future<String> _getGhostDirectoryPath() async {
    final dir = await getApplicationDocumentsDirectory();
    final ghostDir = Directory('${dir.path}/$_folderName');
    if (!await ghostDir.exists()) {
      await ghostDir.create(recursive: true);
    }
    return ghostDir.path;
  }

  // 📄 Liste aller gespeicherten Ghost-Dateien (Dateinamen)
  Future<List<String>> listSavedGhosts() async {
    final path = await _getGhostDirectoryPath();
    final dir = Directory(path);

    final files =
        dir.listSync().whereType<File>().where((f) => f.path.endsWith('.json'));

    return files.map((f) => f.uri.pathSegments.last).toList();
  }

  // 🧠 Konkreten Ghost anhand Dateiname laden
  Future<GhostModel?> loadGhost(String fileName) async {
    try {
      final path = await _getGhostDirectoryPath();
      final file = File('$path/$fileName');
      if (await file.exists()) {
        final content = await file.readAsString();
        final json = jsonDecode(content);
        return GhostModel.fromJson(json);
      }
    } catch (e) {
      print('Fehler beim Laden von Ghost "$fileName": $e');
    }
    return null;
  }
}
