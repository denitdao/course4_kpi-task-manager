import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:task_manager/constants/supabase_constants.dart';
import 'package:task_manager/core/injection/injection.dart';
import 'package:task_manager/pages/register_page/teacher/register_teacher_cubit.dart';

class RegisterTeacherPage extends StatelessWidget {
  const RegisterTeacherPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<RegisterTeacherCubit>(),
      child: const RegisterTeacherForm(),
    );
  }
}

class RegisterTeacherForm extends StatelessWidget {
  const RegisterTeacherForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocListener<RegisterTeacherCubit, RegisterTeacherState>(
      listener: (context, state) {
        if (state.status.isSubmissionFailure) {
          context.showErrorSnackBar(
              message: state.errorMessage ?? 'Authentication Failure');
        } else if (state.status.isSubmissionSuccess) {
          Navigator.pushNamedAndRemoveUntil(
              context, '/today', (route) => false);
        }
      },
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 48, 0, 48),
            child: Text(
              "Create new teacher account",
              style: Theme.of(context).textTheme.headline3,
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 6, 24, 6),
            child: _FirstNameInput(),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 6, 24, 6),
            child: _LastNameInput(),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 6, 24, 6),
            child: _EmailInput(),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 6, 24, 24),
            child: _PasswordInput(),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 24, 0, 12),
            child: _SignUpButton(),
          ),
          const Padding(
            padding: EdgeInsets.fromLTRB(0, 24, 0, 0),
            child: Text("Already have an accout?"),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 6, 0, 0),
            child: _SignInButton(),
          ),
        ],
      ),
    );
  }
}

class _FirstNameInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegisterTeacherCubit, RegisterTeacherState>(
      buildWhen: (previous, current) => previous.firstName != current.firstName,
      builder: (context, state) {
        return TextFormField(
          onChanged: context.read<RegisterTeacherCubit>().onFirstNameChange,
          keyboardType: TextInputType.name,
          decoration: InputDecoration(
            labelText: 'First name',
            hintText: 'Enter your first name...',
            errorText: state.firstName.invalid ? 'invalid name' : null,
            border: const OutlineInputBorder(),
            contentPadding: const EdgeInsets.all(10),
          ),
        );
      },
    );
  }
}

class _LastNameInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegisterTeacherCubit, RegisterTeacherState>(
      buildWhen: (previous, current) => previous.lastName != current.lastName,
      builder: (context, state) {
        return TextFormField(
          onChanged: context.read<RegisterTeacherCubit>().onLastNameChange,
          keyboardType: TextInputType.name,
          decoration: InputDecoration(
            labelText: 'Last name',
            hintText: 'Enter your last name...',
            errorText: state.lastName.invalid ? 'invalid name' : null,
            border: const OutlineInputBorder(),
            contentPadding: const EdgeInsets.all(10),
          ),
        );
      },
    );
  }
}

class _EmailInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegisterTeacherCubit, RegisterTeacherState>(
      buildWhen: (previous, current) => previous.email != current.email,
      builder: (context, state) {
        return TextFormField(
          onChanged: context.read<RegisterTeacherCubit>().onEmailChange,
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
    return BlocBuilder<RegisterTeacherCubit, RegisterTeacherState>(
      buildWhen: (previous, current) => previous.password != current.password,
      builder: (context, state) {
        return TextFormField(
          onChanged: context.read<RegisterTeacherCubit>().onPasswordChange,
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

class _SignUpButton extends StatelessWidget {
  void _signUp(BuildContext context) {
    FocusScope.of(context).unfocus();
    context.read<RegisterTeacherCubit>().signUp();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegisterTeacherCubit, RegisterTeacherState>(
      buildWhen: (previous, current) => previous.status != current.status,
      builder: (context, state) {
        return ElevatedButton(
          onPressed:
              state.status.isValidated && !state.status.isSubmissionInProgress
                  ? () => _signUp(context)
                  : null,
          child:
              Text(state.status.isSubmissionInProgress ? 'Loading' : 'Sign up'),
        );
      },
    );
  }
}

class _SignInButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        Navigator.pushReplacementNamed(context, '/login');
        // () => Navigator.of(context).push<void>(SignUpPage.route()),
      },
      child: const Text('Sign in'),
    );
  }
}
