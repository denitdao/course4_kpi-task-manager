import 'package:flutter/material.dart';
import 'package:task_manager/screens/login.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:task_manager/screens/register.dart';
import 'package:task_manager/screens/splash.dart';
import 'package:task_manager/screens/subject_create.dart';
import 'package:task_manager/screens/subject_edit.dart';
import 'package:task_manager/screens/task_create.dart';
import 'package:task_manager/screens/task_edit.dart';
import 'package:task_manager/theme/theme.dart';

import 'core/auth/secrets.dart';
import 'screens/some.dart';
import 'screens/today.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: supabaseUrl,
    anonKey: supabaseAnonKey,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'KPI Task Manager',
      theme: AppTheme.lightTheme,
      home: const SplashScreen(),
      routes: <String, WidgetBuilder>{
        '/login': (_) => const LoginPage(),
        '/register': (_) => const RegisterPage(),
        '/today': (BuildContext context) => const TodayPage(title: 'Today'),
        '/this_week': (BuildContext context) =>
            const TodayPage(title: 'This week'),
        '/all': (BuildContext context) => const TodayPage(title: 'All tasks'),
        '/some': (BuildContext context) => const FormWidgetsDemo(),
        '/task_create': (_) => TaskCreate(
              subjectId: 'subject_id',
            ),
        '/task_edit': (_) => TaskEdit(
              id: 'task_id',
            ),
        '/subject_create': (_) => SubjectCreate(),
        '/subject_edit': (_) => SubjectEdit(id: 'subject_id'),
      },
    );
  }
}
