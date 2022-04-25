import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_task_status.freezed.dart';

part 'user_task_status.g.dart';

@freezed
class UserTaskStatus with _$UserTaskStatus {
  const factory UserTaskStatus(
    String id,
    @JsonKey(name: 'first_name') String firstName,
    @JsonKey(name: 'last_name') String lastName,
    @JsonKey(name: 'is_done') bool isDone, {
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
  }) = _UserTaskStatus;

  factory UserTaskStatus.fromJson(Map<String, dynamic> json) =>
      _$UserTaskStatusFromJson(json);
}
