import 'package:deobfercator/data/services/prefrence_service.dart';
import 'package:process_run/process_run.dart';
import '../data/services/local_storage_service.dart';

class DeobfuscationRepository {
  final LocalStorageService localStorageService;
  final PreferencesService preferencesService;

  DeobfuscationRepository({
    required this.localStorageService,
    required this.preferencesService,
  });

  Future<String> deobfuscate(
      String stackFilePath, String debugSymbolsPath) async {
    final result = await runExecutableArguments(
      'flutter',
      ['symbolize', '-i', stackFilePath, '-d', debugSymbolsPath],
      verbose: true,
    );
    final output = '${result.stdout}\n${result.stderr}';
    final deobfuscated =
        "Deobfuscated output at ${DateTime.now().toLocal().toString()}\n\n$output";
    localStorageService.addHistory(deobfuscated);
    return deobfuscated;
  }

  Future<String?> getSavedDebugSymbolsPath() {
    return preferencesService.getDebugSymbolsPath();
  }

  Future<void> saveDebugSymbolsPath(String path) {
    return preferencesService.setDebugSymbolsPath(path);
  }

  Future<void> clearHistory() {
    return localStorageService.clearHistory();
  }

  Future<void> removeDebugSymbolsPath() {
    return preferencesService.removeDebugSymbolsPath();
  }
}
