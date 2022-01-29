import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';

part 'temp_state.dart';
part 'temp_cubit.freezed.dart';

@injectable
class TempCubit extends Cubit<TempState> {
  TempCubit() : super(TempState.loaded());
  
  void func() {
    state.copyWith(boolValue: false);
  }
}
