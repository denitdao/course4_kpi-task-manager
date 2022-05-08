import 'package:either_dart/either.dart';
import 'package:injectable/injectable.dart';
import 'package:task_manager/constants/supabase_constants.dart';
import 'package:task_manager/models/user_task_status.dart';

@singleton
class StatsRepository {
  Future<Either<String, List<UserTaskStatus>>> getStudentsWithTaskStatus(
      String taskId) async {
    final response = await supabase.rpc('get_students_task_status',
        params: {'p_task_id': taskId}).execute();

    final error = response.error;
    if (error != null && response.status != 406) return Left(error.message);

    final data = response.data;

    if (data != null) {
      return Right(data.map<UserTaskStatus>((i) {
        return UserTaskStatus.fromJson(i);
      }).toList());
    }
    return const Right([]);
  }

  Future<Either<String, List<dynamic>>> getWeeklyCompletionRate(
      String subjectId) async {
    final response = await supabase.rpc('get_weekly_task_completion',
        params: {'p_subject_id': subjectId}).execute();

    final error = response.error;
    if (error != null && response.status != 406) return Left(error.message);

    final data = response.data;

    if (data != null) {
      return Right(data);
    }
    return const Right([]);
  }
}
