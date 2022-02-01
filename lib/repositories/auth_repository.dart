import 'package:either_dart/either.dart';
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:task_manager/constants/supabase_constants.dart';
import 'package:task_manager/core/auth/secrets.dart';

@singleton
class AuthRepository {
  // TODO: maybe rewrite to inject 'supabase' object with DI

  Future<Either<String, bool>> signIn(
    String email,
    String password,
  ) async {
    final response =
        await supabase.auth.signIn(email: email, password: password);

    final error = response.error;
    if (error != null) return Left(error.message);

    return const Right(true);
  }

  Future<void> signInWithGoogle() async {
    supabase.auth.signInWithProvider(
      Provider.google,
      options: AuthOptions(redirectTo: authRedirectUri),
    );
  }

  Future<Either<String, bool>> signUpTeacher(
    String email,
    String password,
    String firstName,
    String lastName,
  ) async {
    final signUpResponse = await supabase.auth.signUp(
      email,
      password,
      options: AuthOptions(redirectTo: authRedirectUri),
    );

    final signUpError = signUpResponse.error;
    if (signUpError != null) return Left(signUpError.message);

    if (signUpResponse.data == null && signUpResponse.user == null) {
      return const Left(
          'Please check your email and follow the instructions to verify your email address.');
    }

    final user = supabase.auth.currentUser;
    final userProfile = {
      'id': user!.id,
      'first_name': firstName,
      'last_name': lastName,
      'role': 'TEACHER',
    };

    final profileUpsertResponse =
        await supabase.from('profiles').upsert(userProfile).execute();

    final profileUpsertError = profileUpsertResponse.error;
    if (profileUpsertError != null) return Left(profileUpsertError.message);

    return const Right(true);
  }

  Future<Either<String, bool>> signUpStudent(
    String email,
    String password,
    String firstName,
    String lastName,
    String groupId,
  ) async {
    final signUpResponse = await supabase.auth.signUp(
      email,
      password,
      options: AuthOptions(redirectTo: authRedirectUri),
    );

    final signUpError = signUpResponse.error;
    if (signUpError != null) return Left(signUpError.message);

    if (signUpResponse.data == null && signUpResponse.user == null) {
      return const Left(
          'Please check your email and follow the instructions to verify your email address.');
    }
    final user = supabase.auth.currentUser;
    // create user profile
    final userId = user!.id;
    final userProfile = {
      'id': userId,
      'first_name': firstName,
      'last_name': lastName,
      'role': 'STUDENT',
    };

    final profileUpsertResponse =
        await supabase.from('profiles').upsert(userProfile).execute();

    final profileUpsertError = profileUpsertResponse.error;
    if (profileUpsertError != null) return Left(profileUpsertError.message);

    // connect user and group
    final userGroup = {
      'user_id': userId,
      'group_id': groupId,
    };
    final userGroupUpsertResponse =
        await supabase.from('group_user').upsert(userGroup).execute();

    final userGroupUpsertError = userGroupUpsertResponse.error;
    if (userGroupUpsertError != null) return Left(userGroupUpsertError.message);

    return const Right(true);
  }
}
