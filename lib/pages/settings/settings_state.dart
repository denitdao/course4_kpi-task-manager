part of 'settings_cubit.dart';

@freezed
class SettingsState with _$SettingsState {
  const factory SettingsState.loaded({
    @Default(ExternalDataStatus.loading) ExternalDataStatus dataStatus,
    @Default([]) List<Group> groupIds,
    User? user,
    @Default(Name.pure()) Name firstName,
    @Default(Name.pure()) Name lastName,
    @Default(FormzStatus.pure) FormzStatus status,
    String? errorMessage,
  }) = _SettingsState;
}
