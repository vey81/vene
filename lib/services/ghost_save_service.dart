import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:vene/models/ghost_model.dart';

class GhostSaveService {
  static const String _folderName = 'ghosts';

  Future<String> _getGhostDirectoryPath() async {
    final dir = await getApplicationDocumentsDirectory();
    final ghostDir = Directory('${dir.path}/$_folderName');
    if (!await ghostDir.exists()) {
      await ghostDir.create(recursive: true);
    }
    return ghostDir.path;
  }

  Future<void> saveGhost(GhostModel ghost) async {
    final path = await _getGhostDirectoryPath();
    final fileName = '${ghost.timestamp.toIso8601String()}_${ghost.name}.json';
    final file = File('$path/$fileName');

    final jsonData = jsonEncode(ghost.toJson());
    await file.writeAsString(jsonData);
  }

  Future<List<GhostModel>> loadAllGhosts() async {
    final path = await _getGhostDirectoryPath();
    final dir = Directory(path);

    final files =
        dir.listSync().whereType<File>().where((f) => f.path.endsWith('.json'));

    final ghosts = <GhostModel>[];

    for (final file in files) {
      final content = await file.readAsString();
      final json = jsonDecode(content);
      ghosts.add(GhostModel.fromJson(json));
    }

    // Optional: Sortieren nach Datum
    ghosts.sort((a, b) => b.timestamp.compareTo(a.timestamp));

    return ghosts;
  }

  Future<void> deleteGhost(String fileName) async {
    final path = await _getGhostDirectoryPath();
    final file = File('$path/$fileName');
    if (await file.exists()) {
      await file.delete();
    }
  }

  Future<List<String>> listGhostFileNames() async {
    final path = await _getGhostDirectoryPath();
    final dir = Directory(path);

    return dir
        .listSync()
        .whereType<File>()
        .where((f) => f.path.endsWith('.json'))
        .map((f) => f.uri.pathSegments.last)
        .toList();
  }
}
