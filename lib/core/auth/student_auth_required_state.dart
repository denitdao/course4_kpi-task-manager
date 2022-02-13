import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:task_manager/constants/supabase_constants.dart';
import 'package:task_manager/core/injection/injection.dart';
import 'package:task_manager/repositories/user_repository.dart';

class StudentAuthRequiredState<T extends StatefulWidget>
    extends SupabaseAuthRequiredState<T> {
  bool verifiedAccess = false;

  @override
  void onUnauthenticated() {
    if (mounted) {
      Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
    }
  }

  @override
  @mustCallSuper
  void initState() {
    super.initState();
    checkAccess();
  }

  Future<void> checkAccess() async {
    final response = await getIt<UserRepository>().loadCurrentUser();
    response.either(
      (left) => context.showErrorSnackBar(message: left),
      (right) {
        if (right.role == 'STUDENT') {
          print('Allowed STUDENT navigation');
          setState(() {
            verifiedAccess = true;
          });
        } else if (right.role == 'TEACHER') {
          Navigator.pushNamedAndRemoveUntil(
              context, '/subjects', (route) => false);
          Navigator.pushNamed(context, '/error');
        } else {
          Navigator.pushNamedAndRemoveUntil(
              context, '/settings', (route) => false);
        }
      },
    );
  }
}
