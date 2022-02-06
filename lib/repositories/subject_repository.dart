import 'package:either_dart/either.dart';
import 'package:injectable/injectable.dart';
import 'package:task_manager/constants/supabase_constants.dart';

@singleton
class SubjectRepository {
  Future<Either<String, bool>> createSubject(String subjectTitle, String groupId) async {
    final user = supabase.auth.currentUser;
    final newSubject = {
      'teacher_id': user!.id,
      'group_id': groupId,
      'title': subjectTitle,
    };

    final response = await supabase.from('subjects').insert(newSubject).execute();
    final error = response.error;
    if (error != null) return Left(error.message);

    return const Right(true);
  }
}
