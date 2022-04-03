import 'package:freezed_annotation/freezed_annotation.dart';

part 'task.freezed.dart';

part 'task.g.dart';

@freezed
class Task with _$Task {
  const factory Task(
    String id,
    String title,
    String description,
    @JsonKey(name: 'subject_id') String subjectId,
    @JsonKey(name: 'due_date') DateTime dueDate,
    @JsonKey(name: 'created_at') DateTime createdAt,
    @JsonKey(name: 'updated_at') DateTime updatedAt,
    @JsonKey(name: 'deleted') bool isDeleted, {
    @JsonKey(name: 'subject_title') @Default('') String subjectTitle,
    @JsonKey(name: 'completed_by') @Default(0) int completedBy,
    @JsonKey(name: 'students_overall') @Default(0) int studentsOverall,
    @JsonKey(name: 'is_done') @Default(false) bool isDone,
  }) = _Task;

  factory Task.fromJson(Map<String, dynamic> json) => _$TaskFromJson(json);
}
