import 'package:flutter/material.dart';
import 'package:supabase/supabase.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:task_manager/constants/supabase_constants.dart';

class AuthState<T extends StatefulWidget> extends SupabaseAuthState<T> {
  @override
  void onUnauthenticated() {
    if (mounted) {
      Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
    }
  }

  @override
  Future<void> onAuthenticated(Session session) async {
    if (mounted) {
      final user = supabase.auth.currentUser;
      final response = await supabase
          .from('profiles')
          .select()
          .eq('id', user!.id)
          .execute(count: CountOption.exact);

      if (response.count == 0) {
        context.showSnackBar(message: 'Please first register new account');
        await supabase.rpc('delete_user').execute();
        supabase.auth.signOut();
      } else {
        Navigator.pushNamedAndRemoveUntil(context, '/today', (route) => false);
      }
    }
  }

  @override
  void onPasswordRecovery(Session session) {}

  @override
  void onErrorAuthenticating(String message) {
    context.showErrorSnackBar(message: message);
  }
}
