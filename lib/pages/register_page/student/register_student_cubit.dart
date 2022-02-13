import 'package:bloc/bloc.dart';
import 'package:formz/formz.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:task_manager/core/injection/injection.dart';
import 'package:task_manager/models/enums/external_data_status.dart';
import 'package:task_manager/models/forms/email_input.dart';
import 'package:task_manager/models/forms/name_input.dart';
import 'package:task_manager/models/forms/non_empty_text_input.dart';
import 'package:task_manager/models/forms/password_input.dart';
import 'package:task_manager/models/group.dart';
import 'package:task_manager/repositories/auth_repository.dart';
import 'package:task_manager/repositories/group_repository.dart';

part 'register_student_state.dart';

part 'register_student_cubit.freezed.dart';

@injectable
class RegisterStudentCubit extends Cubit<RegisterStudentState> {
  late AuthRepository _authRepository;
  late GroupRepository _groupRepository;

  RegisterStudentCubit() : super(const RegisterStudentState.loaded()) {
    _authRepository = getIt<AuthRepository>();
    _groupRepository = getIt<GroupRepository>();
  }

  Future<void> signUp() async {
    if (!state.status.isValidated) return;
    final chosenGroupId = state.groupId.value;
    if (chosenGroupId == null) {
      emit(state.copyWith(
        errorMessage: 'Please choose a group first!',
        status: FormzStatus.submissionFailure,
      ));
      return;
    }

    emit(state.copyWith(status: FormzStatus.submissionInProgress));

    final response = await _authRepository.signUpStudent(
      state.email.value,
      state.password.value,
      state.firstName.value,
      state.lastName.value,
      chosenGroupId,
    );

    response.either(
      (left) => emit(state.copyWith(
        errorMessage: left,
        status: FormzStatus.submissionFailure,
      )),
      (right) => emit(state.copyWith(status: FormzStatus.submissionSuccess)),
    );
  }

  void loadGroups() async {
    final response = await _groupRepository.getAllGroups();

    response.either(
      (left) => emit(state.copyWith(
        errorMessage: left,
        dataStatus: ExternalDataStatus.fail,
      )),
      (right) => emit(state.copyWith(
        groupIds: right,
        dataStatus: ExternalDataStatus.success,
      )),
    );
  }

  void onGroupChange(String? value) {
    final groupId = NonNullText.dirty(value);
    emit(state.copyWith(
      groupId: groupId,
      status: Formz.validate([
        state.firstName,
        state.lastName,
        state.email,
        state.password,
        groupId,
      ]),
    ));
  }

  void onFirstNameChange(String value) {
    final firstName = Name.dirty(value);
    emit(state.copyWith(
      firstName: firstName,
      status: Formz.validate([
        firstName,
        state.lastName,
        state.email,
        state.password,
        state.groupId,
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
        state.email,
        state.password,
        state.groupId,
      ]),
    ));
  }

  void onEmailChange(String value) {
    final email = Email.dirty(value);
    emit(state.copyWith(
      email: email,
      status: Formz.validate([
        state.firstName,
        state.lastName,
        email,
        state.password,
        state.groupId,
      ]),
    ));
  }

  void onPasswordChange(String value) {
    final password = Password.dirty(value);
    emit(state.copyWith(
      password: password,
      status: Formz.validate([
        state.firstName,
        state.lastName,
        state.email,
        password,
        state.groupId,
      ]),
    ));
  }
}
