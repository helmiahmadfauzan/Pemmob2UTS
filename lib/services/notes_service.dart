import 'package:shared_preferences/shared_preferences.dart';

class NotesService {
  static const String key = "notes_list";

  static Future<List<String>> loadNotes() async {
    final pref = await SharedPreferences.getInstance();
    return pref.getStringList(key) ?? [];
  }

  static Future<void> saveNotes(List<String> notes) async {
    final pref = await SharedPreferences.getInstance();
    await pref.setStringList(key, notes);
  }
}
