import 'package:deobfercator/core/constants/dio.dart';
import 'package:deobfercator/data/models/bug_model.dart';
import 'package:deobfercator/data/services/google_sheets_api.dart';

class GoogleSheetsRepository {
  final _client = GoogleSheetsApi(dio);

  Future<void> addBug({required BugModel bug}) async {
    await _client.postBugInSheet(bug: bug);
  }
}
