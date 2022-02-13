import 'package:bloc/bloc.dart';
import 'package:either_dart/src/future_extension.dart';
import 'package:formz/formz.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:meta/meta.dart';
import 'package:task_manager/core/injection/injection.dart';
import 'package:task_manager/models/enums/external_data_status.dart';
import 'package:task_manager/models/forms/name_input.dart';
import 'package:task_manager/models/forms/non_empty_text_input.dart';
import 'package:task_manager/models/group.dart';
import 'package:task_manager/models/subject.dart';
import 'package:task_manager/models/user.dart';
import 'package:task_manager/repositories/auth_repository.dart';
import 'package:task_manager/repositories/group_repository.dart';
import 'package:task_manager/repositories/subject_repository.dart';
import 'package:task_manager/repositories/user_repository.dart';

part 'settings_state.dart';

part 'settings_cubit.freezed.dart';

@injectable
class SettingsCubit extends Cubit<SettingsState> {
  late AuthRepository _authRepository;
  late UserRepository _userRepository;

  SettingsCubit() : super(const SettingsState.loaded()) {
    _authRepository = getIt<AuthRepository>();
    _userRepository = getIt<UserRepository>();
  }

  void loadData() async {
    final userResponse = await _userRepository.loadCurrentUser();
    if (userResponse.isRight) {
      emit(state.copyWith(
        user: userResponse.right,
        dataStatus: ExternalDataStatus.success,
      ));
      onFirstNameChange(userResponse.right.firstName);
      onLastNameChange(userResponse.right.lastName);
    } else {
      emit(state.copyWith(
        errorMessage: userResponse.left,
        dataStatus: ExternalDataStatus.fail,
      ));
      return;
    }
  }

  Future<void> updateUser() async {
    if (!state.status.isValidated) return;
    emit(state.copyWith(status: FormzStatus.submissionInProgress));

    final updatedUser = state.user!.copyWith(
      firstName: state.firstName.value,
      lastName: state.lastName.value,
    );
    final response = _userRepository.updateUser(updatedUser);

    response.either(
      (left) => emit(state.copyWith(
        errorMessage: left,
        status: FormzStatus.submissionFailure,
      )),
      (right) => emit(state.copyWith(status: FormzStatus.submissionSuccess)),
    );
  }

  Future<void> signOut() async {
    final response = await _authRepository.signOut();

    response.either(
      (left) => emit(state.copyWith(
        errorMessage: left,
        status: FormzStatus.submissionFailure,
      )),
      (right) {
    //     final sharedPreferences = await SharedPreferences.getInstance();
    // sharedPreferences.clear();
      },
    );
  }

  Future<void> deleteUserAccount() async {}

  void onFirstNameChange(String value) {
    final firstName = Name.dirty(value);
    emit(state.copyWith(
      firstName: firstName,
      status: Formz.validate([
        firstName,
        state.lastName,
      ]),
    ));
  }

  void onLastNameChange(String value) {
    final lastName = Name.dirty(value);
    emit(state.copyWith(
      lastName: lastName,
      status: Formz.validate([
        state.firstName,
        lastName,
      ]),
    ));
  }
}
