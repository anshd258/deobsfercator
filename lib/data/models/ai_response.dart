import 'package:freezed_annotation/freezed_annotation.dart'; 

part 'ai_response.freezed.dart';
part 'ai_response.g.dart';

@freezed
class AIResponse with _$AIResponse {
	const factory AIResponse({
String? id,
String? object,
int? created,
String? model,
List<Choices>? choices,
Usage? usage,
String? service_tier,
String? system_fingerprint,
	}) = _AIResponse;

	factory AIResponse.fromJson(Map<String, dynamic> json) => _$AIResponseFromJson(json);
}

@freezed
class Choices with _$Choices {
	const factory Choices({
int? index,
Message? message,

String? finish_reason,
	}) = _Choices;

	factory Choices.fromJson(Map<String, dynamic> json) => _$ChoicesFromJson(json);
}

@freezed
class Message with _$Message {
	const factory Message({
String? role,
String? content,

	}) = _Message;

	factory Message.fromJson(Map<String, dynamic> json) => _$MessageFromJson(json);
}


@freezed
class Usage with _$Usage {
	const factory Usage({
int? prompt_tokens,
int? completion_tokens,
int? total_tokens,
PromptTokensDetails? prompt_tokens_details,
CompletionTokensDetails? completion_tokens_details,
	}) = _Usage;

	factory Usage.fromJson(Map<String, dynamic> json) => _$UsageFromJson(json);
}

@freezed
class PromptTokensDetails with _$PromptTokensDetails {
	const factory PromptTokensDetails({
int? cached_tokens,
int? audio_tokens,
	}) = _PromptTokensDetails;

	factory PromptTokensDetails.fromJson(Map<String, dynamic> json) => _$PromptTokensDetailsFromJson(json);
}

@freezed
class CompletionTokensDetails with _$CompletionTokensDetails {
	const factory CompletionTokensDetails({
int? reasoning_tokens,
int? audio_tokens,
int? accepted_prediction_tokens,
int? rejected_prediction_tokens,
	}) = _CompletionTokensDetails;

	factory CompletionTokensDetails.fromJson(Map<String, dynamic> json) => _$CompletionTokensDetailsFromJson(json);
}