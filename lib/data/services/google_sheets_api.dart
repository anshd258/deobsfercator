import 'package:deobfercator/core/constants/api_endpoint.dart';
import 'package:deobfercator/data/models/bug_model.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
part "google_sheets_api.g.dart";

@RestApi(baseUrl: ApiEndpoints.baseUrlGoogleSheets)
abstract class GoogleSheetsApi {
  factory GoogleSheetsApi(Dio dio, {String? baseUrl}) = _GoogleSheetsApi;

  @POST("")
  Future<HttpResponse> postBugInSheet({@Body() required BugModel bug});
}
