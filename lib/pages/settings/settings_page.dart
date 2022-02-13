import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:task_manager/constants/supabase_constants.dart';
import 'package:task_manager/core/auth/auth_required_state.dart';
import 'package:task_manager/core/injection/injection.dart';
import 'package:task_manager/models/enums/external_data_status.dart';
import 'package:task_manager/pages/settings/settings_cubit.dart';
import 'package:task_manager/theme/light_color.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends AuthRequiredState<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<SettingsCubit>()..loadData(),
      child: _SettingsEditForm(),
    );
  }
}

class _SettingsEditForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SettingsCubit, SettingsState>(
      listener: (context, state) {
        if (state.status.isSubmissionFailure) {
          context.showErrorSnackBar(
              message: state.errorMessage ?? 'Could not save settings');
        } else if (state.status.isSubmissionSuccess) {
          Navigator.pop(context);
        }
      },
      builder: (context, state) {
        if (state.dataStatus == ExternalDataStatus.loading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
            floatingActionButton: _SignOutButton(),
          );
        }
        return GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Scaffold(
            appBar: AppBar(
              leading: _SaveSettingsButton(),
              title: const Text('Settings'),
            ),
            floatingActionButton: const _SignOutButton(),
            body: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(12, 24, 12, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(12, 6, 12, 6),
                    child: _FirstNameInput(),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(12, 6, 12, 24),
                    child: _LastNameInput(),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _SaveSettingsButton extends StatelessWidget {
  void _saveSettings(BuildContext context) {
    FocusScope.of(context).unfocus();
    context.read<SettingsCubit>().updateUser();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsCubit, SettingsState>(
      builder: (context, state) {
        return IconButton(
          onPressed: () => state.dataStatus == ExternalDataStatus.success
              ? _saveSettings(context)
              : null,
          icon: state.status.isValid &&
                  !state.status.isSubmissionInProgress &&
                  state.dataStatus == ExternalDataStatus.success
              ? const Icon(Icons.save)
              : const Opacity(opacity: 0.5, child: Icon(Icons.save)),
          tooltip: 'Update settings and navigate back',
        );
      },
    );
  }
}

class _FirstNameInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsCubit, SettingsState>(
      buildWhen: (previous, current) => previous.firstName != current.firstName,
      builder: (context, state) {
        return TextFormField(
          onChanged: context.read<SettingsCubit>().onFirstNameChange,
          keyboardType: TextInputType.name,
          initialValue: state.firstName.value,
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
    return BlocBuilder<SettingsCubit, SettingsState>(
      buildWhen: (previous, current) => previous.lastName != current.lastName,
      builder: (context, state) {
        return TextFormField(
          onChanged: context.read<SettingsCubit>().onLastNameChange,
          initialValue: state.lastName.value,
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

class _SignOutButton extends StatelessWidget {
  const _SignOutButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: context.read<SettingsCubit>().signOut,
      child: const Text(
        'Logout',
        style: TextStyle(color: LightColor.warn),
      ),
      style: OutlinedButton.styleFrom(
        side: const BorderSide(width: 1, color: LightColor.warn),
      ),
    );
  }
}
