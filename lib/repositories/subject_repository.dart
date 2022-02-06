import 'package:either_dart/either.dart';
import 'package:injectable/injectable.dart';
import 'package:task_manager/constants/supabase_constants.dart';
import 'package:task_manager/models/subject.dart';

@singleton
class SubjectRepository {
  Future<Either<String, bool>> createSubject(
      String subjectTitle, String groupId) async {
    final user = supabase.auth.currentUser;
    final newSubject = {
      'teacher_id': user!.id,
      'group_id': groupId,
      'title': subjectTitle,
    };

    final response =
        await supabase.from('subjects').insert(newSubject).execute();
    final error = response.error;
    if (error != null) return Left(error.message);

    return const Right(true);
  }

  Future<Either<String, bool>> updateSubject(Subject subject) async {
    final newSubject = {
      'id': subject.id,
      'title': subject.title,
    };

    final response =
        await supabase.from('subjects').update(newSubject).execute();
    final error = response.error;
    if (error != null) return Left(error.message);

    return const Right(true);
  }

  Future<Either<String, bool>> deleteSubject(String id) async {
    final newSubject = {
      'id': id,
      'is_inactive': true,
    };

    final response =
        await supabase.from('subjects').update(newSubject).execute();
    final error = response.error;
    if (error != null) return Left(error.message);

    return const Right(true);
  }

  Future<Either<String, Subject>> getSubjectById(String id) async {
    final response = await supabase
        .from('subjects')
        .select('id, title, group_id, teacher_id')
        .eq('id', id)
        .execute();

    final error = response.error;
    if (error != null && response.status != 406) return Left(error.message);

    final data = response.data;

    if (data != null) {
      return Right(Subject.fromJson(data[0]));
    }
    return const Left('No subject found');
  }

  Future<Either<String, List<Subject>>> getAllSubjectsByGroup(
      String groupId) async {
    final response = await supabase
        .from('subjects')
        .select('id, title, group_id, teacher_id')
        .eq('group_id', groupId)
        .eq('is_inactive', false)
        .execute();

    final error = response.error;
    if (error != null && response.status != 406) return Left(error.message);

    final data = response.data;

    if (data != null) {
      return Right(data.map<Subject>((i) {
        return Subject.fromJson(i);
      }).toList());
    }
    return const Right([]);
  }

  Future<Either<String, List<Subject>>> getAllSubjectsByTeacher(
      String teacherId) async {
    final response = await supabase
        .from('subjects_extended')
        .select('*')
        .eq('teacher_id', teacherId)
        .execute();

    final error = response.error;
    if (error != null && response.status != 406) return Left(error.message);

    final data = response.data;

    if (data != null) {
      return Right(data.map<Subject>((i) {
        return Subject.fromJson(i);
      }).toList());
    }
    return const Right([]);
  }
}
