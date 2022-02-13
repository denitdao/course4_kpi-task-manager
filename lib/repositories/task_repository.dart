import 'package:either_dart/either.dart';
import 'package:injectable/injectable.dart';
import 'package:task_manager/constants/supabase_constants.dart';
import 'package:task_manager/models/subject.dart';
import 'package:task_manager/models/task.dart';

@singleton
class TaskRepository {
  Future<Either<String, bool>> createTask(
      String subjectId) async {
    // final user = supabase.auth.currentUser;
    // final newSubject = {
    //   'teacher_id': user!.id,
    //   'group_id': groupId,
    //   'title': subjectTitle,
    // };
    //
    // final response =
    //     await supabase.from('subjects').insert(newSubject).execute();
    // final error = response.error;
    // if (error != null) return Left(error.message);
    //
    return const Right(true);
  }

  Future<Either<String, bool>> updateTask(Task task) async {
    // final newTask = {
    //   'title': subject.title,
    // };
    //
    // final response = await supabase
    //     .from('subjects')
    //     .update(newSubject)
    //     .eq('id', subject.id)
    //     .execute();
    // final error = response.error;
    // if (error != null) return Left(error.message);

    return const Right(true);
  }

  Future<Either<String, bool>> deleteTask(String id) async {
    // final newSubject = {
    //   'id': id,
    //   'is_inactive': true,
    // };
    //
    // final response =
    //     await supabase.from('subjects').update(newSubject).execute();
    // final error = response.error;
    // if (error != null) return Left(error.message);

    return const Right(true);
  }

  Future<Either<String, Task>> getTaskById(String id) async {
    final response = await supabase
        .from('tasks_extended')
        .select('*')
        .eq('id', id)
        .execute();

    final error = response.error;
    if (error != null && response.status != 406) return Left(error.message);

    final data = response.data;

    if (data != null) {
      return Right(Task.fromJson(data[0]));
    }
    return const Left('No task found');
  }

  Future<Either<String, List<Task>>> getAllTaskBySubject(
      String subjectId) async {
    final response = await supabase
        .from('tasks_extended')
        .select('*')
        .eq('subject_id', subjectId)
        .eq('deleted', false)
        .order('created_at')
        .execute();

    final error = response.error;
    if (error != null && response.status != 406) return Left(error.message);

    final data = response.data;

    if (data != null) {
      return Right(data.map<Task>((i) {
        return Task.fromJson(i);
      }).toList());
    }
    return const Right([]);
  }
}
