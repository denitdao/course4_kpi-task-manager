import 'package:either_dart/either.dart';
import 'package:injectable/injectable.dart';
import 'package:task_manager/constants/supabase_constants.dart';
import 'package:task_manager/models/task.dart';

@singleton
class TaskRepository {
  Future<Either<String, bool>> createTask(
    String subjectId,
    String taskTitle,
    String taskDescription,
    DateTime dueDate,
  ) async {
    final newTask = {
      'subject_id': subjectId,
      'title': taskTitle,
      'description': taskDescription,
      'due_date': dueDate.toString(),
    };

    final response = await supabase.from('tasks').insert(newTask).execute();
    final error = response.error;
    if (error != null) return Left(error.message);

    return const Right(true);
  }

  Future<Either<String, bool>> updateTask(Task task) async {
    final updatedTask = {
      'title': task.title,
      'description': task.description,
      'due_date': task.dueDate.toString(),
      'updated_at': DateTime.now().toString(),
    };

    final response = await supabase
        .from('tasks')
        .update(updatedTask)
        .eq('id', task.id)
        .execute();
    final error = response.error;
    if (error != null) return Left(error.message);

    return const Right(true);
  }

  Future<Either<String, bool>> deleteTask(String id) async {
    final toDelete = {
      'deleted': true,
      'updated_at': DateTime.now().toString(),
    };

    final response =
        await supabase.from('tasks').update(toDelete).eq('id', id).execute();
    final error = response.error;
    if (error != null) return Left(error.message);

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

  Future<Either<String, List<Task>>> getAllTasksBySubject(
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

  Future<Either<String, List<Task>>> getAllTasksByStudent(
      String studentId) async {
    final response = await supabase
        .rpc('get_all_tasks_by_student', params: {'student_id' : studentId})
        .eq('deleted', false)
        // .order('created_at')
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
