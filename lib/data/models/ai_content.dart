import 'package:freezed_annotation/freezed_annotation.dart'; 

part 'ai_content.freezed.dart';
part 'ai_content.g.dart';

@freezed
class AiContent with _$AiContent {
	const factory AiContent({
List<Steps>? steps,
String? final_answer,
	}) = _AiContent;

	factory AiContent.fromJson(Map<String, dynamic> json) => _$AiContentFromJson(json);
}

@freezed
class Steps with _$Steps {
	const factory Steps({
String? Findings,
String? potential_cause,
	}) = _Steps;

	factory Steps.fromJson(Map<String, dynamic> json) => _$StepsFromJson(json);
}