import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:task_manager/constants/supabase_constants.dart';
import 'package:task_manager/core/auth/auth_state.dart';
import 'package:task_manager/core/auth/secrets.dart';

class RegisterTeacherPage extends StatefulWidget {
  const RegisterTeacherPage({
    Key? key,
    required this.emailController,
    required this.firstNameController,
    required this.lastNameController,
  }) : super(key: key);

  final TextEditingController emailController;
  final TextEditingController firstNameController;
  final TextEditingController lastNameController;

  @override
  State<RegisterTeacherPage> createState() => _RegisterTeacherPageState();
}

class _RegisterTeacherPageState extends AuthState<RegisterTeacherPage> {
  bool _isLoading = false;
  late final TextEditingController _emailController = widget.emailController;
  late final TextEditingController _passwordController;
  late final TextEditingController _firstNameController = widget.firstNameController;
  late final TextEditingController _lastNameController = widget.lastNameController;

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
      // apply dropdownValue

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

  @override
  void initState() {
    super.initState();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(mainAxisSize: MainAxisSize.max, children: [
      Padding(
        padding: const EdgeInsets.fromLTRB(0, 48, 0, 48),
        child: Text(
          "Create new teacher account",
          style: Theme.of(context).textTheme.headline3,
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
            contentPadding: EdgeInsets.all(10),
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
            contentPadding: EdgeInsets.all(10),
          ),
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
            contentPadding: EdgeInsets.all(10),
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
            contentPadding: EdgeInsets.all(10),
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
      const Padding(
        padding: EdgeInsets.fromLTRB(0, 24, 0, 0),
        child: Text("Already have an accout?"),
      ),
      Padding(
        padding: const EdgeInsets.fromLTRB(0, 6, 0, 0),
        child: TextButton(
          onPressed: () => Navigator.pushReplacementNamed(context, '/login'),
          child: const Text("Sign in"),
        ),
      ),
    ]);
  }
}
