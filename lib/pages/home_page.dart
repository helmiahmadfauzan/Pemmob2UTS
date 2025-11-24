import 'package:flutter/material.dart';
import '../services/notes_service.dart';
import 'add_note_page.dart';
import 'about_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<String> notes = [];

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
        notes[index] = newText;
      } else {
        notes.add(newText);
      }

      await NotesService.saveNotes(notes);
      setState(() {});
    }
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
      body: notes.isEmpty
          ? const Center(child: Text("Belum ada catatan"))
          : ListView.builder(
              itemCount: notes.length,
              itemBuilder: (c, i) {
                return ListTile(
                  title: Text(notes[i]),
                  onTap: () => openAddNote(initialText: notes[i], index: i),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => deleteNote(i),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => openAddNote(),
        child: const Icon(Icons.add),
      ),
    );
  }
}
