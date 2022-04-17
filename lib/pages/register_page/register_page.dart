import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:task_manager/core/auth/auth_state.dart';
import 'package:task_manager/core/injection/injection.dart';
import 'package:task_manager/pages/register_page/register_cubit.dart';
import 'package:task_manager/pages/register_page/student/register_student.dart';
import 'package:task_manager/pages/register_page/teacher/register_teacher.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends AuthState<RegisterPage> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: BlocProvider(
        create: (_) => getIt<RegisterCubit>(),
        child: const RegistrationContainerWidget(),
      ),
    );
  }
}

class RegistrationContainerWidget extends StatelessWidget {
  const RegistrationContainerWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final selectedTab =
        context.select((RegisterCubit cubit) => cubit.state.tab);

    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(0, 84, 0, 0),
        child: IndexedStack(
          index: selectedTab.index,
          children: const [RegisterStudentPage(), RegisterTeacherPage()],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedTab.index,
        onTap: (index) {
          context.read<RegisterCubit>().setTab(RegisterTab.values[index]);
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.menu_book_rounded),
            label: 'Student',
          ),
          BottomNavigationBarItem(
            icon: Icon(MdiIcons.humanMaleBoard),
            label: 'Teacher',
          ),
        ],
      ),
    );
  }
}
