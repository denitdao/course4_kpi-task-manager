import 'package:formz/formz.dart';

enum NonEmptyTextValidationError { empty }

class NonNullText extends FormzInput<String?, NonEmptyTextValidationError> {
  const NonNullText.pure() : super.pure(null);

  const NonNullText.dirty([String? value]) : super.dirty(value);

  @override
  NonEmptyTextValidationError? validator(String? value) {
    return (value == null || value.isEmpty)
        ? NonEmptyTextValidationError.empty
        : null;
  }
}
