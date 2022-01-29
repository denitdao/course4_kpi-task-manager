import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:task_manager/constants/supabase_constants.dart';
import 'package:task_manager/pages/login_page/login_cubit.dart';

class LoginForm extends StatelessWidget {
  const LoginForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginCubit, LoginState>(
      listener: (context, state) {
        if (state.status.isSubmissionFailure) {
          context.showErrorSnackBar(
              message: state.errorMessage ?? 'Authentication Failure');
        } else if (state.status.isSubmissionSuccess) {
          Navigator.pushNamedAndRemoveUntil(
              context, '/today', (route) => false);
        }
      },
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
          body: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(0, 84, 0, 0),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 48, 0, 48),
                  child: Text(
                    "Log into this app using existing account",
                    style: Theme.of(context).textTheme.headline3,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 6, 24, 6),
                  child: _EmailInput(),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 6, 24, 48),
                  child: _PasswordInput(),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 96, 0, 6),
                  child: _SignInButton(),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 6, 0, 24),
                  child: _GoogleSignInButton(),
                ),
                const Padding(
                  padding: EdgeInsets.fromLTRB(0, 24, 0, 0),
                  child: Text("Don't have an accout?"),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 6, 0, 0),
                  child: _SignUpButton(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _EmailInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginState>(
      buildWhen: (previous, current) => previous.email != current.email,
      builder: (context, state) {
        return TextFormField(
          onChanged: context.read<LoginCubit>().onEmailChange,
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            labelText: 'Email Address',
            hintText: 'Enter your email...',
            errorText: state.email.invalid ? 'invalid email' : null,
            border: const OutlineInputBorder(),
            contentPadding: const EdgeInsets.all(10),
          ),
        );
      },
    );
  }
}

class _PasswordInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginState>(
      buildWhen: (previous, current) => previous.password != current.password,
      builder: (context, state) {
        return TextFormField(
          onChanged: context.read<LoginCubit>().onPasswordChange,
          decoration: InputDecoration(
            labelText: 'Password',
            hintText: 'Enter your password...',
            errorText: state.password.invalid ? 'invalid password' : null,
            border: const OutlineInputBorder(),
            contentPadding: const EdgeInsets.all(10),
          ),
          obscureText: true,
          enableSuggestions: false,
          autocorrect: false,
        );
      },
    );
  }
}

class _SignInButton extends StatelessWidget {
  void _signIn(BuildContext context) {
    FocusScope.of(context).unfocus();
    context.read<LoginCubit>().signIn();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginState>(
      buildWhen: (previous, current) => previous.status != current.status,
      builder: (context, state) {
        return ElevatedButton(
          onPressed:
              state.status.isValidated && !state.status.isSubmissionInProgress
                  ? () => _signIn(context)
                  : null,
          child:
              Text(state.status.isSubmissionInProgress ? 'Loading' : "Sign in"),
        );
      },
    );
  }
}

class _GoogleSignInButton extends StatelessWidget {
  void _signInWithGoogle(BuildContext context) {
    FocusScope.of(context).unfocus();
    context.showSnackBar(message: 'Redirecting to the Google page');

    context.read<LoginCubit>().googleSignIn();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginState>(
      buildWhen: (previous, current) => previous.status != current.status,
      builder: (context, state) {
        return OutlinedButton.icon(
          onPressed: !state.status.isSubmissionInProgress
              ? () => _signInWithGoogle(context)
              : null,
          icon: const Icon(MdiIcons.google),
          label: Text(state.status.isSubmissionInProgress
              ? 'Loading'
              : "Sign in with Google"),
        );
      },
    );
  }
}

class _SignUpButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        Navigator.pushReplacementNamed(context, '/register');
        // () => Navigator.of(context).push<void>(SignUpPage.route()),
      },
      child: const Text("Sign up"),
    );
  }
}
