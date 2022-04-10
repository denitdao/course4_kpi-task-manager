import 'package:either_dart/either.dart';
import 'package:injectable/injectable.dart';
import 'package:task_manager/constants/supabase_constants.dart';
import 'package:task_manager/models/group.dart';

@singleton
class GroupRepository {
  Future<Either<String, List<Group>>> getAllGroups() async {
    final response = await supabase
        .from('groups')
        .select('id, title')
        .order('title')
        .execute();

    final error = response.error;
    if (error != null && response.status != 406) return Left(error.message);

    final data = response.data;

    if (data != null) {
      return Right(data.map<Group>((i) {
        return Group.fromJson(i);
      }).toList());
    }
    return const Right([]);
  }

  // https://supabase.com/docs/reference/javascript/select#filtering-with-inner-joins
  Future<Either<String, List<Group>>> getGroupsByTeacher(
      String teacherId) async {
    final response = await supabase
        .from('groups')
        .select('id, title, subjects!inner(teacher_id)')
        .eq('subjects.teacher_id', teacherId)
        .eq('subjects.is_inactive', false)
        .order('title')
        .execute();

    final error = response.error;
    if (error != null && response.status != 406) return Left(error.message);

    final data = response.data;

    if (data != null) {
      return Right(data.map<Group>((i) {
        return Group.fromJson(i);
      }).toList());
    }
    return const Right([]);
  }

  Future<Either<String, Group>> getGroupById(String id) async {
    final response = await supabase
        .from('groups')
        .select('id, title, created_at')
        .eq('id', id)
        .execute();

    final error = response.error;
    if (error != null && response.status != 406) return Left(error.message);

    final data = response.data;

    if (data != null) {
      return Right(Group.fromJson(data[0]));
    }
    return const Left('No group found');
  }
}
