import 'package:either_dart/either.dart';
import 'package:injectable/injectable.dart';
import 'package:task_manager/constants/supabase_constants.dart';
import 'package:task_manager/models/user.dart' as my;

@singleton
class UserRepository {
  // TODO: maybe rewrite to inject 'supabase' object with DI

  Future<Either<String, my.User>> loadCurrentUser() async {
    final user = supabase.auth.currentUser;
    final response = await supabase
        .from('profiles')
        .select('*')
        .eq('id', user!.id)
        .execute();

    final error = response.error;
    if (error != null && response.status != 406) return Left(error.message);

    final data = response.data;

    if (data != null) {
      final loadedUser = my.User.fromJson(data[0]);
      return Right(loadedUser.copyWith(email: user.email));
    }
    return const Left('No user data found');
  }

  Future<Either<String, bool>> updateUser(my.User user) async {
    final newUser = {
      'first_name': user.firstName,
      'last_name': user.lastName,
    };
    final response = await supabase
        .from('profiles')
        .update(newUser)
        .eq('id', user.id)
        .execute();

    final error = response.error;
    if (error != null) return Left(error.message);

    return const Right(true);
  }
}
