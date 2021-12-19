import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:task_manager/constants/supabase_constants.dart';
import 'package:task_manager/core/auth/auth_state.dart';
import 'package:task_manager/core/auth/secrets.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends AuthState<LoginPage> {
  bool _isLoading = false;
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;

  Future _signIn() async {
    FocusScope.of(context).unfocus();

    setState(() {
      _isLoading = true;
    });

    final response = await supabase.auth.signIn(
        email: _emailController.text, password: _passwordController.text);

    final error = response.error;
    if (error != null) {
      context.showErrorSnackBar(message: error.message);
    } else {
      Navigator.pushNamedAndRemoveUntil(context, '/today', (route) => false);
    }

    setState(() {
      _isLoading = false;
    });
  }

  Future _googleSignIn() async {
    FocusScope.of(context).unfocus();

    setState(() {
      _isLoading = true;
    });

    context.showSnackBar(message: 'Redirecting to the Google page');
    supabase.auth.signInWithProvider(
      Provider.google,
      options: AuthOptions(redirectTo: authRedirectUri),
    );

    setState(() {
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
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
                      "Log into this app using existing accout",
                      style: Theme.of(context).textTheme.headline6,
                    )
                  ],
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
                padding: const EdgeInsets.fromLTRB(24, 6, 24, 48),
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
                padding: const EdgeInsets.fromLTRB(0, 48, 0, 6),
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _signIn,
                  child: Text(_isLoading ? 'Loading' : 'Sign in'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 6, 0, 24),
                child: OutlinedButton.icon(
                  onPressed: _isLoading ? null : _googleSignIn,
                  icon: const Icon(MdiIcons.google),
                  label: Text(_isLoading ? 'Loading' : "Sign in with Google"),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 24, 0, 6),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [Text("Don't have an accout?")],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 6, 0, 0),
                child: TextButton(
                  onPressed: () {
                    Navigator.pushReplacementNamed(
                        context, '/register_student');
                  },
                  child: const Text("Sign up"),
                ),
              ),
            ]),
          ),
        ),
      ),
    );
  }
}
