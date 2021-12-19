import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:task_manager/constants/supabase_constants.dart';
import 'package:task_manager/core/auth/auth_state.dart';
import 'package:task_manager/core/auth/secrets.dart';

class RegisterStudentPage extends StatefulWidget {
  const RegisterStudentPage({Key? key}) : super(key: key);

  @override
  State<RegisterStudentPage> createState() => _RegisterStudentPageState();
}

class _RegisterStudentPageState extends AuthState<RegisterStudentPage> {
  bool _isLoading = false;
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  late final TextEditingController _firstNameController;
  late final TextEditingController _lastNameController;

  int _selectedIndex = 0;
  List<String> _groups = List.empty();
  String _dropdownValue = '';

  Future _signUp() async {
    FocusScope.of(context).unfocus();

    setState(() {
      _isLoading = true;
    });

    final response = await supabase.auth.signUp(
        _emailController.text, _passwordController.text,
        options: AuthOptions(redirectTo: authRedirectUri));

    // supabase.auth.update(data)
    final error = response.error;
    if (error != null) {
      context.showErrorSnackBar(message: error.message);
    } else if (response.data == null && response.user == null) {
      context.showErrorSnackBar(
          message:
              'Please check your email and follow the instructions to verify your email address.');
    } else {
      final user = supabase.auth.currentUser;
      final firstName = _firstNameController.text;
      final lastName = _lastNameController.text;
      final userProfile = {
        'id': user!.id,
        'first_name': firstName,
        'last_name': lastName,
        'role': 'STUDENT',
      };

      final response =
          await supabase.from('profiles').upsert(userProfile).execute();
      final error = response.error;
      if (error != null) {
        context.showErrorSnackBar(message: error.message);
      } else {
        Navigator.pushNamedAndRemoveUntil(context, '/today', (route) => false);
      }
    }

    setState(() {
      _isLoading = false;
    });
  }

  Future _getProfile() async {
    final response = await supabase.from('groups').select('title').execute();
    final error = response.error;
    if (error != null && response.status != 406) {
      context.showErrorSnackBar(message: error.message);
    }
    final data = response.data;
    if (data != null) {
      print(data);
      _groups = data.map<String>((i) {
        return i['title'] as String;
      }).toList();

      _dropdownValue = _groups.first;
    }
  }

  void _setIndex(value) {
    setState(() {
      _selectedIndex = value;
    });
  }

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _firstNameController = TextEditingController();
    _lastNameController = TextEditingController();
    _getProfile();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
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
          onTap: _setIndex,
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
        body: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(0, 96, 0, 0),
            child: Column(mainAxisSize: MainAxisSize.max, children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 48, 0, 48),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Create new student account",
                      style: Theme.of(context).textTheme.headline6,
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 6, 24, 6),
                child: TextFormField(
                  controller: _firstNameController,
                  decoration: const InputDecoration(
                    labelText: 'First name',
                    hintText: 'Enter your first name...',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 6, 24, 6),
                child: TextFormField(
                  controller: _lastNameController,
                  decoration: const InputDecoration(
                    labelText: 'Last Name',
                    hintText: 'Enter your last name...',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 6, 24, 6),
                child: DropdownButton<String>(
                  value: _dropdownValue,
                  style: const TextStyle(color: Colors.deepPurple),
                  onChanged: (String? newValue) {
                    setState(() {
                      _dropdownValue = newValue!;
                    });
                  },
                  items: _groups.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 6, 24, 6),
                child: TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email Address',
                    hintText: 'Enter your email...',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 6, 24, 24),
                child: TextFormField(
                  controller: _passwordController,
                  decoration: const InputDecoration(
                    labelText: 'Password',
                    hintText: 'Enter your password...',
                    border: OutlineInputBorder(),
                  ),
                  obscureText: true,
                  enableSuggestions: false,
                  autocorrect: false,
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 24, 0, 12),
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _signUp,
                  child: Text(_isLoading ? 'Loading' : 'Sign up'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 24, 0, 6),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [Text("Already have an accout?")],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 6, 0, 0),
                child: TextButton(
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, '/login');
                  },
                  child: const Text("Sign in"),
                ),
              ),
            ]),
          ),
        ),
      ),
    );
  }
}
