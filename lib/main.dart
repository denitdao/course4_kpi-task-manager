import 'package:flutter/material.dart';
import 'package:task_manager/core/injection/injection.dart';
import 'package:task_manager/pages/error_page.dart';
import 'package:task_manager/pages/login_page/login_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:task_manager/pages/register_page/register_page.dart';
import 'package:task_manager/pages/settings/settings_page.dart';
import 'package:task_manager/screens/splash.dart';
import 'package:task_manager/pages/teacher/subject_create_page/subject_create_page.dart';
import 'package:task_manager/pages/teacher/subjects_page/subject_list_page.dart';
import 'package:task_manager/theme/theme.dart';

import 'core/auth/secrets.dart';
import 'pages/student/tasks_page/task_list_student.dart';

// flutter pub run build_runner build --delete-conflicting-outputs

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  configureDependencies();

  await Supabase.initialize(
    url: supabaseUrl,
    anonKey: supabaseAnonKey,
  );

  // rewrite with the use of the approach when we have core AuthState and AuthCubit
  // AuthCubit is provided on the root for all of the pages (in MyApp)
  // AuthState contains data about User - one of three
  // unknown (during token refresh), authorized, unauthorized
  // AuthCubit on it's initialization will try to renew token using authRepository's features
  // authRepository provides a stream with user

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // emit foreach
    return MaterialApp(
      title: 'KPI Task Manager',
      theme: AppTheme.lightTheme,
      home: const SplashScreen(),
      debugShowCheckedModeBanner: false,
      routes: <String, WidgetBuilder>{
        '/login': (_) => const LoginPage(),
        '/register': (_) => const RegisterPage(),
        '/settings': (_) => const SettingsPage(),
        '/error': (BuildContext context) => const ErrorPage(),
        '/subject_create': (_) => const SubjectCreatePage(),
        '/subjects': (_) => const SubjectListPage(),
      },
    );
  }
}
