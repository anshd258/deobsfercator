import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';

class PreferencesService {
  Future<String?> getDebugSymbolsPath() async {
    final prefs = await SharedPreferences.getInstance();
    String? path = prefs.getString('debugSymbolsPath');
    if (path != null && await File(path).exists()) {
      return path;
    }
    return null;
  }

  Future<void> setDebugSymbolsPath(String path) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('debugSymbolsPath', path);
  }

  Future<void> removeDebugSymbolsPath() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('debugSymbolsPath');
  }
}
