import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:task_manager/models/task.dart';

import 'group.dart';

part 'subject.freezed.dart';

part 'subject.g.dart';

@freezed
class Subject with _$Subject {
  const factory Subject(
    String id,
    String title,
    @JsonKey(name: 'group_id') String groupId, {
    @JsonKey(name: 'teacher_id') String? teacherId,
    @JsonKey(name: 'created_at') String? createdAt,
    @JsonKey(name: 'is_inactive') @Default(false) bool isInactive,
    Group? group,
    @JsonKey(name: 'task_amount') @Default(0) int taskAmount,
    @Default([]) List<Task>? tasks,
  }) = _Subject;

  factory Subject.fromJson(Map<String, dynamic> json) =>
      _$SubjectFromJson(json);
}
