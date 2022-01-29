part of 'temp_cubit.dart';

@freezed
class TempState with _$TempState {
  factory TempState.loaded({
    @Default(false) bool boolValue,
    @Default('') String name,
  }) = _Loaded;
}
