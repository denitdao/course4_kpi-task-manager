import 'package:formz/formz.dart';

enum NonEmptyTextValidationError { invalid }

class NonEmptyText extends FormzInput<String, NonEmptyTextValidationError> {
  const NonEmptyText.pure() : super.pure('');

  const NonEmptyText.dirty([String value = '']) : super.dirty(value);

  static final RegExp _nameRegExp = RegExp(
    r'^(.|\s)*\S(.|\s)*$',
  );

  @override
  NonEmptyTextValidationError? validator(String? value) {
    return _nameRegExp.hasMatch(value ?? '')
        ? null
        : NonEmptyTextValidationError.invalid;
  }
}
