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
import 'package:task_manager/models/subject.dart';
import 'package:task_manager/repositories/group_repository.dart';
import 'package:task_manager/repositories/subject_repository.dart';

part 'subject_edit_state.dart';

part 'subject_edit_cubit.freezed.dart';

@injectable
class SubjectEditCubit extends Cubit<SubjectEditState> {
  late GroupRepository _groupRepository;
  late SubjectRepository _subjectRepository;

  SubjectEditCubit() : super(const SubjectEditState.loaded()) {
    _groupRepository = getIt<GroupRepository>();
    _subjectRepository = getIt<SubjectRepository>();
  }

  void loadData(String subjectId) async {
    final subjectResponse = await _subjectRepository.getSubjectById(subjectId);
    if (subjectResponse.isRight) {
      emit(state.copyWith(
        subject: subjectResponse.right,
      ));
      onSubjectTitleChange(subjectResponse.right.title);
    } else {
      emit(state.copyWith(
        errorMessage: subjectResponse.left,
        dataStatus: ExternalDataStatus.fail,
      ));
      return;
    }

    final groupResponse =
        await _groupRepository.getGroupById(state.subject!.groupId);

    groupResponse.either(
      (left) => emit(state.copyWith(
        errorMessage: left,
        dataStatus: ExternalDataStatus.fail,
      )),
      (right) => emit(state.copyWith(
        groupIds: [right],
        dataStatus: ExternalDataStatus.success,
      )),
    );
  }

  Future<void> updateSubject() async {
    final subjectTitle = state.subjectTitle.value;
    if (!state.subjectTitle.valid) {
      emit(state.copyWith(
        errorMessage: 'Specify a subject title!',
        status: FormzStatus.submissionFailure,
      ));
      return;
    }
    emit(state.copyWith(status: FormzStatus.submissionInProgress));

    final updatedSubject = state.subject!.copyWith(title: subjectTitle);
    final response = _subjectRepository.updateSubject(updatedSubject);

    response.either(
      (left) => emit(state.copyWith(
        errorMessage: left,
        status: FormzStatus.submissionFailure,
      )),
      (right) => emit(state.copyWith(status: FormzStatus.submissionSuccess)),
    );
  }

  Future<void> deleteSubject() async {
    emit(state.copyWith(status: FormzStatus.submissionInProgress));

    final response = _subjectRepository.deleteSubject(state.subject!.id);

    response.either(
      (left) => emit(state.copyWith(
        errorMessage: left, // todo Replace in all places to the custom message
        status: FormzStatus.submissionFailure,
      )),
      (right) => emit(state.copyWith(status: FormzStatus.submissionSuccess)),
    );
  }

  void onSubjectTitleChange(String value) {
    final subjectTitle = NonEmptyText.dirty(value);
    emit(state.copyWith(
      subjectTitle: subjectTitle,
      status: Formz.validate([subjectTitle]),
    ));
  }
}
