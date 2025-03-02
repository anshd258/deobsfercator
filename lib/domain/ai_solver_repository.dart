import 'dart:convert';

import 'package:deobfercator/core/constants/dio.dart';
import 'package:deobfercator/core/utilities/ai_prompt.dart';
import 'package:deobfercator/data/models/ai_content.dart' as ai;
import 'package:deobfercator/data/models/ai_data_model.dart.dart';
import 'package:deobfercator/data/services/chat_gpt_solver.dart';

class AiSolverRepository {
  final _client = AiBugSolver(dio);

  Future<ai.AiContent> postAiRequest(
      {required String stackTrace,
      required String exception,
      String? bugData}) async {
    final userPrompt = DebugPromptBuilder.buildPrompt(
        stackTrace: stackTrace,
        exceptionMessage: exception,
        bugDescription: bugData ?? "");

    try {
      final result = await _client.postAiData(
        request: AiDataModel(
            messages: [
              Messages(
                  role: "system", content: DebugPromptBuilder.systemPrompt),
              Messages(role: "user", content: userPrompt)
            ],
            model: "gpt-4o-2024-08-06",
            response_format: {
              "type": "json_schema",
              "json_schema": {
                "name": "Bug_solver",
                "schema": {
                  "type": "object",
                  "properties": {
                    "steps": {
                      "type": "array",
                      "items": {
                        "type": "object",
                        "properties": {
                          "Findings": {"type": "string"},
                          "potential_cause": {"type": "string"}
                        },
                        "required": ["Findings", "potential_cause"],
                        "additionalProperties": false
                      }
                    },
                    "final_answer": {"type": "string"}
                  },
                  "required": ["steps", "final_answer"],
                  "additionalProperties": false
                },
                "strict": true
              }
            }),
      );
      return ai.AiContent.fromJson(
          json.decode(result.choices!.first.message!.content!));
    } catch (e) {
      rethrow;
    }
  }
}
