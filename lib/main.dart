import 'package:flutter/material.dart';
import 'package:task_manager/modules/screens/login.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:task_manager/modules/screens/splash.dart';

import 'core/auth/secrets.dart';
import 'modules/screens/register_student.dart';
import 'modules/screens/register_teacher.dart';
import 'modules/screens/some.dart';
import 'modules/screens/task_edit.dart';
import 'modules/screens/today.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: supabaseUrl,
    anonKey: supabaseAnonKey,
  );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'KPI Task Manager',
      theme: ThemeData.light().copyWith(
        primaryColor: Colors.deepPurple,
        colorScheme: ColorScheme.fromSwatch(
          accentColor: Colors.deepPurpleAccent,
          primarySwatch: Colors.deepPurple,
        ),
      ),
      home: const SplashScreen(),
      routes: <String, WidgetBuilder>{
        '/login': (_) => const LoginPage(),
        '/register_student': (_) => const RegisterStudentPage(),
        '/register_teacher': (_) => const RegisterTeacherPage(),
        '/today': (BuildContext context) => const TodayPage(title: 'Today'),
        '/this_week': (BuildContext context) =>
            const TodayPage(title: 'This week'),
        '/all': (BuildContext context) => const TodayPage(title: 'All tasks'),
        '/task': (BuildContext context) => const TaskEdit(),
        '/some': (BuildContext context) => const FormWidgetsDemo(),
      },
    );
  }
}
