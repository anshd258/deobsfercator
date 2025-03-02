import 'package:freezed_annotation/freezed_annotation.dart';

part 'bug_model.freezed.dart';
part 'bug_model.g.dart';

@freezed
class BugModel with _$BugModel {
  const factory BugModel({
    String? dateTime,
    String? newrelicUrl,
    String? stacktTrace,
    String? user,
    String? bugDesc,
  }) = _BugModel;

  factory BugModel.fromJson(Map<String, dynamic> json) =>
      _$BugModelFromJson(json);
}
