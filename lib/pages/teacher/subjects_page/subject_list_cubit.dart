import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:meta/meta.dart';
import 'package:task_manager/constants/supabase_constants.dart';
import 'package:task_manager/core/injection/injection.dart';
import 'package:task_manager/models/enums/external_data_status.dart';
import 'package:task_manager/models/group.dart';
import 'package:task_manager/models/subject.dart';
import 'package:task_manager/repositories/group_repository.dart';
import 'package:task_manager/repositories/subject_repository.dart';

part 'subject_list_cubit.freezed.dart';

part 'subject_list_state.dart';

@injectable
class SubjectListCubit extends Cubit<SubjectListState> {
  late GroupRepository _groupRepository;
  late SubjectRepository _subjectRepository;
  final String? _groupId;

  SubjectListCubit(this._groupId) : super(const SubjectListState()) {
    _groupRepository = getIt<GroupRepository>();
    _subjectRepository = getIt<SubjectRepository>();
  }

  Future<void> loadData() async {
    final groupId = _groupId;
    if (groupId == null) {
      _loadDataForAllGroups();
    } else {
      _loadDataForGroup(groupId);
    }
  }

  Future<void> _loadDataForGroup(String groupId) async {
    final subjectResponse = await _subjectRepository.getAllSubjectsByGroup(groupId);
    if (subjectResponse.isRight) {
      emit(state.copyWith(
        subjects: subjectResponse.right,
      ));
    } else {
      emit(state.copyWith(
        errorMessage: subjectResponse.left,
        dataStatus: ExternalDataStatus.fail,
      ));
      return;
    }

    _loadAllGroups();
  }

  Future<void> _loadDataForAllGroups() async {
    final teacherId = supabase.auth.currentUser!.id;
    final subjectResponse = await _subjectRepository.getAllSubjectsByTeacher(teacherId);
    if (subjectResponse.isRight) {
      emit(state.copyWith(
        subjects: subjectResponse.right,
      ));
    } else {
      emit(state.copyWith(
        errorMessage: subjectResponse.left,
        dataStatus: ExternalDataStatus.fail,
      ));
      return;
    }

    _loadAllGroups();
  }

  Future<void> _loadAllGroups() async {
    final groupResponse = await _groupRepository.getAllGroups(); // todo: replace to get groups with teachers subject
    if (groupResponse.isRight) {
      emit(state.copyWith(
        groups: groupResponse.right,
        dataStatus: ExternalDataStatus.success,
      ));
    } else {
      emit(state.copyWith(
        errorMessage: groupResponse.left,
        dataStatus: ExternalDataStatus.fail,
      ));
    }
  }
}
