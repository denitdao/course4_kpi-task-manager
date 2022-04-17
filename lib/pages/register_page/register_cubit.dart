import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

part 'register_cubit.freezed.dart';
part 'register_state.dart';

@injectable
class RegisterCubit extends Cubit<RegisterState> {
  RegisterCubit() : super(const RegisterState.student());

  void setTab(RegisterTab tab) {
    if (state.tab == tab) return;
    if (tab == RegisterTab.student) {
      emit(const RegisterState.student());
    } else if (tab == RegisterTab.teacher) {
      emit(const RegisterState.teacher());
    }
  }
}
