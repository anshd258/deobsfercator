import 'package:freezed_annotation/freezed_annotation.dart';

part 'ai_data_model.dart.freezed.dart';
part 'ai_data_model.dart.g.dart';

@freezed
class AiDataModel with _$AiDataModel {
  const factory AiDataModel({
    String? model,
    List<Messages>? messages,
    dynamic response_format,
  }) = _AiDataModel;

  factory AiDataModel.fromJson(Map<String, dynamic> json) =>
      _$AiDataModelFromJson(json);
}

@freezed
class Messages with _$Messages {
  const factory Messages({
    String? role,
    String? content,
  }) = _Messages;

  factory Messages.fromJson(Map<String, dynamic> json) =>
      _$MessagesFromJson(json);
}
