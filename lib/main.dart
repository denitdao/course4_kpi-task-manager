import 'package:flutter/material.dart';
import 'package:task_manager/modules/screens/login.dart';

import 'modules/screens/register_student.dart';
import 'modules/screens/register_teacher.dart';
import 'modules/screens/some.dart';
import 'modules/screens/today.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'KPI Task Manager',
      theme: ThemeData(
        primaryColor: Colors.deepPurpleAccent,
        primarySwatch: Colors.deepPurple,
        colorScheme: ColorScheme.fromSwatch(
          accentColor: Colors.deepPurpleAccent,
          primarySwatch: Colors.deepPurple,
        ),
      ),
      home: const LoginPage(),
      routes: <String, WidgetBuilder>{
        '/login': (BuildContext context) => const LoginPage(),
        '/register_student': (BuildContext context) => const RegisterStudentPage(),
        '/register_teacher': (BuildContext context) => const RegisterTeacherPage(),
        '/today': (BuildContext context) => const TodayPage(title: 'Today'),
        '/this_week': (BuildContext context) => const TodayPage(title: 'This week'),
        '/all': (BuildContext context) => const TodayPage(title: 'All tasks'),
        '/task': (BuildContext context) => const TodayPage(title: 'Task'),
        '/some': (BuildContext context) => const FormWidgetsDemo(),
      },
    );
  }
}
