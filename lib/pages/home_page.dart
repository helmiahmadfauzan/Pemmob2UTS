import 'package:flutter/material.dart';
import 'package:voice_note_kit/voice_note_kit.dart';
import '../services/notes_service.dart';
import 'add_note_page.dart';
import 'about_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Map<String, dynamic>> notes = [];

  @override
  void initState() {
    super.initState();
    loadData();
  }

  void loadData() async {
    notes = await NotesService.loadNotes();
    setState(() {});
  }

  void deleteNote(int index) async {
    notes.removeAt(index);
    await NotesService.saveNotes(notes);
    setState(() {});
  }

  void openAddNote({String? initialText, int? index}) async {
    final newText = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AddNotePage(
          initialText: initialText,
        ),
      ),
    );

    if (newText != null) {
      if (index != null) {
        notes[index] = {
          "type": "text",
          "content": newText,
        };
      } else {
        notes.add({
          "type": "text",
          "content": newText,
        });
      }

      await NotesService.saveNotes(notes);
      setState(() {});
    }
  }

  void addAudioNote(String path) async {
    notes.add({
      "type": "audio",
      "path": path,
    });

    await NotesService.saveNotes(notes);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Catatan Saya"),
        actions: [
          IconButton(
            icon: const Icon(Icons.info),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AboutPage()),
              );
            },
          )
        ],
      ),

      // ===================== BODY =====================
      body: notes.isEmpty
          ? const Center(child: Text("Belum ada catatan"))
          : ListView.builder(
              itemCount: notes.length,
              itemBuilder: (c, i) {
                final item = notes[i];

                if (item["type"] == "text") {
                  return ListTile(
                    title: Text(item["content"]),
                    onTap: () => openAddNote(
                      initialText: item["content"],
                      index: i,
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => deleteNote(i),
                    ),
                  );
                }

                // ===== AUDIO NOTE =====
                return ListTile(
                  title: const Text("Catatan Suara"),
                  subtitle: AudioPlayerWidget(
                    autoPlay: false,
                    autoLoad: true,
                    audioPath: item["path"],
                    audioType: AudioType.directFile,
                    playerStyle: PlayerStyle.style5,
                    size: 60,
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => deleteNote(i),
                  ),
                );
              },
            ),

      // ===================== FAB =====================
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          // ADD TEXT NOTE
          FloatingActionButton(
            heroTag: "text",
            child: const Icon(Icons.note_add),
            onPressed: () => openAddNote(),
          ),
          const SizedBox(height: 12),

          // RECORD AUDIO NOTE
          FloatingActionButton(
            heroTag: "audio",
            backgroundColor: Colors.red,
            child: const Icon(Icons.mic),
            onPressed: () {
              showDialog(
                context: context,
                builder: (_) => AlertDialog(
                  title: const Text("Rekam Catatan Suara"),
                  content: VoiceRecorderWidget(
                    iconSize: 80,
                    showTimerText: true,

                    onRecorded: (file) {
                      Navigator.pop(context);
                      addAudioNote(file.path);
                    },

                    onError: (err) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Error: $err")),
                      );
                    },

                    actionWhenCancel: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
