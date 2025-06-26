import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart'; // ✅ Korrigiert

class TrackListScreen extends StatefulWidget {
  const TrackListScreen({Key? key}) : super(key: key);

  @override
  State<TrackListScreen> createState() => _TrackListScreenState();
}

class _TrackListScreenState extends State<TrackListScreen> {
  List<FileSystemEntity> trackFiles = [];

  @override
  void initState() {
    super.initState();
    _loadTrackFiles();
  }

  Future<void> _loadTrackFiles() async {
    final dir = await getApplicationDocumentsDirectory();
    final trackDir = Directory('${dir.path}/track_files');

    if (await trackDir.exists()) {
      final files =
          trackDir.listSync().where((f) => f.path.endsWith('.json')).toList();

      setState(() {
        trackFiles = files;
      });
    }
  }

  Future<void> _deleteFile(File file) async {
    await file.delete();
    _loadTrackFiles();
  }

  void _showTrackDetails(File file) async {
    final content = await file.readAsString();
    final data = jsonDecode(content);

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Track Details"),
        content: SingleChildScrollView(
          child: Text(const JsonEncoder.withIndent('  ').convert(data)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Schließen"),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("Meine Strecken"),
        backgroundColor: Colors.black,
        foregroundColor: Colors.cyan,
        elevation: 0,
      ),
      body: trackFiles.isEmpty
          ? const Center(
              child: Text(
                "Keine Strecken vorhanden",
                style: TextStyle(color: Colors.white54),
              ),
            )
          : ListView.builder(
              itemCount: trackFiles.length,
              itemBuilder: (context, index) {
                final file = File(trackFiles[index].path);
                final filename = file.path.split('/').last;

                return Card(
                  color: const Color(0xFF121212),
                  margin:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    title: Text(
                      filename,
                      style: const TextStyle(color: Colors.white),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon:
                              const Icon(Icons.visibility, color: Colors.cyan),
                          onPressed: () => _showTrackDetails(file),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _deleteFile(file),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
