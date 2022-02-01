import 'package:either_dart/either.dart';
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:task_manager/constants/supabase_constants.dart';
import 'package:task_manager/core/auth/secrets.dart';
import 'package:task_manager/models/group.dart';

@singleton
class GroupRepository {
  Future<Either<String, List<Group>>> getAllGroups() async {
    final response = await supabase.from('groups').select('id, title').execute();

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
}
