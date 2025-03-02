import 'package:deobfercator/core/constants/api_endpoint.dart';
import 'package:deobfercator/data/models/ai_data_model.dart.dart';
import 'package:deobfercator/data/models/ai_response.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart' as retro;
part "chat_gpt_solver.g.dart";

@retro.RestApi(baseUrl: ApiEndpoints.baseUrlChatGpt)
abstract class AiBugSolver {
  factory AiBugSolver(Dio dio, {String? baseUrl}) = _AiBugSolver;

  @retro.POST("/chat/completions")
  @retro.Headers({
    "Content-Type": "application/json",
    "Authorization":
        "Bearer <your-open-api-key>"
  })
  Future<AIResponse> postAiData({
    @retro.Body() required AiDataModel request,
  });
}
