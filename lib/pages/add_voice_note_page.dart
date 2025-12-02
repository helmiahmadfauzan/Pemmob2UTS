import 'package:flutter/material.dart';
import 'package:voice_note_kit/voice_note_kit.dart';
import 'dart:io';

class AddVoiceNotePage extends StatefulWidget {
  const AddVoiceNotePage({super.key});

  @override
  State<AddVoiceNotePage> createState() => _AddVoiceNotePageState();
}

class _AddVoiceNotePageState extends State<AddVoiceNotePage> {
  File? recordedFile;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Rekam Catatan Suara")),

      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            // RECORDER WIDGET
            VoiceRecorderWidget(
              iconSize: 80,
              showTimerText: true,
              backgroundColor: Colors.blue,
              iconColor: Colors.white,

              onRecorded: (file) {
                setState(() => recordedFile = file);

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Tersimpan: ${file.path}")),
                );
              },

              onError: (error) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Error: $error")),
                );
              },
            ),

            const SizedBox(height: 20),

            // BUTTON LANJUT
            if (recordedFile != null)
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context, recordedFile!.path);
                },
                child: const Text("Gunakan Catatan Suara"),
              ),
          ],
        ),
      ),
    );
  }
}
