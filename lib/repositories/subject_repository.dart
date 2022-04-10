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
    final updatedSubject = {
      'title': subject.title,
      'updated_at': DateTime.now().toString(),
    };

    final response = await supabase
        .from('subjects')
        .update(updatedSubject)
        .eq('id', subject.id)
        .execute();
    final error = response.error;
    if (error != null) return Left(error.message);

    return const Right(true);
  }

  Future<Either<String, bool>> deleteSubject(String id) async {
    final toDelete = {
      'is_inactive': true,
      'updated_at': DateTime.now().toString(),
    };

    final response =
        await supabase.from('subjects').update(toDelete).eq('id', id).execute();
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
        .from('subjects_extended')
        .select('*')
        .eq('group_id', groupId)
        .eq('is_inactive', false)
        .order('created_at')
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
        .eq('is_inactive', false)
        .order('created_at')
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

  Future<Either<String, List<Subject>>> getAllSubjectsByStudent(
      String studentId) async {
    final response = await supabase
        .from('groups')
        .select('subjects!inner(*), group_user!inner(user_id)')
        .eq('group_user.user_id', studentId)
        .eq('subjects.is_inactive', false)
        .execute();

    final error = response.error;
    if (error != null && response.status != 406) return Left(error.message);

    final data = response.data;

    if (data != null) {
      return Right(data.first['subjects'].map<Subject>((i) {
        return Subject.fromJson(i);
      }).toList());
    }
    return const Right([]);
  }
}
