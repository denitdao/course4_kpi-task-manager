import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:task_manager/constants/supabase_constants.dart';
import 'package:task_manager/core/auth/auth_state.dart';
import 'package:task_manager/core/auth/secrets.dart';
import 'package:task_manager/screens/register_student.dart';
import 'package:task_manager/screens/register_teacher.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends AuthState<RegisterPage> {
  int _selectedIndex = 0;
  final GroupList _groupList = GroupList();
  late final TextEditingController _emailController;
  late final TextEditingController _firstNameController;
  late final TextEditingController _lastNameController;
  String? _dropdownValue;

  late final List<Widget> _widgetOptions;

  Future _getProfile() async {
    final response = await supabase.from('groups').select('title').execute();
    final error = response.error;
    if (error != null && response.status != 406) {
      context.showErrorSnackBar(message: error.message);
    }
    final data = response.data;
    if (data != null) {
      setState(() {
        _groupList.setGroups(data.map<String>((i) {
          return i['title'] as String;
        }).toList());
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _firstNameController = TextEditingController();
    _lastNameController = TextEditingController();

// pass dropdown value
    _widgetOptions = <Widget>[
      RegisterStudentPage(
        groups: _groupList,
        emailController: _emailController,
        firstNameController: _firstNameController,
        lastNameController: _lastNameController,
      ),
      RegisterTeacherPage(
        emailController: _emailController,
        firstNameController: _firstNameController,
        lastNameController: _lastNameController,
      ),
    ];
    _getProfile();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: (index) {
            setState(() {
              _selectedIndex = index;
            });
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
        body: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(0, 84, 0, 0),
          child: _widgetOptions.elementAt(_selectedIndex),
        ),
      ),
    );
  }
}

class GroupList extends ChangeNotifier {
  List<String> _groups = [];

  List<String> get() => _groups;

  void setGroups(List<String> groups) {
    _groups = groups;
    notifyListeners();
  }
}
