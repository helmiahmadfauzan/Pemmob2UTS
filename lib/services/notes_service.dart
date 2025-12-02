import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class NotesService {
  static const String key = "notes";

  static Future<List<Map<String, dynamic>>> loadNotes() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(key);

    if (data == null) return [];
    return List<Map<String, dynamic>>.from(jsonDecode(data));
  }

  static Future<void> saveNotes(List<Map<String, dynamic>> notes) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, jsonEncode(notes));
  }
}
