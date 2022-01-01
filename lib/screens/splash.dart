import 'dart:async';

import 'package:flutter/material.dart';
import 'package:task_manager/core/auth/auth_state.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends AuthState<SplashScreen> {
  Timer? recoverSessionTimer;

  @override
  void initState() {
    super.initState();
    const _duration = Duration(seconds: 1);
    recoverSessionTimer = Timer(_duration, () {
      recoverSupabaseSession();
    });
  }

  @override
  void onReceivedAuthDeeplink(Uri uri) {
    if (recoverSessionTimer != null) {
      recoverSessionTimer!.cancel();
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
