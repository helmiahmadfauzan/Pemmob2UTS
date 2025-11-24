import 'package:flutter/material.dart';

class AddNotePage extends StatefulWidget {
  final String? initialText;

  const AddNotePage({super.key, this.initialText});

  @override
  State<AddNotePage> createState() => _AddNotePageState();
}

class _AddNotePageState extends State<AddNotePage> {
  final controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    controller.text = widget.initialText ?? "";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.initialText == null ? "Tambah Catatan" : "Edit Catatan")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: TextField(
          controller: controller,
          maxLines: 10,
          decoration: const InputDecoration(
            hintText: "Tulis catatan di sini...",
            border: OutlineInputBorder(),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pop(context, controller.text);
        },
        child: const Icon(Icons.save),
      ),
    );
  }
}
