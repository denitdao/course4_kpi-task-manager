import 'package:bloc/bloc.dart';
import 'package:either_dart/src/future_extension.dart';
import 'package:formz/formz.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:meta/meta.dart';
import 'package:task_manager/core/injection/injection.dart';
import 'package:task_manager/models/enums/external_data_status.dart';
import 'package:task_manager/models/forms/non_empty_text_input.dart';
import 'package:task_manager/models/forms/text_input.dart';
import 'package:task_manager/models/group.dart';
import 'package:task_manager/repositories/group_repository.dart';
import 'package:task_manager/repositories/subject_repository.dart';

part 'subject_create_state.dart';

part 'subject_create_cubit.freezed.dart';

@injectable
class SubjectCreateCubit extends Cubit<SubjectCreateState> {
  late GroupRepository _groupRepository;
  late SubjectRepository _subjectRepository;

  SubjectCreateCubit() : super(const SubjectCreateState.loaded()) {
    _groupRepository = getIt<GroupRepository>();
    _subjectRepository = getIt<SubjectRepository>();
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

  Future<void> createSubject() async {
    final subjectTitle = state.subjectTitle.value;
    if (!state.subjectTitle.valid) {
      emit(state.copyWith(
        errorMessage: 'Specify a subject title!',
        status: FormzStatus.submissionFailure,
      ));
      return;
    }
    final groupId = state.groupId.value;
    if (groupId == null) {
      emit(state.copyWith(
        errorMessage: 'Please choose a group first!',
        status: FormzStatus.submissionFailure,
      ));
      return;
    }

    emit(state.copyWith(status: FormzStatus.submissionInProgress));

    final response = _subjectRepository.createSubject(subjectTitle, groupId);

    response.either(
      (left) => emit(state.copyWith(
        errorMessage: left,
        status: FormzStatus.submissionFailure,
      )),
      (right) => emit(state.copyWith(status: FormzStatus.submissionSuccess)),
    );
  }

  void onGroupChange(String? value) {
    final groupId = NonNullText.dirty(value);
    emit(state.copyWith(
      groupId: groupId,
      status: Formz.validate([
        state.subjectTitle,
        groupId,
      ]),
    ));
  }

  void onSubjectTitleChange(String value) {
    final subjectTitle = NonEmptyText.dirty(value);
    emit(state.copyWith(
      subjectTitle: subjectTitle,
      status: Formz.validate([
        subjectTitle,
        state.groupId,
      ]),
    ));
  }
}
